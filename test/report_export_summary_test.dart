import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:insulog/globals.dart';
import 'package:insulog/states/report_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

http.Response summary(int average) => http.Response(
  jsonEncode({
    'media': average,
    'totalBaixos': 1,
    'totalNormais': 2,
    'totalAlertas': 3,
    'registros': [],
  }),
  200,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    Globals().setUserId(19);
    ReportState().closeExportReport();
    ReportState().selectExportPeriod(ReportExportPeriod.week);
  });
  tearDown(() {
    ReportState().closeExportReport();
    Globals().setUserId(0);
  });

  test(
    'consulta resumo do período incluindo último dia e preserva tela anterior',
    () async {
      final state = ReportState();
      final previousAverage = state.media;
      state.selectExportWeekRange(
        DateTimeRange(start: DateTime(2026, 8, 30), end: DateTime(2026, 9, 7)),
      );
      final client = MockClient((request) async {
        expect(request.url.path, '/registros-glicose/usuario/19/historico');
        expect(request.url.queryParameters, {
          'dataInicio': '2026-08-30 00:00:00',
          'dataFim': '2026-09-07 23:59:59',
        });
        return summary(123);
      });
      await http.runWithClient(state.refreshExportSummary, () => client);
      expect(state.exportSummary!.media, 123);
      expect(state.exportSummary!.totalBaixos, 1);
      expect(state.exportSummary!.totalNormais, 2);
      expect(state.exportSummary!.totalAlertas, 3);
      expect(state.media, previousAverage);
      expect(state.isLoadingExportSummary, isFalse);
    },
  );

  test('resposta atrasada não substitui resumo da semana atual', () async {
    final state = ReportState();
    final firstResponse = Completer<http.Response>();
    final firstRequested = Completer<void>();
    final first = http.runWithClient(
      state.refreshExportSummary,
      () => MockClient((_) {
        firstRequested.complete();
        return firstResponse.future;
      }),
    );
    await firstRequested.future;
    state.selectExportWeekRange(
      DateTimeRange(start: DateTime(2026, 9, 1), end: DateTime(2026, 9, 3)),
    );
    expect(state.exportSummary, isNull);
    await http.runWithClient(
      state.refreshExportSummary,
      () => MockClient((_) async => summary(110)),
    );
    firstResponse.complete(summary(200));
    await first;
    expect(state.exportSummary!.media, 110);
  });

  test('erro limpa valores antigos e permite nova tentativa', () async {
    final state = ReportState();
    await http.runWithClient(
      state.refreshExportSummary,
      () => MockClient((_) async => summary(125)),
    );
    await http.runWithClient(
      state.refreshExportSummary,
      () => MockClient((_) async => http.Response('{}', 500)),
    );
    expect(state.exportSummary, isNull);
    expect(state.exportSummaryError, isNotNull);
    expect(state.isLoadingExportSummary, isFalse);
    await http.runWithClient(
      state.refreshExportSummary,
      () => MockClient((_) async => summary(130)),
    );
    expect(state.exportSummary!.media, 130);
    expect(state.exportSummaryError, isNull);
  });
}

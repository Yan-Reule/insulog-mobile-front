import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:insulog/globals.dart';
import 'package:insulog/screens/report_export_screen.dart';
import 'package:insulog/services/api/report_export_service.dart';
import 'package:insulog/states/report_state.dart';
import 'package:insulog/widgets/custom_button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
    'envia seleção, mostra loading, bloqueia duplicação e libera após erro',
    (tester) async {
      tester.view.physicalSize = const Size(430, 932);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({});
      Globals().setUserId(19);
      final state = ReportState();
      state.selectExportPeriod(ReportExportPeriod.week);
      final range = DateTimeRange(
        start: DateTime(2026, 9, 16),
        end: DateTime(2026, 9, 24),
      );
      state.selectExportWeekRange(range);
      state.selectExportFormat(ReportFormat.xlsx);
      final response = Completer<http.Response>();
      var requests = 0;
      final client = MockClient((request) {
        requests++;
        expectSync(request.url.queryParameters, {
          'id_usuario': '19',
          'dataInicio': '2026-09-16',
          'dataFim': '2026-09-24',
          'formato': 'xlsx',
        });
        return response.future;
      });
      await http.runWithClient(
        () => tester.pumpWidget(
          MaterialApp(
            locale: const Locale('pt', 'BR'),
            supportedLocales: const [Locale('pt', 'BR')],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            home: ReportExportScreen(state: state),
          ),
        ),
        () => MockClient(
          (_) async => http.Response(
            jsonEncode({
              'registros': [],
              'media': 0,
              'totalBaixos': 0,
              'totalNormais': 0,
              'totalAlertas': 0,
            }),
            200,
            headers: {'content-type': 'application/json; charset=utf-8'},
          ),
        ),
      );
      await tester.pumpAndSettle();
      final buttonFinder = find.byWidgetPredicate(
        (widget) => widget is CustomButtonWidget && widget.text == 'Exportar',
      );
      expect(
        tester.widget<CustomButtonWidget>(buttonFinder).onPressed,
        isNotNull,
      );
      http.runWithClient(
        () => tester.widget<CustomButtonWidget>(buttonFinder).onPressed!(),
        () => client,
      );
      await tester.pump();
      expect(state.isExporting, isTrue);
      expect(tester.widget<CustomButtonWidget>(buttonFinder).isLoading, isTrue);
      expect(tester.widget<CustomButtonWidget>(buttonFinder).onPressed, isNull);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await state.exportReport(tester.element(find.byType(ReportExportScreen)));
      await tester.pump();
      expect(requests, 1);
      response.complete(
        http.Response(
          jsonEncode({'error': 'Nenhum registro no período'}),
          404,
          headers: {'content-type': 'application/json; charset=utf-8'},
        ),
      );
      await tester.pumpAndSettle();
      expect(state.isExportBusy, isFalse);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(
        tester.widget<CustomButtonWidget>(buttonFinder).onPressed,
        isNotNull,
      );
      expect(find.text('Nenhum registro no período'), findsOneWidget);
      expect(tester.takeException(), isNull);
      Globals().setUserId(0);
      client.close();
    },
  );

  test('mês usa o mês inteiro; semana usa intervalo editado', () {
    final state = ReportState();
    state.selectExportPeriod(ReportExportPeriod.month);
    expect(state.exportStart.day, 1);
    expect(state.exportEnd.add(const Duration(days: 1)).day, 1);
    expect(state.exportStart.month, state.exportEnd.month);
    final range = DateTimeRange(
      start: DateTime(2026, 8, 30),
      end: DateTime(2026, 9, 7),
    );
    state.selectExportWeekRange(range);
    state.selectExportPeriod(ReportExportPeriod.week);
    expect(state.exportStart, range.start);
    expect(state.exportEnd, range.end);
  });
}

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:insulog/screens/options.dart';
import 'package:insulog/globals.dart';
import 'package:insulog/services/local/saved_login_service.dart';
import 'package:insulog/states/options_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('fecha, reabre e confirma o dialogo sem controlador descartado', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final submittedCodes = <String>[];
    await http.runWithClient(
      () async {
        await tester.pumpWidget(const MaterialApp(home: OptionsPage()));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Inserir código'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'descartar');
        await tester.tap(find.text('Cancelar'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(tester.takeException(), isNull);
        await tester.pumpAndSettle();

        await tester.tap(find.text('Inserir código'));
        await tester.pumpAndSettle();
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller?.text ??
              '',
          isEmpty,
        );
        await tester.enterText(find.byType(TextField), ' insu-teste ');
        await tester.tap(find.text('Vincular'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        expect(tester.takeException(), isNull);
        await tester.pumpAndSettle();
        expect(submittedCodes, ['INSU-TESTE']);
        expect(find.byType(AlertDialog), findsNothing);
        expect(tester.takeException(), isNull);
      },
      () => MockClient((request) async {
        if (request.method == 'POST') {
          submittedCodes.add(
            jsonDecode(request.body)['codigo_vinculo'] as String,
          );
        }
        return http.Response('{}', 200);
      }),
    );
  });

  testWidgets('atualiza o medico e bloqueia novo envio durante o vinculo', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final response = Completer<http.Response>();
    var linked = false;
    await http.runWithClient(
      () async {
        await tester.pumpWidget(const MaterialApp(home: OptionsPage()));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Inserir código'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'INSU-TESTE');
        await tester.tap(find.text('Vincular'));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        expect(find.text('Vinculando...'), findsOneWidget);
        expect(
          tester
              .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Vinculando...'),
              )
              .onPressed,
          isNull,
        );
        linked = true;
        response.complete(http.Response('{}', 200));
        await tester.pumpAndSettle();
        expect(find.text('Médico vinculado'), findsOneWidget);
        expect(find.text('Dra. Ana'), findsOneWidget);
        expect(find.text('ana@example.com'), findsOneWidget);
        expect(OptionsState().isLinking, isFalse);
      },
      () => MockClient((request) async {
        if (request.method == 'POST') return response.future;
        return http.Response(
          jsonEncode(
            linked
                ? {
                    'medico': {'nome': 'Dra. Ana', 'email': 'ana@example.com'},
                  }
                : {},
          ),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      }),
    );
  });

  testWidgets('permite tentar novamente apos falha na consulta e no codigo', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    var reads = 0;
    await http.runWithClient(
      () async {
        await tester.pumpWidget(const MaterialApp(home: OptionsPage()));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Tentar novamente'));
        await tester.pumpAndSettle();
        expect(reads, 2);
        await tester.tap(find.text('Inserir código'));
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(TextField), 'INVALIDO');
        await tester.tap(find.text('Vincular'));
        await tester.pumpAndSettle();
        expect(find.text('Codigo invalido'), findsOneWidget);
        expect(OptionsState().isLinking, isFalse);
        expect(
          tester
              .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Inserir código'),
              )
              .onPressed,
          isNotNull,
        );
        expect(tester.takeException(), isNull);
      },
      () => MockClient((request) async {
        if (request.method == 'POST') {
          return http.Response('{"message":"Codigo invalido"}', 400);
        }
        reads++;
        return reads == 1
            ? http.Response('{"message":"Falha na consulta"}', 503)
            : http.Response('{}', 200);
      }),
    );
  });

  testWidgets('sair limpa a sessao e retorna ao login', (tester) async {
    SharedPreferences.setMockInitialValues({
      'saved_user_id': 1,
      'saved_username': 'teste',
      'saved_password': 'teste',
    });
    Globals().setUserId(1);
    Globals().setUsername('teste');
    Globals().setToken('token-teste');
    await http.runWithClient(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: const OptionsPage(),
          routes: {
            '/login': (_) => const Scaffold(body: Text('Tela de login')),
          },
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Sair'));
      await tester.tap(find.text('Sair'));
      await tester.pumpAndSettle();
      expect(find.text('Tela de login'), findsOneWidget);
      expect(find.byType(OptionsPage), findsNothing);
      expect(await SavedLoginService().getCredentials(), isNull);
      expect(Globals().userId, 0);
      expect(Globals().username, isEmpty);
      expect(Globals().token, isEmpty);
      expect(tester.takeException(), isNull);
    }, () => MockClient((_) async => http.Response('{}', 200)));
  });
}

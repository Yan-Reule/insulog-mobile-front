import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:insulog/screens/login.dart';
import 'package:insulog/widgets/login/login_form_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('mostra o login enquanto a tentativa automatica esta pendente', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'saved_user_id': 19,
      'saved_username': 'carlos@example.com',
      'saved_password': 'senha-teste',
    });
    final response = Completer<http.Response>();

    await http.runWithClient(() async {
      await tester.pumpWidget(
        MaterialApp(
          home: const LoginScreen(),
          routes: {'/home': (_) => const Scaffold(body: Text('Home'))},
        ),
      );
      await tester.pump();

      expect(find.byType(Loginform), findsOneWidget);
      expect(find.text('Nome ou e-mail'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(response.isCompleted, isFalse);

      response.complete(
        http.Response(
          jsonEncode({
            'token': 'token-teste',
            'user': {'id': 19, 'username': 'Carlos'},
          }),
          200,
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsOneWidget);
    }, () => MockClient((_) => response.future));
  });
}

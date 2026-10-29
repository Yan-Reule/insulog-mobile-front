import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:insulog/globals.dart';
import 'package:insulog/states/home_screen_state.dart';

void main() {
  testWidgets('abrir Home preserva nome do perfil com email salvo no login', (tester) async {
    SharedPreferences.setMockInitialValues({
      'saved_user_id': 19,
      'saved_username': 'carlos@example.com',
      'saved_password': 'senha-teste',
    });
    Globals().setUserId(19);
    Globals().setUsername('Carlos Silva');
    late BuildContext screenContext;
    await tester.pumpWidget(MaterialApp(home: Builder(builder: (context) {
      screenContext = context;
      return const Scaffold();
    })));
    await http.runWithClient(
      () => HomeScreenState().openScreen(screenContext),
      () => MockClient((_) async => http.Response('[]', 200)),
    );
    expect(Globals().username, 'Carlos Silva');
    expect(HomeScreenState().returnNameLogin(), 'Carlos');
    expect(HomeScreenState().returnFirstNameCaractere(), 'C');
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });

  tearDown(() => Globals().clearUsername());

  test('saudacao usa primeiro nome sem alterar o nome do perfil', () {
    Globals().setUsername('  Carlos   Silva  ');
    expect(HomeScreenState().returnNameLogin(), 'Carlos');
    expect(HomeScreenState().returnFirstNameCaractere(), 'C');
    expect(Globals().username, '  Carlos   Silva  ');
  });

  test('saudacao nunca usa email como nome', () {
    Globals().setUsername('carlos@example.com');
    expect(HomeScreenState().returnNameLogin(), isEmpty);
    expect(HomeScreenState().returnFirstNameCaractere(), isEmpty);
  });
}

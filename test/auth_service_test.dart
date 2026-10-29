import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:insulog/services/api/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<LoginData> loginWith(Object response) => http.runWithClient(
    () => AuthService().login('teste', 'senha-teste'),
    () => MockClient((_) async => http.Response(jsonEncode(response), 200)),
  );

  test('aceita token na raiz com id dentro de user, como na API', () async {
    final result = await loginWith({
      'token': 'token-teste',
      'token_type': 'Bearer',
      'expires_in': 86400,
      'user': {
        'id': 19,
        'username': 'Nome Teste',
        'email': 'teste@example.com',
        'tipo_usuario': 'paciente',
      },
    });
    expect(result.userId, 19);
    expect(result.name, 'Nome Teste');
    expect(result.email, 'teste@example.com');
    expect(result.token, 'token-teste');
  });

  test('preserva suporte ao token dentro de user', () async {
    final result = await loginWith({
      'user': {'id': 19, 'token': 'token-teste'},
    });
    expect(result.token, 'token-teste');
    expect(result.name, isEmpty);
    expect(result.email, isEmpty);
  });

  test('login por email busca nome do perfil quando resposta omite nome', () async {
    final result = await http.runWithClient(
      () => AuthService().login('carlos@example.com', 'senha-teste'),
      () => MockClient((request) async {
        if (request.method == 'POST') {
          return http.Response(jsonEncode({'user': {'id': 19, 'token': 'token-teste'}}), 200);
        }
        expect(request.url.path, endsWith('/usuarios/19'));
        expect(request.headers['Authorization'], 'Bearer token-teste');
        return http.Response(jsonEncode({'nome': 'Carlos Silva', 'email': 'carlos@example.com'}), 200);
      }),
    );
    expect(result.name, 'Carlos Silva');
  });

  test('informa token ausente sem culpar o id', () async {
    await expectLater(
      loginWith({
        'user': {'id': 19},
      }),
      throwsA(
        isA<AuthException>().having(
          (error) => error.message,
          'mensagem',
          contains('token de acesso'),
        ),
      ),
    );
  });

  test('informa id ausente quando ha token', () async {
    await expectLater(
      loginWith({'token': 'token-teste'}),
      throwsA(
        isA<AuthException>().having(
          (error) => error.message,
          'mensagem',
          contains('id do usuario'),
        ),
      ),
    );
  });
}

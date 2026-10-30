import 'package:flutter_test/flutter_test.dart';
import 'package:insulog/security/access_guard.dart';
import 'package:insulog/security/bot_guard.dart';
import 'package:insulog/security/input_sanitizer.dart';
import 'package:insulog/services/local/saved_login_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  group('Segurança do app', () {
    test('IDOR: rejeita acesso cruzado entre usuários diferentes', () {
      expect(
        () => AccessGuard.assertUserScope(12, authenticatedUserId: 5),
        throwsA(isA<SecurityException>()),
      );

      expect(
        () => AccessGuard.assertUserScope(12, authenticatedUserId: 12),
        returnsNormally,
      );
    });

    test('Criptografia: a senha não é armazenada em texto puro', () async {
      final service = SavedLoginService();
      await service.clearCredentials();
      await service.saveCredentials(
        userId: 41,
        username: 'joao',
        password: 'senhaSuperSecreta123',
        token: 'tok-abc',
      );

      final saved = await service.getCredentials();
      expect(saved, isNotNull);
      expect(saved!.passwordHash, isNot('senhaSuperSecreta123'));
      expect(saved.passwordHash, isNotEmpty);
      expect(saved.token, 'tok-abc');
    });

    test('Injeção: sanitiza strings com scripts e payloads maliciosos', () {
      const maliciousInput = 'alert(1); <script>evil()</script> javascript:alert(1)';

      final sanitized = InputSanitizer.sanitizeText(maliciousInput);

      expect(sanitized, isNot(contains('<script')));
      expect(sanitized, isNot(contains('javascript:')));
      expect(sanitized, isNot(contains('alert(1)')));
    });

    test('Bots: bloqueia tentativas repetidas e campos honeypot', () {
      final attempts = [
        DateTime.now(),
        DateTime.now().subtract(const Duration(seconds: 1)),
        DateTime.now().subtract(const Duration(seconds: 2)),
        DateTime.now().subtract(const Duration(seconds: 3)),
        DateTime.now().subtract(const Duration(seconds: 4)),
      ];

      expect(
        BotGuard.isAllowed(attempts: attempts, honeypot: ''),
        isFalse,
      );

      expect(
        BotGuard.isAllowed(attempts: attempts, honeypot: 'value'),
        isFalse,
      );

      expect(
        BotGuard.isAllowed(attempts: attempts.take(3).toList(), honeypot: ''),
        isTrue,
      );
    });
  });
}

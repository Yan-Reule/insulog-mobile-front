import 'package:insulog/globals.dart';

class SecurityException implements Exception {
  const SecurityException(this.message);

  final String message;

  @override
  String toString() => 'SecurityException: $message';
}

class AccessGuard {
  static void assertUserScope(int targetUserId, {int? authenticatedUserId}) {
    final currentUserId = authenticatedUserId ?? Globals().userId;

    if (currentUserId <= 0) {
      throw const SecurityException('Sessão inválida ou expirada.');
    }

    if (targetUserId != currentUserId) {
      throw SecurityException(
        'Acesso negado. O usuário $targetUserId não pertence à sessão ativa.',
      );
    }
  }
}

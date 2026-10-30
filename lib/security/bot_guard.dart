class BotGuard {
  static const int _maxAttemptsPerWindow = 5;
  static const Duration _window = Duration(seconds: 10);

  static bool isAllowed({
    required List<DateTime> attempts,
    required String honeypot,
    DateTime? now,
  }) {
    final current = now ?? DateTime.now();
    final recent = attempts.where(
      (attempt) => current.difference(attempt) <= _window,
    );

    return honeypot.trim().isEmpty && recent.length < _maxAttemptsPerWindow;
  }
}

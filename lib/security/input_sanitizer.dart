class InputSanitizer {
  static String sanitizeText(String value) {
    if (value.isEmpty) return value;

    var sanitized = value.replaceAll(RegExp(r'[\x00-\x1F\x7F]'), '');
    sanitized = sanitized.replaceAll(
      RegExp(r'<\s*(script|iframe|object|embed|svg|img)\b[^>]*>', caseSensitive: false),
      '',
    );
    sanitized = sanitized.replaceAll(RegExp(r'on\w+\s*=', caseSensitive: false), '');
    sanitized = sanitized.replaceAll(
      RegExp(r'javascript\s*:', caseSensitive: false),
      '',
    );
    sanitized = sanitized.replaceAll(RegExp(r'eval\s*\(', caseSensitive: false), '');
    sanitized = sanitized.replaceAll(
      RegExp(r'document\.cookie', caseSensitive: false),
      '',
    );
    sanitized = sanitized.replaceAll(RegExp(r'alert\s*\(', caseSensitive: false), '');

    return sanitized.trim();
  }

  static dynamic sanitizeValue(dynamic value) {
    if (value is String) {
      return sanitizeText(value);
    }

    if (value is Map) {
      return value.map((key, nestedValue) {
        final sanitizedKey = key is String ? sanitizeText(key) : key;
        return MapEntry(sanitizedKey, sanitizeValue(nestedValue));
      });
    }

    if (value is List) {
      return value.map(sanitizeValue).toList();
    }

    return value;
  }

  static Map<String, dynamic> sanitizePayload(Map<String, dynamic> payload) {
    final sanitized = <String, dynamic>{};
    for (final entry in payload.entries) {
      final key = sanitizeText(entry.key);
      sanitized[key] = sanitizeValue(entry.value);
    }
    return sanitized;
  }
}

// Project imports:

/// Simple PII sanitizer for logs/telemetry.
/// Redacts common sensitive keys/values and emails/tokens in strings.
class PiiSanitizer {
  static const String redacted = '[REDACTED]';

  static final RegExp _emailRegex = RegExp(
    r'[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}',
    caseSensitive: false,
  );

  static final RegExp _bearerRegex =
      RegExp(r'Bearer\s+[A-Za-z0-9\-._~+/]+=*', caseSensitive: false);

  static final Set<String> _sensitiveKeys = {
    'authorization',
    'auth',
    'token',
    'access_token',
    'refresh_token',
    'password',
    'api_key',
    'apikey',
    'secret',
    'anon_key',
    'service_role_key',
    'supabase_key',
    'email',
  };

  static String sanitizeString(String input) {
    var out = input;
    out = out.replaceAll(_emailRegex, redacted);
    out = out.replaceAll(_bearerRegex, 'Bearer $redacted');
    return out;
  }

  static Map<String, dynamic> sanitizeMap(Map<String, dynamic> input) {
    final result = <String, dynamic>{};
    for (final entry in input.entries) {
      final keyLower = entry.key.toLowerCase();
      final value = entry.value;
      if (_sensitiveKeys.contains(keyLower)) {
        result[entry.key] = redacted;
        continue;
      }
      if (value is String) {
        result[entry.key] = sanitizeString(value);
      } else if (value is Map<String, dynamic>) {
        result[entry.key] = sanitizeMap(value);
      } else if (value is Iterable) {
        result[entry.key] = value
            .map((v) => v is String
                ? sanitizeString(v)
                : v is Map<String, dynamic>
                    ? sanitizeMap(v)
                    : v)
            .toList();
      } else {
        result[entry.key] = value;
      }
    }
    return result;
  }
}

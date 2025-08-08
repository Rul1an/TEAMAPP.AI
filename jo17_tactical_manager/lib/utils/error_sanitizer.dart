import 'package:flutter/foundation.dart';

class ErrorSanitizer {
  static const _redacted = 'Internal server error';
  static const _maxLen = 900;

  static String sanitize(Object error, [StackTrace? stack]) {
    final raw = error.toString();
    final lowered = raw.toLowerCase();

    const blocked = <String>[
      'postgres', 'postgrest', 'database', 'sql', 'stack trace',
      'exception', 'supabase', 'psql', 'syntax error', 'relation '
    ];

    final containsSensitive = blocked.any(lowered.contains) || lowered.contains('exception');
    if (containsSensitive) {
      if (kDebugMode) {
        // ignore: avoid_print
        print('[ERROR-RAW] $raw');
        if (stack != null) {
          // ignore: avoid_print
          print('[STACK] $stack');
        }
      }
      return _redacted;
    }

    var out = raw;
    if (out.length > _maxLen) {
      out = '${out.substring(0, _maxLen)}…';
    }

    if (kDebugMode) {
      // ignore: avoid_print
      print('[ERROR-RAW] $raw');
      if (stack != null) {
        // ignore: avoid_print
        print('[STACK] $stack');
      }
    }
    return out;
  }

  static String fromHttp(int? status, Object error, [StackTrace? stack]) {
    if (status != null && status >= 400 && status < 500) {
      return sanitize('Request failed ($status)');
    }
    return sanitize(error, stack);
  }
}

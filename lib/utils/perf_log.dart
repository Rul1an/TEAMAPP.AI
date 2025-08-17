// Lightweight perf logger for web console diagnostics
// Always safe for production; logs are concise and rate-limited by call sites

// ignore_for_file: avoid_print

class PerfLog {
  static void log(String message) {
    final ts = DateTime.now().toIso8601String();
    print('[PERF] $ts | $message');
  }

  static Future<T> timeAsync<T>(String label, Future<T> Function() fn) async {
    final sw = Stopwatch()..start();
    try {
      final result = await fn();
      sw.stop();
      log('$label completed in ${sw.elapsedMilliseconds} ms');
      return result;
    } catch (e) {
      sw.stop();
      log('$label failed after ${sw.elapsedMilliseconds} ms: $e');
      rethrow;
    }
  }
}

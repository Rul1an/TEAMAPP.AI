// This file is auto-generated as part of logger-abstraction task.

// Package imports:
import 'package:logger/logger.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../services/pii_sanitizer.dart';

/// Centralized application logger that:
/// 1. Prints prettified logs to the console (debug mode).
/// 2. Sends every log line to Sentry as a breadcrumb so that errors have full
///    context.
/// 3. Captures error-level logs as standalone non-fatal Sentry events.
class AppLogger {
  AppLogger._();

  static final Logger _logger = Logger(
    // Show nice formatted output in debug; in release a different printer can
    // be plugged in if desired.
    printer: PrettyPrinter(methodCount: 0),
    output: MultiOutput([ConsoleOutput(), _SentryLogOutput()]),
  );

  /// Trace-level message.
  static void t(dynamic message, [Object? error, StackTrace? st]) =>
      _logger.t(message, error: error, stackTrace: st);

  /// Debug-level message.
  static void d(dynamic message, [Object? error, StackTrace? st]) =>
      _logger.d(message, error: error, stackTrace: st);

  /// Info-level message.
  static void i(dynamic message, [Object? error, StackTrace? st]) =>
      _logger.i(message, error: error, stackTrace: st);

  /// Warning-level message.
  static void w(dynamic message, [Object? error, StackTrace? st]) =>
      _logger.w(message, error: error, stackTrace: st);

  /// Error-level message.
  static void e(dynamic message, [Object? error, StackTrace? st]) =>
      _logger.e(message, error: error, stackTrace: st);
}

/// Custom [LogOutput] that forwards logs to Sentry as breadcrumbs (and as
/// events for error-level logs).
class _SentryLogOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    final sentryLevel = _toSentryLevel(event.level);

    for (final line in event.lines) {
      final sanitized = PiiSanitizer.sanitizeString(line);
      // Record breadcrumb for every log.
      Sentry.addBreadcrumb(
        Breadcrumb(message: sanitized, level: sentryLevel, category: 'log'),
      );

      // Capture standalone event for error & fatal levels.
      if (event.level.index >= Level.error.index) {
        Sentry.captureMessage(sanitized, level: sentryLevel);
      }
    }
  }

  SentryLevel _toSentryLevel(Level level) {
    switch (level) {
      case Level.trace:
      case Level.debug:
        return SentryLevel.debug;
      case Level.info:
        return SentryLevel.info;
      case Level.warning:
        return SentryLevel.warning;
      case Level.error:
        return SentryLevel.error;
      case Level.fatal:
        return SentryLevel.fatal;
      case Level.all:
        return SentryLevel.debug;
      case Level.off:
        return SentryLevel.debug;
      default:
        return SentryLevel.debug;
    }
  }
}

// lib/services/ui_error_handler.dart

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

/// 🚨 UI Error Handler Service (2025 Best Practices)
///
/// Implements comprehensive error handling following Flutter 2025 standards:
/// - Global error catching
/// - User-friendly error displays
/// - Graceful degradation
/// - Performance monitoring
/// - Null safety protection
class UIErrorHandler {
  static bool _initialized = false;
  static final List<String> _recentErrors = [];
  static const int _maxRecentErrors = 10;

  /// Initialize comprehensive error handling system
  static void initialize() {
    if (_initialized) return;
    _initialized = true;

    // 1. Global Flutter Framework Error Handler
    FlutterError.onError = (FlutterErrorDetails details) {
      _logError('Flutter Framework Error', details.exception, details.stack);

      // Send to crash reporting service in production
      if (kReleaseMode) {
        _sendToCrashReporting(details);
      }

      // Still show in debug for development
      if (kDebugMode) {
        FlutterError.presentError(details);
      }
    };

    // 2. Global Dart Error Handler (Flutter 3+)
    PlatformDispatcher.instance.onError = (error, stack) {
      _logError('Dart Runtime Error', error, stack);

      if (kReleaseMode) {
        _sendToCrashReporting(FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: 'dart runtime',
        ));
      }

      return true; // Prevents app from crashing
    };

    // 3. Custom Error Widget Builder
    ErrorWidget.builder = _buildUserFriendlyErrorWidget;

    print('🛡️ UI Error Handler initialized - 2025 Edition');
  }

  /// Build user-friendly error widget instead of red error screens
  static Widget _buildUserFriendlyErrorWidget(FlutterErrorDetails details) {
    // Different error types get different UI treatments
    final errorType = _categorizeError(details.exception);

    return Material(
      child: Container(
        color: Colors.grey[50],
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              _getErrorIcon(errorType),
              size: 48,
              color: Colors.orange[400],
            ),
            const SizedBox(height: 16),
            Text(
              _getErrorTitle(errorType),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _getErrorMessage(errorType),
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton.icon(
                  onPressed: _triggerAppRefresh,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Probeer opnieuw'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue[600],
                  ),
                ),
                const SizedBox(width: 16),
                if (kDebugMode)
                  TextButton.icon(
                    onPressed: () {
                      _showErrorDetailsDialog(details);
                    },
                    icon: const Icon(Icons.bug_report),
                    label: const Text('Details'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.orange[600],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Categorize error types for targeted handling
  static ErrorType _categorizeError(dynamic exception) {
    final exceptionString = exception.toString().toLowerCase();

    if (exceptionString.contains('nosuchmethoderror')) {
      if (exceptionString.contains('tostringasfixed') ||
          exceptionString.contains('todouble') ||
          exceptionString.contains('toint')) {
        return ErrorType.numericOperation;
      }
      return ErrorType.methodNotFound;
    }

    if (exceptionString.contains('null') ||
        exceptionString.contains('type \'null\'')) {
      return ErrorType.nullReference;
    }

    if (exceptionString.contains('range') ||
        exceptionString.contains('index')) {
      return ErrorType.rangeError;
    }

    if (exceptionString.contains('network') ||
        exceptionString.contains('socket')) {
      return ErrorType.network;
    }

    return ErrorType.general;
  }

  static IconData _getErrorIcon(ErrorType type) {
    switch (type) {
      case ErrorType.numericOperation:
        return Icons.calculate_outlined;
      case ErrorType.nullReference:
        return Icons.error_outline;
      case ErrorType.methodNotFound:
        return Icons.build_outlined;
      case ErrorType.rangeError:
        return Icons.list_alt_outlined;
      case ErrorType.network:
        return Icons.wifi_off_outlined;
      case ErrorType.general:
        return Icons.warning_outlined;
    }
  }

  static String _getErrorTitle(ErrorType type) {
    switch (type) {
      case ErrorType.numericOperation:
        return 'Rekenprobleem gedetecteerd';
      case ErrorType.nullReference:
        return 'Gegevens niet beschikbaar';
      case ErrorType.methodNotFound:
        return 'Functie niet beschikbaar';
      case ErrorType.rangeError:
        return 'Bereik overschreden';
      case ErrorType.network:
        return 'Verbindingsprobleem';
      case ErrorType.general:
        return 'Er ging iets mis';
    }
  }

  static String _getErrorMessage(ErrorType type) {
    switch (type) {
      case ErrorType.numericOperation:
        return 'Een berekening kon niet worden uitgevoerd.\nDit wordt automatisch opgelost.';
      case ErrorType.nullReference:
        return 'De gevraagde informatie is tijdelijk\nniet beschikbaar.';
      case ErrorType.methodNotFound:
        return 'Deze functie is momenteel niet\nbeschikbaar.';
      case ErrorType.rangeError:
        return 'Er werd geprobeerd toegang te krijgen\ntot niet-bestaande gegevens.';
      case ErrorType.network:
        return 'Controleer je internetverbinding\nen probeer opnieuw.';
      case ErrorType.general:
        return 'Er is een onverwacht probleem opgetreden.\nDit wordt onderzocht.';
    }
  }

  /// Safe numeric operations wrapper
  static String safeToStringAsFixed(dynamic value, int fractionDigits) {
    try {
      if (value == null) return '0.${'0' * fractionDigits}';

      final numValue = value is num ? value : double.tryParse(value.toString());
      if (numValue == null || numValue.isNaN || numValue.isInfinite) {
        return '0.${'0' * fractionDigits}';
      }

      return numValue.toStringAsFixed(fractionDigits);
    } catch (e) {
      _logError('SafeToStringAsFixed', e, StackTrace.current);
      return '0.${'0' * fractionDigits}';
    }
  }

  /// Safe double conversion
  static double safeToDouble(dynamic value, {double defaultValue = 0.0}) {
    try {
      if (value == null) return defaultValue;
      if (value is double) return value;
      if (value is int) return value.toDouble();

      final parsed = double.tryParse(value.toString());
      return parsed ?? defaultValue;
    } catch (e) {
      _logError('SafeToDouble', e, StackTrace.current);
      return defaultValue;
    }
  }

  /// Safe integer conversion
  static int safeToInt(dynamic value, {int defaultValue = 0}) {
    try {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is double) return value.round();

      final parsed = int.tryParse(value.toString());
      return parsed ?? defaultValue;
    } catch (e) {
      _logError('SafeToInt', e, StackTrace.current);
      return defaultValue;
    }
  }

  /// Log errors for debugging and monitoring
  static void _logError(String context, dynamic error, StackTrace? stack) {
    final timestamp = DateTime.now().toIso8601String();
    final errorMsg = '🚨 [$context] $error';

    // Add to recent errors for monitoring
    _recentErrors.add('$timestamp: $errorMsg');
    if (_recentErrors.length > _maxRecentErrors) {
      _recentErrors.removeAt(0);
    }

    // Console logging
    if (kDebugMode) {
      print('════════════════════════════════════════');
      print('🚨 UI ERROR DETECTED - $context');
      print('Time: $timestamp');
      print('Error: $error');
      if (stack != null) {
        print('Stack: ${stack.toString().split('\n').take(5).join('\n')}');
      }
      print('════════════════════════════════════════');
    }

    // Forward to Sentry when available (non-debug)
    if (kReleaseMode) {
      Sentry.captureException(
        error,
        stackTrace: stack,
        withScope: (scope) => scope.setTag('ui_error_context', context),
      );
    }
  }

  /// Send to crash reporting service (implement your preferred service)
  static void _sendToCrashReporting(FlutterErrorDetails details) {
    // Unified crash reporting via Sentry when DSN is configured
    Sentry.captureException(details.exception, stackTrace: details.stack);
  }

  /// Trigger app refresh
  static void _triggerAppRefresh() {
    // Force widget tree rebuild
    WidgetsBinding.instance.reassembleApplication();
  }

  /// Show detailed error dialog (debug mode only)
  static void _showErrorDetailsDialog(FlutterErrorDetails details) {
    // Implementation for debug dialog
  }

  /// Get recent errors for monitoring dashboard
  static List<String> getRecentErrors() => List.from(_recentErrors);

  /// Clear error history
  static void clearErrorHistory() => _recentErrors.clear();
}

/// Error type categorization for targeted handling
enum ErrorType {
  numericOperation,
  nullReference,
  methodNotFound,
  rangeError,
  network,
  general,
}

/// Global zone error handling wrapper
void runAppWithErrorHandling(Widget app) {
  runZonedGuarded(
    () {
      UIErrorHandler.initialize();
      runApp(app);
    },
    (error, stackTrace) {
      // Catch any errors not handled by Flutter framework
      if (kDebugMode) {
        print('🚨 Unhandled Zone Error: $error');
        print('Stack: $stackTrace');
      }

      // Log for monitoring
      UIErrorHandler._logError('Zone Error', error, stackTrace);
    },
  );
}

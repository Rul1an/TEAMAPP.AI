import 'package:flutter/foundation.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import '../services/telemetry_service.dart';

/// Enhanced monitoring service for production-ready SaaS application
/// Implements comprehensive error tracking, performance monitoring, and analytics
class MonitoringService {
  static const String _sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
  );

  /// 🔧 CASCADE OPERATOR DOCUMENTATION - MONITORING SERVICE CONFIGURATION
  ///
  /// This initialization method demonstrates configuration callback patterns where
  /// cascade notation (..) could significantly improve readability and maintainability
  /// of service configuration in SaaS monitoring systems.
  ///
  /// **CURRENT PATTERN**: options.property = value (explicit assignments)
  /// **RECOMMENDED**: options..property = value (cascade notation)
  ///
  /// **CASCADE BENEFITS FOR SERVICE CONFIGURATION**:
  /// ✅ Eliminates 10+ repetitive "options." references
  /// ✅ Creates visual grouping of configuration settings
  /// ✅ Improves readability of complex service initialization
  /// ✅ Follows Flutter/Dart best practices for callback configuration
  /// ✅ Enhances maintainability of monitoring service setup
  /// ✅ Reduces cognitive load when reviewing configuration
  ///
  /// **MONITORING SERVICE SPECIFIC ADVANTAGES**:
  /// - Sentry configuration with multiple options
  /// - Performance monitoring settings grouped logically
  /// - Error filtering callback configuration
  /// - Transaction and breadcrumb callback setup
  /// - Consistent with other service configuration patterns
  ///
  /// **SERVICE CONFIGURATION TRANSFORMATION EXAMPLE**:
  /// ```dart
  /// // Current (verbose configuration assignments):
  /// options.dsn = _sentryDsn;
  /// options.environment = kReleaseMode ? "production" : "staging";
  /// options.release = "jo17-tactical-manager@1.0.0";
  /// options.tracesSampleRate = 0.1;
  ///
  /// // With cascade notation (fluent configuration):
  /// options
  ///   ..dsn = _sentryDsn
  ///   ..environment = kReleaseMode ? "production" : "staging"
  ///   ..release = "jo17-tactical-manager@1.0.0"
  ///   ..tracesSampleRate = 0.1;
  /// ```  /// Initialize monitoring services
  static Future<void> initialize() async {
    if (_sentryDsn.isNotEmpty && !kDebugMode) {
      await SentryFlutter.init(
        (options) {
          options
            ..dsn = _sentryDsn
            ..environment = kReleaseMode ? 'production' : 'staging'
            ..release = 'jo17-tactical-manager@1.0.0'
            ..tracesSampleRate = 0.1 // 10% of transactions
            ..profilesSampleRate = 0.1 // 10% for profiling
            ..beforeSend = (event, hint) {
              // Filter out development errors
              if (kDebugMode) return null;

              // Filter out known non-critical errors
              final rawError = event.throwable;
              if (rawError != null) {
                final rawErrorStr = rawError.toString();
                if (rawErrorStr.contains('SocketException')) {
                  // Network errors are handled gracefully
                  return null;
                }
              }

              return event;
            }
            ..beforeSendTransaction = (transaction, hint) {
              return transaction;
            }
            ..beforeBreadcrumb =
                (Breadcrumb? breadcrumb, Hint? hint) => breadcrumb;
        },
      );
    }
  }

  /// Track custom events for business metrics
  static Future<void> trackEvent({
    required String name,
    Map<String, dynamic>? parameters,
    String? userId,
    String? userRole,
    String? organizationId,
  }) async {
    TelemetryService().trackEvent(name, attributes: {
      ...?parameters,
      'user_id': userId,
      'user_role': userRole,
      'organization_id': organizationId,
    });

    await Sentry.addBreadcrumb(
      Breadcrumb(
        message: name,
        data: {
          ...?parameters,
          'user_id': userId,
          'user_role': userRole,
          'organization_id': organizationId,
          'timestamp': DateTime.now().toIso8601String(),
        },
        category: 'custom_event',
        level: SentryLevel.info,
      ),
    );
  }

  /// Track AI feature usage
  static Future<void> trackAIUsage({
    required String feature,
    required String action,
    Map<String, dynamic>? metadata,
    String? userId,
  }) async {
    final transaction = Sentry.startTransaction(
      'ai_feature',
      '$feature.$action',
      description: 'AI feature usage tracking',
    );

    await (transaction
          ..setData('feature', feature)
          ..setData('action', action)
          ..setData('user_id', userId)
          ..setData('metadata', metadata))
        .finish();

    await trackEvent(
      name: 'ai_feature_used',
      parameters: {
        'feature': feature,
        'action': action,
        'metadata': metadata,
      },
      userId: userId,
    );
  }

  /// Track user journey and onboarding
  static Future<void> trackUserJourney({
    required String step,
    required String status, // 'started', 'completed', 'failed'
    String? userId,
    String? userRole,
    Map<String, dynamic>? context,
  }) async {
    await trackEvent(
      name: 'user_journey',
      parameters: {
        'step': step,
        'status': status,
        'context': context,
      },
      userId: userId,
      userRole: userRole,
    );
  }

  /// Track performance metrics
  static Future<void> trackPerformance({
    required String operation,
    required Duration duration,
    bool success = true,
    String? errorMessage,
    Map<String, dynamic>? metadata,
  }) async {
    TelemetryService().trackEvent('performance', attributes: {
      'operation': operation,
      'duration_ms': duration.inMilliseconds,
      'success': success,
      'error_message': errorMessage,
    });

    final transaction = Sentry.startTransaction(
      'performance',
      operation,
      description: 'Performance tracking',
    );

    await (transaction
          ..setData('duration_ms', duration.inMilliseconds)
          ..setData('success', success)
          ..setData('error_message', errorMessage)
          ..setData('metadata', metadata))
        .finish(
      status:
          success ? const SpanStatus.ok() : const SpanStatus.internalError(),
    );
  }

  /// Track business metrics
  static Future<void> trackBusinessMetric({
    required String metric,
    required double value,
    String? unit,
    Map<String, dynamic>? tags,
    String? userId,
    String? organizationId,
  }) async {
    await trackEvent(
      name: 'business_metric',
      parameters: {
        'metric': metric,
        'value': value,
        'unit': unit,
        'tags': tags,
      },
      userId: userId,
      organizationId: organizationId,
    );
  }

  /// Set user context for all subsequent events
  static Future<void> setUserContext({
    required String userId,
    String? email,
    String? role,
    String? organizationId,
    String? organizationTier,
    Map<String, dynamic>? additionalData,
  }) async {
    await Sentry.configureScope((scope) {
      scope.setUser(
        SentryUser(
          id: userId,
          email: email,
          data: {
            'role': role,
            'organization_id': organizationId,
            'organization_tier': organizationTier,
            ...?additionalData,
          },
        ),
      );
    });
  }

  /// Clear user context (e.g., on logout)
  static Future<void> clearUserContext() async {
    await Sentry.configureScope((scope) {
      scope.setUser(null);
    });
  }

  /// Report custom errors with context
  static Future<void> reportError({
    required dynamic error,
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? extra,
    SentryLevel level = SentryLevel.error,
  }) async {
    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope
          ..setTag('error_context', context ?? 'error_occurred')
          ..level = level;
      },
    );
  }

  /// Track feature adoption
  static Future<void> trackFeatureAdoption({
    required String feature,
    required String action, // 'discovered', 'first_use', 'regular_use'
    String? userId,
    String? userRole,
    String? organizationTier,
  }) async {
    await trackEvent(
      name: 'feature_adoption',
      parameters: {
        'feature': feature,
        'action': action,
        'organization_tier': organizationTier,
      },
      userId: userId,
      userRole: userRole,
    );
  }

  /// Track conversion funnel
  static Future<void> trackConversion({
    required String funnel,
    required String step,
    required String action, // 'entered', 'completed', 'dropped_off'
    String? userId,
    Map<String, dynamic>? metadata,
  }) async {
    await trackEvent(
      name: 'conversion_funnel',
      parameters: {
        'funnel': funnel,
        'step': step,
        'action': action,
        'metadata': metadata,
      },
      userId: userId,
    );
  }

  /// Performance monitoring wrapper for async operations
  static Future<T> monitorAsync<T>({
    required String operation,
    required Future<T> Function() function,
    Map<String, dynamic>? metadata,
  }) async {
    final stopwatch = Stopwatch()..start();
    bool success = true;
    String? errorMessage;

    try {
      final result = await function();
      return result;
    } catch (error, stackTrace) {
      success = false;
      errorMessage = error.toString();
      await reportError(
        error: error,
        stackTrace: stackTrace,
        context: 'Performance monitoring: $operation',
        extra: metadata,
      );
      rethrow;
    } finally {
      stopwatch.stop();
      await trackPerformance(
        operation: operation,
        duration: stopwatch.elapsed,
        success: success,
        errorMessage: errorMessage,
        metadata: metadata,
      );
    }
  }
}

/// Mixin for easy monitoring integration in widgets and services
mixin MonitoringMixin {
  Future<void> trackEvent(String name, {Map<String, dynamic>? parameters}) =>
      MonitoringService.trackEvent(name: name, parameters: parameters);

  Future<void> trackError(
    dynamic error, {
    StackTrace? stackTrace,
    String? context,
  }) =>
      MonitoringService.reportError(
        error: error,
        stackTrace: stackTrace,
        context: context,
      );

  Future<T> monitorOperation<T>(
    String operation,
    Future<T> Function() function,
  ) =>
      MonitoringService.monitorAsync(
        operation: operation,
        function: function,
      );
}

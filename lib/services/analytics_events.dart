// Defines standardized analytics events and a small logger that forwards
// events to MonitoringService with a testable injection point.

// Flutter imports:
import 'package:flutter/foundation.dart';

// Project imports:
import 'monitoring_service.dart';

/// Standardized analytics events across the app (2025 best practices)
enum AnalyticsEvent {
  authLogin,
  authLogout,
  roleSwitch,
  playerCreate,
  playerUpdate,
  playerDelete,
  trainingCreate,
  trainingPublish,
  exportPdf,
  exportCsv,
}

/// Maps enum to canonical dotted names
String analyticsEventName(AnalyticsEvent event) {
  switch (event) {
    case AnalyticsEvent.authLogin:
      return 'auth.login';
    case AnalyticsEvent.authLogout:
      return 'auth.logout';
    case AnalyticsEvent.roleSwitch:
      return 'role.switch';
    case AnalyticsEvent.playerCreate:
      return 'player.create';
    case AnalyticsEvent.playerUpdate:
      return 'player.update';
    case AnalyticsEvent.playerDelete:
      return 'player.delete';
    case AnalyticsEvent.trainingCreate:
      return 'training.create';
    case AnalyticsEvent.trainingPublish:
      return 'training.publish';
    case AnalyticsEvent.exportPdf:
      return 'export.pdf';
    case AnalyticsEvent.exportCsv:
      return 'export.csv';
  }
}

/// Lightweight analytics logger with testable sink
class AnalyticsLogger {
  const AnalyticsLogger({AnalyticsSink? sink}) : _sink = sink ?? _defaultSink;

  final AnalyticsSink _sink;

  static Future<void> _defaultSink(
    String name, {
    Map<String, dynamic>? parameters,
    String? userId,
    String? userRole,
    String? organizationId,
  }) async {
    await MonitoringService.trackEvent(
      name: name,
      parameters: parameters,
      userId: userId,
      userRole: userRole,
      organizationId: organizationId,
    );
  }

  /// Logs an analytics event with standardized naming
  Future<void> log(
    AnalyticsEvent event, {
    Map<String, dynamic>? parameters,
    String? userId,
    String? userRole,
    String? organizationId,
  }) async {
    final name = analyticsEventName(event);
    // Basic parameter sanitation to avoid nulls
    final sanitized = <String, dynamic>{
      if (parameters != null)
        ...parameters
            .map((k, v) => MapEntry(k, v is ValueListenable ? v.value : v)),
    };
    await _sink(
      name,
      parameters: sanitized.isEmpty ? null : sanitized,
      userId: userId,
      userRole: userRole,
      organizationId: organizationId,
    );
  }
}

typedef AnalyticsSink = Future<void> Function(
  String name, {
  Map<String, dynamic>? parameters,
  String? userId,
  String? userRole,
  String? organizationId,
});

import 'dart:async';

import 'package:firebase_analytics/firebase_analytics.dart';

import '../services/consent_service.dart';

/// Analytics wrapper with consent gating and safe fallbacks.
class AnalyticsService {
  static final AnalyticsService instance = AnalyticsService();

  FirebaseAnalytics? _analytics;
  bool _initTried = false;

  Future<void> _ensureInitialized() async {
    if (_analytics != null || _initTried) return;
    _initTried = true;
    try {
      // FirebaseAnalytics is lazily available when Firebase is initialized.
      _analytics = FirebaseAnalytics.instance;
    } catch (_) {
      // Leave as null if Firebase not initialized or unsupported on platform
      _analytics = null;
    }
  }

  Future<bool> _hasConsent() async {
    try {
      final Map<String, bool> flags = await ConsentService().getConsent();
      return flags['analytics'] ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Logs a custom event when consent is granted. Silently no-ops otherwise.
  Future<void> logEvent(
    String name, {
    Map<String, Object>? parameters,
  }) async {
    // Respect user consent
    if (!await _hasConsent()) return;

    // Initialize analytics if available
    await _ensureInitialized();
    final FirebaseAnalytics? analytics = _analytics;
    if (analytics == null) return; // Safe no-op

    // Firebase Analytics enforces snake_case names and value types
    final String safeName = name.replaceAll(' ', '_').toLowerCase();
    final Map<String, Object> safeParams = <String, Object>{};
    if (parameters != null) {
      for (final MapEntry<String, Object> e in parameters.entries) {
        final String key = e.key.replaceAll(' ', '_').toLowerCase();
        final Object value = e.value;
        // Allow only simple JSON-serializable scalars
        if (value is num || value is String || value is bool) {
          safeParams[key] = value;
        } else {
          safeParams[key] = value.toString();
        }
      }
    }

    try {
      await analytics.logEvent(name: safeName, parameters: safeParams);
    } catch (_) {
      // Swallow analytics errors to never affect UX
    }
  }

  /// Logs a screen_view event using platform-supported API when possible.
  Future<void> logScreenView(String screenName) async {
    if (!await _hasConsent()) return;
    await _ensureInitialized();
    final FirebaseAnalytics? analytics = _analytics;
    if (analytics == null) return;

    try {
      // Prefer dedicated API when present
      await analytics.logScreenView(screenName: screenName);
    } catch (_) {
      // Fall back to custom event if needed
      await logEvent('screen_view', parameters: {'screen_name': screenName});
    }
  }
}

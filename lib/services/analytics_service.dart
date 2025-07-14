// AnalyticsService – thin wrapper around FirebaseAnalytics

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class AnalyticsService {
  AnalyticsService._();
  static final instance = AnalyticsService._();

  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logScreenView(String name) async {
    await _analytics.logScreenView(screenName: name);
    debugPrint('Analytics: screen_view $name');
  }

  Future<void> logEvent(String name, {Map<String, Object?>? params}) async {
    await _analytics.logEvent(name: name, parameters: params);
    debugPrint('Analytics: event $name $params');
  }
}
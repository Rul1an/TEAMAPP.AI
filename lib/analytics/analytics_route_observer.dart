import 'package:flutter/widgets.dart';

import '../services/analytics_service.dart';
import '../services/performance_tracker.dart';

class AnalyticsRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    final screenName = route.settings.name ?? route.runtimeType.toString();
    _log(screenName);
    PerformanceTracker.instance.startRouteTrace(screenName);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      _log(previousRoute.settings.name ?? previousRoute.runtimeType.toString());
      PerformanceTracker.instance.startRouteTrace(
        previousRoute.settings.name ?? previousRoute.runtimeType.toString(),
      );
    }
    super.didPop(route, previousRoute);
  }

  void _log(String screenName) {
    AnalyticsService.instance.logScreenView(screenName);
  }
}

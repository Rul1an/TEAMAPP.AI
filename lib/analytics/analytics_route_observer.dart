import 'package:flutter/widgets.dart';

import '../services/analytics_service.dart';

class AnalyticsRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _log(route.settings.name ?? route.runtimeType.toString());
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (previousRoute != null) {
      _log(previousRoute.settings.name ?? previousRoute.runtimeType.toString());
    }
    super.didPop(route, previousRoute);
  }

  void _log(String screenName) {
    AnalyticsService.instance.logScreenView(screenName);
  }
}

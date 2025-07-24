class AnalyticsService {
  static final AnalyticsService instance = AnalyticsService();

  Future<void> logEvent(
    String name, {
    Map<String, Object?>? parameters,
  }) async {}

  Future<void> logScreenView(String screenName) async {
    // TODO: integrate FirebaseAnalytics once dependency added
    await logEvent('screen_view', parameters: {'screen_name': screenName});
  }
}

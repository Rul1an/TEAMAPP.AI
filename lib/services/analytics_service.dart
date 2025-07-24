class AnalyticsService {
  static final AnalyticsService instance = AnalyticsService();

  Future<void> logEvent(String name,
      {Map<String, Object?>? parameters}) async {}
}

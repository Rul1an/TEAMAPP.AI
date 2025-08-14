import 'package:flutter_test/flutter_test.dart';
import 'package:jo17_tactical_manager/services/analytics_events.dart';

void main() {
  group('AnalyticsEvent naming', () {
    test('maps to canonical names', () {
      expect(analyticsEventName(AnalyticsEvent.authLogin), 'auth.login');
      expect(analyticsEventName(AnalyticsEvent.trainingPublish),
          'training.publish');
      expect(analyticsEventName(AnalyticsEvent.exportCsv), 'export.csv');
    });
  });

  group('AnalyticsLogger', () {
    test('forwards to sink with sanitized parameters', () async {
      String? capturedName;
      Map<String, dynamic>? capturedParams;
      final logger = AnalyticsLogger(sink: (
        name, {
        Map<String, dynamic>? parameters,
        String? userId,
        String? userRole,
        String? organizationId,
      }) async {
        capturedName = name;
        capturedParams = parameters;
      });

      await logger.log(
        AnalyticsEvent.playerUpdate,
        parameters: {'id': 'p1', 'fields': 3},
      );

      expect(capturedName, 'player.update');
      expect(capturedParams, isNotNull);
      expect(capturedParams!['id'], 'p1');
      expect(capturedParams!['fields'], 3);
    });
  });
}

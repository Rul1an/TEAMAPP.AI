import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jo17_tactical_manager/services/telemetry_service.dart';

void main() {
  group('TelemetryService', () {
    setUp(() async {
      // Provide empty env so TelemetryService skips exporter setup.
      dotenv.testLoad(fileInput: 'OTLP_ENDPOINT=');
      await TelemetryService().init();
    });

    test('trackEvent completes without error', () {
      expect(() => TelemetryService().trackEvent('unit_test_event'),
          returnsNormally);
    });

    test('monitorAsync returns value and completes span', () async {
      final result =
          await TelemetryService().monitorAsync('add', () async => 2 + 3);
      expect(result, 5);
    });
  });
}

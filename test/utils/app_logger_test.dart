// Package imports:
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:jo17_tactical_manager/utils/app_logger.dart';

void main() {
  test('AppLogger does not throw on various levels', () async {
    // Ensure test binding is initialized for method channels/sentry breadcrumb calls
    TestWidgetsFlutterBinding.ensureInitialized();
    // No-op Sentry: avoid real network in CI
    // Breadcrumbs capture is fire-and-forget; this test verifies no throws
    expect(() => AppLogger.t('trace'), returnsNormally);
    expect(() => AppLogger.d('debug'), returnsNormally);
    expect(() => AppLogger.i('info'), returnsNormally);
    expect(() => AppLogger.w('warn'), returnsNormally);
    expect(() => AppLogger.e('error'), returnsNormally);
  });
}

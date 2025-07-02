import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

/// Call this in your test `setUpAll` to initialize GoldenToolkit
/// with a default device & Impeller/Web tolerances.
Future<void> loadAppGoldens() async {
  await loadAppFonts();

  GoldenToolkit.runWithConfiguration(
    const GoldenToolkitConfiguration(
      defaultDevices: [Device.phone],
      enableRealShadows: true,
      skipGoldenAssertion: false,
    ),
    () {},
  );
}

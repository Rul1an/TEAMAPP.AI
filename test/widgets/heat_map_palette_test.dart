import 'package:flutter_test/flutter_test.dart';

import 'package:jo17_tactical_manager/widgets/analytics/heat_map_palette.dart';

void main() {
  test('classic palette returns gradient from yellow to red', () {
    final c0 = HeatMapPalette.classic.colorFor(0.0);
    final c1 = HeatMapPalette.classic.colorFor(1.0);
    expect(c0, isNotNull);
    expect(c1, isNotNull);
    // Compare components using modern getters
    final different =
        (c0.a != c1.a) || (c0.r != c1.r) || (c0.g != c1.g) || (c0.b != c1.b);
    expect(different, isTrue);
  });

  test('viridis palette returns non-null colors across range', () {
    for (final t in [0.0, 0.25, 0.5, 0.75, 1.0]) {
      final c = HeatMapPalette.viridis.colorFor(t);
      expect(c, isNotNull);
    }
  });
}

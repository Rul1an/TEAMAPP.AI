import 'package:flutter/material.dart';

enum HeatMapPalette { classic, blueOrange, viridis }

extension HeatMapPaletteColors on HeatMapPalette {
  Color colorFor(double t) {
    final double tt = t.clamp(0.0, 1.0);
    switch (this) {
      case HeatMapPalette.classic:
        return _lerpColors(tt, const [Colors.yellow, Colors.red]);
      case HeatMapPalette.blueOrange:
        return _lerpColors(tt, const [Color(0xFF2166AC), Color(0xFFF4A582)]);
      case HeatMapPalette.viridis:
        // Approximate viridis gradient stops (subset)
        return _lerpColors(tt, const [
          Color(0xFF440154), // dark purple
          Color(0xFF31688E), // blue
          Color(0xFF35B778), // green
          Color(0xFFFDE725), // yellow
        ]);
    }
  }
}

Color _lerpColors(double t, List<Color> stops) {
  if (stops.isEmpty) return const Color(0x00000000);
  if (stops.length == 1) return stops.first;
  final int segments = stops.length - 1;
  final double pos = t * segments;
  final int idx = pos.floor().clamp(0, segments - 1);
  final double localT = pos - idx;
  return Color.lerp(stops[idx], stops[idx + 1], localT) ?? stops.last;
}

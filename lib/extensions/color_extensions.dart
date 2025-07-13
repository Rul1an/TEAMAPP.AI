import 'package:flutter/material.dart';

extension ColorValues on Color {
  /// Returns a copy of this color with the provided [alpha] (0.0 - 1.0).
  /// When no [alpha] is supplied, the color is returned unchanged.
  Color withValues({required double alpha}) {
    // Clamp the provided alpha between 0 and 1 then convert to 0-255.
    final a = (alpha.clamp(0.0, 1.0) * 255).round();
    return withAlpha(a);
  }
}
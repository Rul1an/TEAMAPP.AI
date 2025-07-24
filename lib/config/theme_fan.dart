// Fan-family specific Theme wrapper
//
// Initially piggybacks on `AppTheme` but isolates future colour / typography
// tweaks for the lightweight fan-facing UI.

// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'theme.dart' as core_theme;

class FanTheme {
  static ThemeData get lightTheme => core_theme.AppTheme.lightTheme;
  static ThemeData get darkTheme => core_theme.AppTheme.darkTheme;
}

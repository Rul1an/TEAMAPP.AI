// Fan & Family specific theme
// Currently reuses the core AppTheme; place to override colours later.

import 'package:flutter/material.dart';
import 'theme.dart';

class FanTheme {
  static ThemeData get lightTheme => AppTheme.lightTheme.copyWith(
        colorScheme: AppTheme.lightTheme.colorScheme.copyWith(
          primary: const Color(0xFF9C27B0), // Purple accent for family app
        ),
      );

  static ThemeData get darkTheme => FanTheme.lightTheme; // TBD
}
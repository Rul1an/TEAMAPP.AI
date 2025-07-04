// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Colors
  static const Color primaryColor = Color(0xFF1976D2); // Blue
  static const Color secondaryColor = Color(0xFF388E3C); // Green
  static const Color accentColor = Color(0xFFFF6F00); // Orange
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color surfaceColor = Colors.white;
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFF57C00);

  // Text colors
  static const Color textPrimaryColor = Color(0xFF212121);
  static const Color textSecondaryColor = Color(0xFF757575);
  static const Color textOnPrimaryColor = Colors.white;

  // Position colors
  static const Color goalkeeperColor = Color(0xFFFFB300); // Amber
  static const Color defenderColor = Color(0xFF1976D2); // Blue
  static const Color midfielderColor = Color(0xFF388E3C); // Green
  static const Color forwardColor = Color(0xFFD32F2F); // Red

  // SaaS Tier colors
  static const Color basicTierColor = Color(0xFF4CAF50); // Green
  static const Color proTierColor = Color(0xFF2196F3); // Blue
  static const Color enterpriseTierColor = Color(0xFF9C27B0); // Purple
  static const Color adminColor = Color(0xFFD32F2F); // Red

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor,
          primary: primaryColor,
          secondary: secondaryColor,
          error: errorColor,
          surface: surfaceColor,
        ),
        textTheme: GoogleFonts.interTextTheme().copyWith(
          headlineLarge: GoogleFonts.inter(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: textPrimaryColor,
          ),
          headlineMedium: GoogleFonts.inter(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          headlineSmall: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          titleLarge: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
          titleMedium: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: textPrimaryColor,
          ),
          titleSmall: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textPrimaryColor,
          ),
          bodyLarge: GoogleFonts.inter(
            fontSize: 16,
            color: textPrimaryColor,
          ),
          bodyMedium: GoogleFonts.inter(
            fontSize: 14,
            color: textPrimaryColor,
          ),
          bodySmall: GoogleFonts.inter(
            fontSize: 12,
            color: textSecondaryColor,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: surfaceColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: textPrimaryColor),
          titleTextStyle: GoogleFonts.inter(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: surfaceColor,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: backgroundColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: primaryColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: errorColor),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: backgroundColor,
          selectedColor: primaryColor.withValues(alpha: 0.2),
          labelStyle: GoogleFonts.inter(
            fontSize: 14,
            color: textPrimaryColor,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      );

  static ThemeData get darkTheme =>
      lightTheme; // TODO(author): Implement dark theme
  // Helper method to get position color
  static Color getPositionColor(String position) {
    switch (position.toLowerCase()) {
      case 'goalkeeper':
      case 'keeper':
        return goalkeeperColor;
      case 'defender':
      case 'verdediger':
        return defenderColor;
      case 'midfielder':
      case 'middenvelder':
        return midfielderColor;
      case 'forward':
      case 'aanvaller':
        return forwardColor;
      default:
        return textSecondaryColor;
    }
  }

  // SaaS Tier helper methods
  static Color getTierColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'basic':
        return basicTierColor;
      case 'pro':
        return proTierColor;
      case 'enterprise':
        return enterpriseTierColor;
      default:
        return basicTierColor;
    }
  }

  static BoxDecoration getTierBadgeDecoration(String tier) => BoxDecoration(
        color: getTierColor(tier),
        borderRadius: BorderRadius.circular(12),
      );

  static Color getAdminColor() => adminColor;

  static TextStyle get tierBadgeTextStyle => const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      );
}

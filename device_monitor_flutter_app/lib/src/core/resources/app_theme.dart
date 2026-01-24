// lib/theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  // Green color palette
  static const Color primaryGreen = Color(0xFF10B981); // Emerald-500
  static const Color darkGreen = Color(0xFF059669); // Emerald-600
  static const Color lightGreen = Color(0xFF34D399); // Emerald-400
  static const Color veryLightGreen = Color(0xFFD1FAE5); // Emerald-100

  static const Color secondaryTeal = Color(0xFF14B8A6); // Teal-500
  static const Color accentLime = Color(0xFF84CC16); // Lime-500

  // Status colors
  static const Color successGreen = Color(0xFF22C55E); // Green-500
  static const Color warningAmber = Color(0xFFF59E0B); // Amber-500
  static const Color errorRed = Color(0xFFEF4444); // Red-500
  static const Color infoBlue = Color(0xFF3B82F6); // Blue-500

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primaryGreen,
      secondary: secondaryTeal,
      surface: Colors.white,
      background: const Color(0xFFF0FDF4), // Green-50
      error: errorRed,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: const Color(0xFF1F2937), // Gray-800
      onBackground: const Color(0xFF374151), // Gray-700
    ),
    scaffoldBackgroundColor: const Color(0xFFF0FDF4), // Green-50
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF1F2937),
      iconTheme: IconThemeData(color: primaryGreen),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryGreen,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryGreen,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryGreen,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: lightGreen,
      secondary: secondaryTeal,
      surface: const Color(0xFF1F2937), // Gray-800
      background: const Color(0xFF111827), // Gray-900
      error: errorRed,
      onPrimary: const Color(0xFF0F172A), // Slate-900
      onSecondary: Colors.white,
      onSurface: const Color(0xFFF9FAFB), // Gray-50
      onBackground: const Color(0xFFE5E7EB), // Gray-200
    ),
    scaffoldBackgroundColor: const Color(0xFF111827), // Gray-900
    appBarTheme: const AppBarTheme(
      elevation: 0,
      centerTitle: true,
      backgroundColor: Color(0xFF1F2937), // Gray-800
      foregroundColor: Color(0xFFF9FAFB),
      iconTheme: IconThemeData(color: lightGreen),
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF1F2937), // Gray-800
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightGreen,
        foregroundColor: const Color(0xFF0F172A),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: lightGreen,
      foregroundColor: Color(0xFF0F172A),
      elevation: 4,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: lightGreen,
    ),
  );

  // Thermal state colors
  static Color getThermalColor(int thermalValue, bool isDark) {
    switch (thermalValue) {
      case 0:
        return isDark ? const Color(0xFF34D399) : successGreen; // None - Green
      case 1:
        return isDark ? const Color(0xFF60A5FA) : infoBlue; // Light - Blue
      case 2:
        return isDark ? const Color(0xFFFBBF24) : warningAmber; // Moderate - Amber
      case 3:
        return isDark ? const Color(0xFFF87171) : errorRed; // Severe - Red
      default:
        return isDark ? const Color(0xFF9CA3AF) : const Color(0xFF6B7280);
    }
  }

  static String getThermalLabel(int thermalValue) {
    switch (thermalValue) {
      case 0:
        return 'None';
      case 1:
        return 'Light';
      case 2:
        return 'Moderate';
      case 3:
        return 'Severe';
      default:
        return 'Unknown';
    }
  }
}
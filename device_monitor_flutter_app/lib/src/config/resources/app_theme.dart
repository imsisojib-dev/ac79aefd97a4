import 'package:device_monitor/src/config/resources/app_colors.dart';
import 'package:flutter/material.dart';

class AppTheme {

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: AppColors.primaryGreen,
      secondary: AppColors.secondaryTeal,
      surface: Colors.white,
      background: const Color(0xFFF0FDF4), // Green-50
      error: AppColors.errorRed,
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
      iconTheme: IconThemeData(color: AppColors.primaryGreen),
    ),
    cardTheme: CardThemeData(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryGreen,
      foregroundColor: Colors.white,
      elevation: 4,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.primaryGreen,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: AppColors.lightGreen,
      secondary: AppColors.secondaryTeal,
      surface: const Color(0xFF1F2937), // Gray-800
      background: const Color(0xFF111827), // Gray-900
      error: AppColors.errorRed,
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
      iconTheme: IconThemeData(color: AppColors.lightGreen),
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: const Color(0xFF1F2937), // Gray-800
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.lightGreen,
        foregroundColor: const Color(0xFF0F172A),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 2,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.lightGreen,
      foregroundColor: Color(0xFF0F172A),
      elevation: 4,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.lightGreen,
    ),
  );

  // Thermal state colors
  static Color getThermalColor(int thermalValue, bool isDark) {
    switch (thermalValue) {
      case 0:
        return isDark ? const Color(0xFF34D399) : AppColors.successGreen; // None - Green
      case 1:
        return isDark ? const Color(0xFF60A5FA) : AppColors.infoBlue; // Light - Blue
      case 2:
        return isDark ? const Color(0xFFFBBF24) : AppColors.warningAmber; // Moderate - Amber
      case 3:
        return isDark ? const Color(0xFFF87171) : AppColors.errorRed; // Severe - Red
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
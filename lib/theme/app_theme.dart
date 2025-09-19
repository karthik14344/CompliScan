// theme/app_theme.dart
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryYellow = Color(0xFFFFD700);
  static const Color accentYellow = Color(0xFFFFC107);
  static const Color primaryBlack = Color(0xFF212121);
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color lightGray = Color(0xFFF5F5F5);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.light(
      primary: primaryYellow,
      secondary: accentYellow,
      surface: pureWhite,
      background: pureWhite,
      onPrimary: primaryBlack,
      onSecondary: primaryBlack,
      onSurface: primaryBlack,
      onBackground: primaryBlack,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBlack,
      foregroundColor: pureWhite,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryYellow,
        foregroundColor: primaryBlack,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    ),
    cardTheme: CardTheme(
      color: pureWhite,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}

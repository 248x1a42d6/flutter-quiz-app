
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static const Color primary = Color(0xFF6C63FF);
  static const Color secondary = Color(0xFF00A896);
  static const Color background = Color(0xFFF5F3FF);

  static const List<Color> categoryColors = [
    primary,
    secondary,
    Color(0xFFFF9800),
    Color(0xFFEC4899),
  ];

  static ThemeData get lightTheme {
    final scheme = ColorScheme.fromSeed(
      seedColor: primary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarThemeData(
        backgroundColor: background,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: scheme.surface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      floatingActionButtonTheme:
      const FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  static Color categoryColor(int index) {
    return categoryColors[index % categoryColors.length];
  }
}

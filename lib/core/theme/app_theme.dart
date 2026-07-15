import 'package:flutter/material.dart';

class AppTheme {
  static const Color backgroundColor = Color(0xFF07111F);
  static const Color panelColor = Color(0xFF0F1B2B);
  static const Color accentColor = Color(0xFF3C79F5);
  static const Color accentSoft = Color(0xFF8FB6FF);
  static const Color textPrimary = Color(0xFFF8FAFC);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color successColor = Color(0xFF22C55E);

  static ThemeData theme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: backgroundColor,
    colorScheme: const ColorScheme.dark(
      primary: accentColor,
      surface: panelColor,
      onSurface: textPrimary,
      secondary: accentSoft,
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: textPrimary, fontWeight: FontWeight.w700),
      titleMedium: TextStyle(color: textPrimary, fontWeight: FontWeight.w600),
      bodyMedium: TextStyle(color: textSecondary),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF111C2E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      hintStyle: const TextStyle(color: textSecondary),
      labelStyle: const TextStyle(color: textSecondary),
    ),
  );
}

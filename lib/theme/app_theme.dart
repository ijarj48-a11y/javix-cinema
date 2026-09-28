import 'package:flutter/material.dart';

class AppTheme {
  static const background = Color(0xFF050A14);
  static const surface = Color(0xFF0B1220);
  static const surfaceSoft = Color(0xFF101A2B);
  static const primary = Color(0xFF22C7FF);
  static const primaryBright = Color(0xFF62D9FF);
  static const text = Color(0xFFF5F9FF);
  static const textMuted = Color(0xFF91A1B7);

  static ThemeData get dark {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: background,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        secondary: primaryBright,
        surface: surface,
      ),
      useMaterial3: true,
      fontFamily: 'sans-serif',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: text,
        elevation: 0,
      ),
    );
  }
}

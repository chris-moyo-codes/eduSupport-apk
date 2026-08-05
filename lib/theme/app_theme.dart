import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EduSupportTheme {
  // Light Mode Tokens
  static const _lightBrand = Color(0xFF212B36);
  static const _lightBrandForeground = Color(0xFFFFFFFF);
  static const _lightAccent = Color(0xFFC05621);
  static const _lightAccentForeground = Color(0xFFFFFFFF);
  static const _lightBackground = Color(0xFFF0F0EC);
  static const _lightForeground = Color(0xFF1A202C);
  static const _lightSurface = Color(0xFFFFFFFF);
  static const _lightSurfaceMuted = Color(0xFFF5F5F1);
  static const _lightBorder = Color(0xFFE4E2DC);
  static const _lightBorderStrong = Color(0xFFC8C5BC);
  static const _lightError = Color(0xFFC53030);

  // Dark Mode Tokens
  static const _darkBrand = Color(0xFFE5E7EB);
  static const _darkBrandForeground = Color(0xFF121212);
  static const _darkAccent = Color(0xFFDD6B20);
  static const _darkAccentForeground = Color(0xFF121212);
  static const _darkBackground = Color(0xFF121212);
  static const _darkForeground = Color(0xFFF3F4F6);
  static const _darkSurface = Color(0xFF1C1C1E);
  static const _darkSurfaceMuted = Color(0xFF27272A);
  static const _darkBorder = Color(0xFF2D3748);
  static const _darkBorderStrong = Color(0xFF4A5568);
  static const _darkError = Color(0xFFF56565);

  // Motion & Curves (Derived from nyatwa.com style / web globals)
  static const Curve easeEdu = Cubic(0.16, 1.0, 0.3, 1.0);
  static const Curve easeEduSpring = Cubic(0.175, 0.885, 0.32, 1.275);
  static const Duration defaultTransitionDuration = Duration(milliseconds: 200);
  static const Duration longTransitionDuration = Duration(milliseconds: 500);

  // Border Radii
  static final BorderRadius radiusSm = BorderRadius.circular(2);
  static final BorderRadius radiusMd = BorderRadius.circular(4);
  static final BorderRadius radiusLg = BorderRadius.circular(8);
  static final BorderRadius radiusXl = BorderRadius.circular(12);

  // Typography
  static TextTheme _buildTextTheme(Color color) {
    return GoogleFonts.interTextTheme().copyWith(
      headlineLarge: GoogleFonts.merriweather(color: color, fontWeight: FontWeight.w700),
      headlineMedium: GoogleFonts.merriweather(color: color, fontWeight: FontWeight.w700),
      headlineSmall: GoogleFonts.merriweather(color: color, fontWeight: FontWeight.w700),
      titleLarge: GoogleFonts.inter(color: color, fontWeight: FontWeight.w600),
      titleMedium: GoogleFonts.inter(color: color, fontWeight: FontWeight.w600),
      titleSmall: GoogleFonts.inter(color: color, fontWeight: FontWeight.w600),
      bodyLarge: GoogleFonts.inter(color: color),
      bodyMedium: GoogleFonts.inter(color: color),
      bodySmall: GoogleFonts.inter(color: color),
      labelLarge: GoogleFonts.inter(color: color, fontWeight: FontWeight.w500),
      labelMedium: GoogleFonts.inter(color: color, fontWeight: FontWeight.w500),
      labelSmall: GoogleFonts.inter(color: color, fontWeight: FontWeight.w500),
    );
  }

  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _lightBrand,
      brightness: Brightness.light,
    ).copyWith(
      primary: _lightBrand,
      onPrimary: _lightBrandForeground,
      secondary: _lightAccent,
      onSecondary: _lightAccentForeground,
      surface: _lightSurface,
      onSurface: _lightForeground,
      surfaceContainerLowest: _lightBackground,
      surfaceContainerLow: _lightSurfaceMuted,
      surfaceContainerHighest: _lightSurface,
      outline: _lightBorder,
      outlineVariant: _lightBorderStrong,
      error: _lightError,
      onError: _lightBrandForeground,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _lightBackground,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(_lightForeground),
      appBarTheme: AppBarTheme(
        backgroundColor: _lightSurface,
        foregroundColor: _lightForeground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: _lightSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: radiusLg,
          side: const BorderSide(color: _lightBorder, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _lightSurface,
        hintStyle: TextStyle(color: _lightForeground.withValues(alpha: 0.5)),
        border: OutlineInputBorder(
          borderRadius: radiusLg,
          borderSide: const BorderSide(color: _lightBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radiusLg,
          borderSide: const BorderSide(color: _lightBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radiusLg,
          borderSide: const BorderSide(color: _lightBrand, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radiusLg,
          borderSide: const BorderSide(color: _lightError),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _lightBrand,
          foregroundColor: _lightBrandForeground,
          shape: RoundedRectangleBorder(borderRadius: radiusLg),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _lightBrand,
          foregroundColor: _lightBrandForeground,
          shape: RoundedRectangleBorder(borderRadius: radiusLg),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _lightForeground,
          side: const BorderSide(color: _lightBorderStrong),
          shape: RoundedRectangleBorder(borderRadius: radiusLg),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lightBrand,
          shape: RoundedRectangleBorder(borderRadius: radiusLg),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      dividerTheme: const DividerThemeData(color: _lightBorder, space: 1),
    );
  }

  static ThemeData get darkTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _darkBrand,
      brightness: Brightness.dark,
    ).copyWith(
      primary: _darkBrand,
      onPrimary: _darkBrandForeground,
      secondary: _darkAccent,
      onSecondary: _darkAccentForeground,
      surface: _darkSurface,
      onSurface: _darkForeground,
      surfaceContainerLowest: _darkBackground,
      surfaceContainerLow: _darkSurfaceMuted,
      surfaceContainerHighest: _darkSurface,
      outline: _darkBorder,
      outlineVariant: _darkBorderStrong,
      error: _darkError,
      onError: _darkBrandForeground,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: _darkBackground,
      colorScheme: colorScheme,
      textTheme: _buildTextTheme(_darkForeground),
      appBarTheme: AppBarTheme(
        backgroundColor: _darkSurface,
        foregroundColor: _darkForeground,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: _darkSurface,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: radiusLg,
          side: const BorderSide(color: _darkBorder, width: 1),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkSurface,
        hintStyle: TextStyle(color: _darkForeground.withValues(alpha: 0.5)),
        border: OutlineInputBorder(
          borderRadius: radiusLg,
          borderSide: const BorderSide(color: _darkBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radiusLg,
          borderSide: const BorderSide(color: _darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radiusLg,
          borderSide: const BorderSide(color: _darkBrand, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: radiusLg,
          borderSide: const BorderSide(color: _darkError),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkBrand,
          foregroundColor: _darkBrandForeground,
          shape: RoundedRectangleBorder(borderRadius: radiusLg),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _darkBrand,
          foregroundColor: _darkBrandForeground,
          shape: RoundedRectangleBorder(borderRadius: radiusLg),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _darkForeground,
          side: const BorderSide(color: _darkBorderStrong),
          shape: RoundedRectangleBorder(borderRadius: radiusLg),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkBrand,
          shape: RoundedRectangleBorder(borderRadius: radiusLg),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      dividerTheme: const DividerThemeData(color: _darkBorder, space: 1),
    );
  }
}

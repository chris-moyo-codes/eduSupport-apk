import 'package:flutter/material.dart';

class EduSupportTheme {
  static const _brandColor = Color(0xFF212B36);
  static const _brandForeground = Color(0xFFFFFFFF);
  static const _accentColor = Color(0xFFC05621);
  static const _accentForeground = Color(0xFFFFFFFF);
  static const _backgroundColor = Color(0xFFF0F0EC);
  static const _surfaceColor = Color(0xFFFFFFFF);
  static const _surfaceMutedColor = Color(0xFFF5F5F1);
  static const _borderColor = Color(0xFFE4E2DC);
  static const _borderStrongColor = Color(0xFFC8C5BC);
  static const _textColor = Color(0xFF1A202C);
  static const _errorColor = Color(0xFFC53030);

  static ThemeData get lightTheme {
    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: _brandColor,
          brightness: Brightness.light,
        ).copyWith(
          primary: _brandColor,
          onPrimary: _brandForeground,
          secondary: _accentColor,
          onSecondary: _accentForeground,
          surface: _surfaceColor,
          onSurface: _textColor,
          surfaceContainerLowest: _backgroundColor,
          surfaceContainerLow: _surfaceMutedColor,
          surfaceContainerHighest: _surfaceColor,
          outline: _borderColor,
          outlineVariant: _borderStrongColor,
          error: _errorColor,
          onError: _brandForeground,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: _backgroundColor,
      colorScheme: colorScheme,
      textTheme: Typography.blackMountainView.apply(
        bodyColor: _textColor,
        displayColor: _textColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: _surfaceColor,
        foregroundColor: _textColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        margin: EdgeInsets.zero,
        color: _surfaceColor,
        surfaceTintColor: Colors.transparent,
        shadowColor: const Color(0x1F000000),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _brandColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _brandColor,
          foregroundColor: _brandForeground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _accentColor,
          foregroundColor: _accentForeground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _textColor,
          side: const BorderSide(color: _borderStrongColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      dividerTheme: const DividerThemeData(color: _borderColor, space: 1),
    );
  }

  static ThemeData get darkTheme {
    const brandColor = Color(0xFFE5E7EB);
    const brandForeground = Color(0xFF121212);
    const accentColor = Color(0xFFDD6B20);
    const accentForeground = Color(0xFF121212);
    const backgroundColor = Color(0xFF121212);
    const surfaceColor = Color(0xFF1C1C1E);
    const surfaceMutedColor = Color(0xFF27272A);
    const textColor = Color(0xFFF3F4F6);
    const borderColor = Color(0xFF2D3748);
    const borderStrongColor = Color(0xFF4A5568);

    final colorScheme =
        ColorScheme.fromSeed(
          seedColor: brandColor,
          brightness: Brightness.dark,
        ).copyWith(
          primary: brandColor,
          onPrimary: brandForeground,
          secondary: accentColor,
          onSecondary: accentForeground,
          surface: surfaceColor,
          onSurface: textColor,
          surfaceContainerLowest: backgroundColor,
          surfaceContainerLow: surfaceMutedColor,
          surfaceContainerHighest: surfaceColor,
          outline: borderColor,
          outlineVariant: borderStrongColor,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundColor,
      textTheme: Typography.whiteMountainView.apply(
        bodyColor: textColor,
        displayColor: textColor,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: surfaceColor,
        foregroundColor: textColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      cardTheme: CardThemeData(
        elevation: 1,
        margin: EdgeInsets.zero,
        color: surfaceColor,
        surfaceTintColor: Colors.transparent,
        shadowColor: const Color(0x33000000),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: brandColor, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: brandColor,
          foregroundColor: brandForeground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: accentForeground,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor,
          side: const BorderSide(color: borderStrongColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        ),
      ),
      dividerTheme: const DividerThemeData(color: borderColor, space: 1),
    );
  }
}

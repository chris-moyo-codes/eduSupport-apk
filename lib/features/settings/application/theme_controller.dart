import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum EduThemeMode { light, dark, system }

extension EduThemeModeX on EduThemeMode {
  String get key {
    switch (this) {
      case EduThemeMode.light:
        return 'light';
      case EduThemeMode.dark:
        return 'dark';
      case EduThemeMode.system:
        return 'system';
    }
  }

  ThemeMode get flutterMode {
    switch (this) {
      case EduThemeMode.light:
        return ThemeMode.light;
      case EduThemeMode.dark:
        return ThemeMode.dark;
      case EduThemeMode.system:
        return ThemeMode.system;
    }
  }

  static EduThemeMode fromKey(String key) {
    switch (key) {
      case 'light':
        return EduThemeMode.light;
      case 'dark':
        return EduThemeMode.dark;
      default:
        return EduThemeMode.system;
    }
  }
}

const _themePrefKey = 'edu_theme_mode';

class ThemeController extends StateNotifier<EduThemeMode> {
  ThemeController() : super(EduThemeMode.system);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_themePrefKey);
    if (stored != null) {
      state = EduThemeModeX.fromKey(stored);
    }
  }

  Future<void> setTheme(EduThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePrefKey, mode.key);
  }

  ThemeMode get flutterMode => state.flutterMode;
}

final themeControllerProvider =
    StateNotifierProvider<ThemeController, EduThemeMode>((ref) {
      final controller = ThemeController();
      controller.load();
      return controller;
    });

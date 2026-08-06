import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/settings/application/theme_controller.dart';

class ThemeToggleButton extends ConsumerWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeControllerProvider);
    final isDark = themeMode == EduThemeMode.dark;

    return IconButton(
      icon: Icon(
        isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
      ),
      tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
      onPressed: () {
        final newMode = isDark ? EduThemeMode.light : EduThemeMode.dark;
        ref.read(themeControllerProvider.notifier).setTheme(newMode);
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/router/app_router.dart';
import '../features/settings/application/theme_controller.dart';
import '../theme/app_theme.dart';

class EduSupportApp extends ConsumerWidget {
  const EduSupportApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeControllerProvider);

    return MaterialApp.router(
      title: 'EduSupport',
      debugShowCheckedModeBanner: false,
      theme: EduSupportTheme.lightTheme,
      darkTheme: EduSupportTheme.darkTheme,
      themeMode: themeMode.flutterMode,
      routerConfig: router,
    );
  }
}

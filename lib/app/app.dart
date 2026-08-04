import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../app/router/app_router.dart';
import '../theme/app_theme.dart';

class EduSupportApp extends ConsumerWidget {
  const EduSupportApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'EduSupport Mobile',
      debugShowCheckedModeBanner: false,
      theme: EduSupportTheme.lightTheme,
      darkTheme: EduSupportTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}

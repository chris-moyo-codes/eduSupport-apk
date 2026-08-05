import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/app_shell/presentation/screens/role_picker_screen.dart';
import '../../features/app_shell/presentation/screens/shell_screen.dart';
import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/screens/auth_gate.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/onboarding/application/onboarding_controller.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/student/presentation/screens/tutors_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);
  final onboardingState = ref.watch(onboardingControllerProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final location = state.matchedLocation;

      if (onboardingState.isLoading) {
        return AppRoutes.splash;
      }

      if (!onboardingState.isCompleted) {
        if (location == AppRoutes.onboarding || location == AppRoutes.splash) {
          return null;
        }
        return AppRoutes.onboarding;
      }

      if (authState.status == AuthStatus.loading) {
        return AppRoutes.splash;
      }

      if (authState.status == AuthStatus.authenticated) {
        if (location == AppRoutes.login || location == AppRoutes.splash) {
          return AppRoutes.home;
        }
        if (location == AppRoutes.rolePicker) {
          return null;
        }
        return null;
      }

      if (location == AppRoutes.splash) {
        return AppRoutes.login;
      }

      if (location == AppRoutes.login || location == AppRoutes.rolePicker) {
        return null;
      }

      return AppRoutes.login;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splashName,
        builder: (context, state) => const AuthGate(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboardingName,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        name: AppRoutes.homeName,
        builder: (context, state) => const ShellScreen(),
      ),
      GoRoute(
        path: AppRoutes.tutors,
        name: AppRoutes.tutorsName,
        builder: (context, state) => const TutorsScreen(),
      ),
      GoRoute(
        path: AppRoutes.rolePicker,
        name: AppRoutes.rolePickerName,
        builder: (context, state) => const RolePickerScreen(),
      ),
    ],
    errorBuilder: (context, state) => const UnknownRouteScreen(),
  );
});

class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Route unavailable')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('The requested EduSupport route could not be found.'),
        ),
      ),
    );
  }
}

class AppRoutes {
  static const splash = '/';
  static const splashName = 'splash';
  static const onboarding = '/onboarding';
  static const onboardingName = 'onboarding';
  static const login = '/login';
  static const loginName = 'login';
  static const home = '/home';
  static const homeName = 'home';
  static const tutors = '/tutors';
  static const tutorsName = 'tutors';
  static const rolePicker = '/role-picker';
  static const rolePickerName = 'role-picker';
}

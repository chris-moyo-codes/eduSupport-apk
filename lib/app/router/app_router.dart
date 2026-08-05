import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/screens/admin_placeholder_screen.dart';
import '../../features/app_shell/presentation/screens/shell_screen.dart';
import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/screens/auth_gate.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/onboarding/application/onboarding_controller.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/student/presentation/screens/tutors_screen.dart';
import '../../features/tutor/presentation/screens/tutor_shell_screen.dart';
import '../../theme/app_theme.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);
  // Use .select() so the router only rebuilds when routing-relevant fields change.
  // Watching the full OnboardingState would rebuild (and reset) the GoRouter every
  // time currentPage changes during swiping — which is not a routing concern.
  final isOnboardingLoading = ref.watch(
    onboardingControllerProvider.select((s) => s.isLoading),
  );
  final isOnboardingCompleted = ref.watch(
    onboardingControllerProvider.select((s) => s.isCompleted),
  );

  String getHomeRouteForRole(EduRole role) {
    switch (role) {
      case EduRole.student:
        return AppRoutes.studentHome;
      case EduRole.tutor:
        return AppRoutes.tutorHome;
      case EduRole.admin:
        return AppRoutes.adminHome;
    }
  }

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final location = state.matchedLocation;

      // 1. Still bootstrapping onboarding? Show splash.
      if (isOnboardingLoading) {
        return AppRoutes.splash;
      }

      // 2. Onboarding not completed? Force them to onboarding.
      if (!isOnboardingCompleted) {
        if (location == AppRoutes.onboarding) {
          return null; // Already on onboarding, allow it.
        }
        return AppRoutes.onboarding; // Redirect everything else — including /splash — to onboarding.
      }

      // 3. Still bootstrapping auth session? Show splash.
      if (authState.isLoading) {
        return AppRoutes.splash;
      }

      // 4. Authenticated user behavior
      if (authState.isAuthenticated) {
        // If they try to go to login, splash, or onboarding, redirect to their role's home.
        if (location == AppRoutes.login ||
            location == AppRoutes.splash ||
            location == AppRoutes.onboarding) {
          return getHomeRouteForRole(authState.role);
        }

        // RBAC: Route Protection
        // Prevent users from accessing other roles' specific routes.
        if (location.startsWith('/tutor') && authState.role != EduRole.tutor) {
          return getHomeRouteForRole(authState.role);
        }
        if (location.startsWith('/admin') && authState.role != EduRole.admin) {
          return getHomeRouteForRole(authState.role);
        }
        // Assuming student routes are under /home or /tutors, but /tutors might be shared later.
        // For now, if tutor/admin try to go to /home (student shell), redirect them.
        if (location == AppRoutes.studentHome && authState.role != EduRole.student) {
           return getHomeRouteForRole(authState.role);
        }

        return null; // Allow access
      }

      // 5. Unauthenticated user behavior
      if (location == AppRoutes.splash) {
        return AppRoutes.login;
      }

      // Allow access to login if unauthenticated
      if (location == AppRoutes.login) {
        return null;
      }

      // Otherwise, force to login
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
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const OnboardingScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: EduSupportTheme.easeEdu,
            );
            return FadeTransition(
              opacity: curvedAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.05),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              ),
            );
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        pageBuilder: (context, state) => CustomTransitionPage(
          child: const LoginScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: EduSupportTheme.easeEdu,
            );
            return FadeTransition(
              opacity: curvedAnimation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.05),
                  end: Offset.zero,
                ).animate(curvedAnimation),
                child: child,
              ),
            );
          },
        ),
      ),
      GoRoute(
        path: AppRoutes.studentHome,
        name: AppRoutes.studentHomeName,
        builder: (context, state) => const ShellScreen(),
      ),
      GoRoute(
        path: AppRoutes.tutorHome,
        name: AppRoutes.tutorHomeName,
        builder: (context, state) => const TutorShellScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminHome,
        name: AppRoutes.adminHomeName,
        builder: (context, state) => const AdminPlaceholderScreen(),
      ),
      GoRoute(
        path: AppRoutes.tutors,
        name: AppRoutes.tutorsName,
        builder: (context, state) => const TutorsScreen(),
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

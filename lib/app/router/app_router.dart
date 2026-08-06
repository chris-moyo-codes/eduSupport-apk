import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/presentation/screens/admin_shell_screen.dart';
import '../../features/app_shell/presentation/screens/shell_screen.dart';
import '../../features/auth/application/auth_controller.dart';
import '../../features/auth/presentation/screens/auth_gate.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/registration_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/onboarding/application/onboarding_controller.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/student/presentation/screens/tasks_screen.dart';
import '../../features/student/presentation/screens/tutors_screen.dart';
import '../../features/student/presentation/screens/task_detail_screen.dart';
import '../../features/tutor/presentation/screens/tutor_shell_screen.dart';
import '../../features/tutor/presentation/screens/tutor_tasks_screen.dart';
import '../../features/tutor/presentation/screens/tutor_task_review_screen.dart';
import '../../theme/app_theme.dart';
import 'app_routes.dart';

class _RouterNotifier extends ChangeNotifier {
  _RouterNotifier(this._ref) {
    _ref.listen(authControllerProvider, (_, __) => notifyListeners());
    _ref.listen(onboardingControllerProvider, (_, __) => notifyListeners());
  }
  final Ref _ref;
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final routerNotifier = _RouterNotifier(ref);
  
  ref.onDispose(() {
    routerNotifier.dispose();
  });

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
    refreshListenable: routerNotifier,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      final isOnboardingLoading = ref.read(onboardingControllerProvider).isLoading;
      final isOnboardingCompleted = ref.read(onboardingControllerProvider).isCompleted;
      
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
            location == AppRoutes.register ||
            location == AppRoutes.forgotPassword ||
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

      // Allow access to auth screens if unauthenticated
      if (location == AppRoutes.login || 
          location == AppRoutes.register || 
          location == AppRoutes.forgotPassword) {
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
        pageBuilder: (context, state) => _buildPageWithTransition(const OnboardingScreen()),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        pageBuilder: (context, state) => _buildPageWithTransition(const LoginScreen()),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: AppRoutes.registerName,
        pageBuilder: (context, state) => _buildPageWithTransition(const RegistrationScreen()),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: AppRoutes.forgotPasswordName,
        pageBuilder: (context, state) => _buildPageWithTransition(const ForgotPasswordScreen()),
      ),
      GoRoute(
        path: AppRoutes.studentHome,
        name: AppRoutes.studentHomeName,
        pageBuilder: (context, state) => _buildPageWithTransition(const ShellScreen()),
      ),
      GoRoute(
        path: AppRoutes.tutorHome,
        name: AppRoutes.tutorHomeName,
        pageBuilder: (context, state) => _buildPageWithTransition(const TutorShellScreen()),
      ),
      GoRoute(
        path: AppRoutes.adminHome,
        name: AppRoutes.adminHomeName,
        pageBuilder: (context, state) => _buildPageWithTransition(const AdminShellScreen()),
      ),
      GoRoute(
        path: AppRoutes.tutors,
        name: AppRoutes.tutorsName,
        builder: (context, state) => const TutorsScreen(),
      ),
      GoRoute(
        path: AppRoutes.tasks,
        name: AppRoutes.tasksName,
        builder: (context, state) => const TasksScreen(),
        routes: [
          GoRoute(
            path: ':id',
            name: AppRoutes.taskDetailName,
            builder: (context, state) => TaskDetailScreen(taskId: state.pathParameters['id']!),
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.tutorTasks,
        builder: (context, state) => const TutorTasksScreen(),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) => TutorTaskReviewScreen(taskId: state.pathParameters['id']!),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const UnknownRouteScreen(),
  );
});

Page<dynamic> _buildPageWithTransition(Widget child) {
  return CustomTransitionPage(
    child: child,
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
  );
}

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

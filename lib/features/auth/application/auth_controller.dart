import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AuthStatus { loading, authenticated, unauthenticated }

enum EduMockRole { student, tutor, admin }

final mockRoleProvider = StateProvider<EduMockRole>(
  (ref) => EduMockRole.student,
);

class AuthControllerState {
  const AuthControllerState({
    this.status = AuthStatus.loading,
    this.isLoading = false,
  });

  final AuthStatus status;
  final bool isLoading;

  AuthControllerState copyWith({AuthStatus? status, bool? isLoading}) {
    return AuthControllerState(
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class AuthController extends StateNotifier<AuthControllerState> {
  AuthController() : super(const AuthControllerState());

  Future<void> bootstrapSession() async {
    state = state.copyWith(status: AuthStatus.loading, isLoading: true);

    await Future<void>.delayed(const Duration(milliseconds: 250));

    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      isLoading: false,
    );
  }

  Future<void> login() async {
    state = state.copyWith(status: AuthStatus.authenticated, isLoading: false);
  }

  Future<void> logout() async {
    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      isLoading: false,
    );
  }
}

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthControllerState>(
      (ref) => AuthController()..bootstrapSession(),
    );

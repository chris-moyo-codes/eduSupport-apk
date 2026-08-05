import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/mock_auth_service.dart';

export '../data/mock_auth_service.dart' show EduUser, EduRole, LoginResult;

// ─── State ────────────────────────────────────────────────────────────────────

enum AuthStatus { loading, authenticated, unauthenticated }

class AuthState {
  const AuthState({
    this.status = AuthStatus.loading,
    this.user,
    this.errorMessage,
    this.isSubmitting = false,
  });

  final AuthStatus status;
  final EduUser? user;
  final String? errorMessage;
  final bool isSubmitting;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isLoading => status == AuthStatus.loading;
  EduRole get role => user?.role ?? EduRole.student;

  AuthState copyWith({
    AuthStatus? status,
    EduUser? user,
    String? errorMessage,
    bool clearError = false,
    bool? isSubmitting,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }
}

// ─── Controller ───────────────────────────────────────────────────────────────

class AuthController extends StateNotifier<AuthState> {
  AuthController(this._service) : super(const AuthState());

  final MockAuthService _service;

  /// Called once on app boot — restores a persisted session if available.
  Future<void> bootstrapSession() async {
    state = const AuthState(status: AuthStatus.loading);
    final user = await _service.restoreSession();
    if (user != null) {
      state = AuthState(status: AuthStatus.authenticated, user: user);
    } else {
      state = const AuthState(status: AuthStatus.unauthenticated);
    }
  }

  /// Attempts mock login. Returns true on success.
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    final result = await _service.login(email, password);
    if (result.isSuccess) {
      state = AuthState(
        status: AuthStatus.authenticated,
        user: result.user,
        isSubmitting: false,
      );
      return true;
    } else {
      state = state.copyWith(
        status: AuthStatus.unauthenticated,
        errorMessage: result.error,
        isSubmitting: false,
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _service.logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

// ─── Provider ─────────────────────────────────────────────────────────────────

final _mockAuthServiceProvider = Provider<MockAuthService>(
  (ref) => MockAuthService(SecureMockUserStore()),
);

final authControllerProvider =
    StateNotifierProvider<AuthController, AuthState>((ref) {
      final controller = AuthController(ref.read(_mockAuthServiceProvider));
      controller.bootstrapSession();
      return controller;
    });

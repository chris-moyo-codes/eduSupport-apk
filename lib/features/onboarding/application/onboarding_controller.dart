import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../storage/onboarding_store.dart';

class OnboardingState {
  const OnboardingState({
    this.currentPage = 0,
    this.isLoading = true,
    this.isCompleted = false,
  });

  final int currentPage;
  final bool isLoading;
  final bool isCompleted;

  OnboardingState copyWith({
    int? currentPage,
    bool? isLoading,
    bool? isCompleted,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isLoading: isLoading ?? this.isLoading,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class OnboardingController extends StateNotifier<OnboardingState> {
  OnboardingController(this._store) : super(const OnboardingState());

  final OnboardingStore _store;

  Future<void> bootstrap() async {
    state = state.copyWith(isLoading: true);
    final completed = await _store.isOnboardingCompleted();
    state = state.copyWith(isLoading: false, isCompleted: completed);
  }

  void nextPage() {
    state = state.copyWith(currentPage: state.currentPage + 1);
  }

  void previousPage() {
    state = state.copyWith(currentPage: state.currentPage - 1);
  }

  Future<void> complete() async {
    await _store.setOnboardingCompleted(true);
    state = state.copyWith(isCompleted: true, currentPage: 0);
  }

  Future<void> skip() async {
    await _store.setOnboardingCompleted(true);
    state = state.copyWith(isCompleted: true, currentPage: 0);
  }
}

final onboardingControllerProvider =
    StateNotifierProvider<OnboardingController, OnboardingState>(
      (ref) => OnboardingController(SecureOnboardingStore())..bootstrap(),
    );

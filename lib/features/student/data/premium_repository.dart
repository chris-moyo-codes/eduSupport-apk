// EduSupport Premium Subscription — Frontend-Only Mock
// ─────────────────────────────────────────────────────
// All pricing, plan activation, and payment simulation is local/mock only.
// No real payment provider is integrated.
// Structure is designed so real Mpamba/Airtel Money/Bank APIs can be
// connected later without changing the controller interface.

import 'package:flutter_riverpod/flutter_riverpod.dart';

// ─── Plans ────────────────────────────────────────────────────────────────────

enum PremiumPlan { monthly, threeMonths, annual }

extension PremiumPlanX on PremiumPlan {
  String get label {
    switch (this) {
      case PremiumPlan.monthly:
        return 'Monthly';
      case PremiumPlan.threeMonths:
        return '3 Months';
      case PremiumPlan.annual:
        return 'Annual';
    }
  }

  int get priceMwk {
    switch (this) {
      case PremiumPlan.monthly:
        return 6000;
      case PremiumPlan.threeMonths:
        return 16000;
      case PremiumPlan.annual:
        return 57600;
    }
  }

  String get priceLabel {
    switch (this) {
      case PremiumPlan.monthly:
        return 'MWK 6,000';
      case PremiumPlan.threeMonths:
        return 'MWK 16,000';
      case PremiumPlan.annual:
        return 'MWK 57,600';
    }
  }

  String get periodLabel {
    switch (this) {
      case PremiumPlan.monthly:
        return 'per month';
      case PremiumPlan.threeMonths:
        return 'per 3 months';
      case PremiumPlan.annual:
        return 'per year';
    }
  }

  String get savingsNote {
    switch (this) {
      case PremiumPlan.monthly:
        return '';
      case PremiumPlan.threeMonths:
        return 'Save 11% vs monthly';
      case PremiumPlan.annual:
        return 'Best value — save 20%';
    }
  }

  bool get isPopular => this == PremiumPlan.threeMonths;
}

// ─── Payment Methods ──────────────────────────────────────────────────────────

enum PaymentMethod { mpamba, airtelMoney, bank }

extension PaymentMethodX on PaymentMethod {
  String get label {
    switch (this) {
      case PaymentMethod.mpamba:
        return 'Mpamba';
      case PaymentMethod.airtelMoney:
        return 'Airtel Money';
      case PaymentMethod.bank:
        return 'Bank Transfer';
    }
  }

  String get fieldLabel {
    switch (this) {
      case PaymentMethod.mpamba:
        return 'Mpamba Mobile Number';
      case PaymentMethod.airtelMoney:
        return 'Airtel Money Number';
      case PaymentMethod.bank:
        return 'Account Number';
    }
  }

  String get hint {
    switch (this) {
      case PaymentMethod.mpamba:
        return '088 XXX XXXX';
      case PaymentMethod.airtelMoney:
        return '099 XXX XXXX';
      case PaymentMethod.bank:
        return 'Enter your bank account number';
    }
  }
}

// ─── State ────────────────────────────────────────────────────────────────────

class PremiumState {
  const PremiumState({
    this.isPremium = false,
    this.activePlan,
    this.activatedAt,
  });

  final bool isPremium;
  final PremiumPlan? activePlan;
  final DateTime? activatedAt;

  String get planDisplayLabel => activePlan?.label ?? 'Free';

  PremiumState copyWith({
    bool? isPremium,
    PremiumPlan? activePlan,
    DateTime? activatedAt,
  }) {
    return PremiumState(
      isPremium: isPremium ?? this.isPremium,
      activePlan: activePlan ?? this.activePlan,
      activatedAt: activatedAt ?? this.activatedAt,
    );
  }
}

// ─── Controller ───────────────────────────────────────────────────────────────

class PremiumController extends StateNotifier<PremiumState> {
  PremiumController() : super(const PremiumState());

  /// Activates a premium plan after mock payment success.
  void activate(PremiumPlan plan) {
    state = PremiumState(
      isPremium: true,
      activePlan: plan,
      activatedAt: DateTime.now(),
    );
  }

  /// Cancels the active subscription (mock).
  void cancel() {
    state = const PremiumState();
  }
}

// ─── Providers ────────────────────────────────────────────────────────────────

final premiumControllerProvider =
    StateNotifierProvider<PremiumController, PremiumState>(
  (ref) => PremiumController(),
);

final isPremiumProvider = Provider<bool>(
  (ref) => ref.watch(premiumControllerProvider).isPremium,
);

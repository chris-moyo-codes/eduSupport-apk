import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../theme/app_theme.dart';
import '../../data/premium_repository.dart';
import 'payment_screen.dart';

class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final premiumState = ref.watch(premiumControllerProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('EduSupport Premium'),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Active Premium Banner ────────────────────────────────────────
              if (premiumState.isPremium) ...[
                _ActivePremiumBanner(plan: premiumState.activePlan!),
                const SizedBox(height: 20),
              ],

              // ── Hero ─────────────────────────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      theme.colorScheme.primary,
                      theme.colorScheme.primary.withValues(alpha: 0.85),
                    ],
                  ),
                  borderRadius: EduSupportTheme.radiusXl,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: EduSupportTheme.radiusMd,
                      ),
                      child: const Text(
                        'PREMIUM',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Unlock your full learning potential',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Access premium resources, advanced study tools, and unlimited tutor sessions.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.85),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Features ─────────────────────────────────────────────────────
              Text(
                'What you get',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ..._premiumFeatures.map(
                (f) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _FeatureRow(icon: f.$1, label: f.$2),
                ),
              ),

              const SizedBox(height: 28),

              // ── Plans ─────────────────────────────────────────────────────────
              Text(
                'Choose your plan',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ...PremiumPlan.values.map(
                (plan) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _PlanCard(
                    plan: plan,
                    isCurrentPlan:
                        premiumState.isPremium && premiumState.activePlan == plan,
                    onSelect: () {
                      if (premiumState.isPremium &&
                          premiumState.activePlan == plan) return;
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => PaymentScreen(plan: plan),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Free vs Premium comparison
              _ComparisonCard(),

              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Payment is processed securely via Mpamba, Airtel Money, or Bank.\nNo real payments are processed in this demo.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

const _premiumFeatures = [
  (Icons.lock_open_rounded, 'Access to all premium study resources'),
  (Icons.quiz_rounded, 'Advanced practice tests and past papers'),
  (Icons.people_alt_rounded, 'Priority booking with top-rated tutors'),
  (Icons.download_rounded, 'Unlimited offline content downloads'),
  (Icons.trending_up_rounded, 'Detailed progress analytics'),
  (Icons.support_agent_rounded, 'Priority support'),
];

// ─── Plan Card ────────────────────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.plan,
    required this.isCurrentPlan,
    required this.onSelect,
  });

  final PremiumPlan plan;
  final bool isCurrentPlan;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPopular = plan.isPopular;

    return GestureDetector(
      onTap: onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isCurrentPlan
              ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4)
              : isPopular
                  ? theme.colorScheme.primary.withValues(alpha: 0.04)
                  : theme.colorScheme.surface,
          borderRadius: EduSupportTheme.radiusLg,
          border: Border.all(
            color: isCurrentPlan
                ? theme.colorScheme.primary
                : isPopular
                    ? theme.colorScheme.primary.withValues(alpha: 0.4)
                    : theme.colorScheme.outlineVariant,
            width: isCurrentPlan || isPopular ? 1.5 : 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          plan.label,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (isPopular) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'POPULAR',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                        if (isCurrentPlan) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'ACTIVE',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          plan.priceLabel,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          plan.periodLabel,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    if (plan.savingsNote.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        plan.savingsNote,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                isCurrentPlan
                    ? Icons.check_circle_rounded
                    : Icons.arrow_forward_ios_rounded,
                size: isCurrentPlan ? 22 : 16,
                color: isCurrentPlan
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Feature Row ──────────────────────────────────────────────────────────────

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 17, color: theme.colorScheme.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

// ─── Comparison Card ──────────────────────────────────────────────────────────

class _ComparisonCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        borderRadius: EduSupportTheme.radiusLg,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Free vs Premium',
            style: theme.textTheme.titleSmall
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          _CompRow(label: 'Basic resources', free: true, premium: true),
          _CompRow(label: 'Premium study materials', free: false, premium: true),
          _CompRow(label: 'Tutor discovery', free: true, premium: true),
          _CompRow(label: 'Priority tutor access', free: false, premium: true),
          _CompRow(label: 'Unlimited downloads', free: false, premium: true),
          _CompRow(label: 'Advanced analytics', free: false, premium: true),
        ],
      ),
    );
  }
}

class _CompRow extends StatelessWidget {
  const _CompRow(
      {required this.label, required this.free, required this.premium});
  final String label;
  final bool free;
  final bool premium;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
              child: Text(label, style: theme.textTheme.bodySmall)),
          _CheckCell(has: free),
          const SizedBox(width: 24),
          _CheckCell(has: premium, isGold: true),
        ],
      ),
    );
  }
}

class _CheckCell extends StatelessWidget {
  const _CheckCell({required this.has, this.isGold = false});
  final bool has;
  final bool isGold;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return has
        ? Icon(
            Icons.check_rounded,
            size: 16,
            color: isGold
                ? theme.colorScheme.primary
                : theme.colorScheme.secondary,
          )
        : Icon(
            Icons.remove_rounded,
            size: 16,
            color: theme.colorScheme.outlineVariant,
          );
  }
}

// ─── Active Premium Banner ────────────────────────────────────────────────────

class _ActivePremiumBanner extends StatelessWidget {
  const _ActivePremiumBanner({required this.plan});
  final PremiumPlan plan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
        borderRadius: EduSupportTheme.radiusMd,
        border: Border.all(
            color: theme.colorScheme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.workspace_premium_rounded,
              color: theme.colorScheme.primary, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Premium Active — ${plan.label} Plan',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.primary,
                  ),
                ),
                Text(
                  'You have full access to all premium content.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

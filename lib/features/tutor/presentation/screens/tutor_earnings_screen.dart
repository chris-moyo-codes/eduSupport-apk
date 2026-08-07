import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/ui_utils.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_card.dart';
import '../../../../theme/app_theme.dart';
import '../../data/tutor_earnings_mock.dart';
import 'tutor_withdrawal_screen.dart';

class TutorEarningsScreen extends ConsumerStatefulWidget {
  const TutorEarningsScreen({super.key});

  @override
  ConsumerState<TutorEarningsScreen> createState() =>
      _TutorEarningsScreenState();
}

class _TutorEarningsScreenState extends ConsumerState<TutorEarningsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final earningsState = ref.watch(tutorEarningsProvider);
    final balance = earningsState.balance;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Earnings'),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, _) => [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: EduSupportTheme.radiusXl,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Available to Withdraw',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'MWK ${formatCurrency(balance.availableForWithdrawalMwk)}',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: [
                              Expanded(
                                child: _SmallStat(
                                  label: 'Total Earned',
                                  value:
                                      'MWK ${formatCurrency(balance.totalEarnedMwk)}',
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 30,
                                color: Colors.white.withValues(alpha: 0.3),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16),
                                  child: _SmallStat(
                                    label: 'Withdrawn',
                                    value:
                                        'MWK ${formatCurrency(balance.totalWithdrawnMwk)}',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: balance.canWithdraw
                                  ? () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute<void>(
                                          builder: (_) =>
                                              const TutorWithdrawalScreen(),
                                        ),
                                      );
                                    }
                                  : null,
                              style: FilledButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: theme.colorScheme.primary,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                disabledBackgroundColor:
                                    Colors.white.withValues(alpha: 0.5),
                                disabledForegroundColor:
                                    theme.colorScheme.primary.withValues(alpha: 0.5),
                              ),
                              child: Text(balance.canWithdraw
                                  ? 'Withdraw Funds'
                                  : 'Min withdrawal: MWK 10,000'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Info box
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.secondaryContainer
                            .withValues(alpha: 0.5),
                        borderRadius: EduSupportTheme.radiusMd,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline_rounded,
                              size: 16, color: theme.colorScheme.secondary),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Earnings are updated automatically after a session is completed. EduSupport retains a 15% commission on all sessions.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    TabBar(
                      controller: _tabController,
                      dividerColor: theme.colorScheme.outlineVariant,
                      tabs: const [
                        Tab(text: 'Sessions'),
                        Tab(text: 'Withdrawals'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: TabBarView(
            controller: _tabController,
            children: [
              // Sessions list
              ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                itemCount: earningsState.earnings.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _EarningCard(
                        earning: earningsState.earnings[index]),
                  );
                },
              ),

              // Withdrawals list
              earningsState.withdrawals.isEmpty
                  ? Center(
                      child: Text(
                        'No withdrawal history yet.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 40),
                      itemCount: earningsState.withdrawals.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _WithdrawalCard(
                              withdrawal: earningsState.withdrawals[index]),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _SmallStat extends StatelessWidget {
  const _SmallStat({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}

class _EarningCard extends StatelessWidget {
  const _EarningCard({required this.earning});
  final TutorEarning earning;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, color, bg) = switch (earning.status) {
      EarningStatus.paid => (
          Icons.check_circle_rounded,
          theme.colorScheme.primary,
          theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
        ),
      EarningStatus.pending => (
          Icons.schedule_rounded,
          theme.colorScheme.secondary,
          theme.colorScheme.secondaryContainer.withValues(alpha: 0.3)
        ),
      EarningStatus.refunded => (
          Icons.refresh_rounded,
          theme.colorScheme.error,
          theme.colorScheme.errorContainer.withValues(alpha: 0.3)
        ),
    };

    return EduCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  earning.studentName,
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  earning.subject,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  earning.dateLabel,
                  style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'MWK ${formatCurrency(earning.tutorAmountMwk)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: earning.status == EarningStatus.refunded
                      ? theme.colorScheme.onSurfaceVariant
                      : theme.colorScheme.primary,
                  decoration: earning.status == EarningStatus.refunded
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                earning.status.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WithdrawalCard extends StatelessWidget {
  const _WithdrawalCard({required this.withdrawal});
  final TutorWithdrawal withdrawal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, color, bg) = switch (withdrawal.status) {
      WithdrawalStatus.completed => (
          Icons.check_circle_rounded,
          theme.colorScheme.primary,
          theme.colorScheme.primaryContainer.withValues(alpha: 0.3)
        ),
      WithdrawalStatus.pending => (
          Icons.schedule_rounded,
          theme.colorScheme.secondary,
          theme.colorScheme.secondaryContainer.withValues(alpha: 0.3)
        ),
      WithdrawalStatus.failed => (
          Icons.error_rounded,
          theme.colorScheme.error,
          theme.colorScheme.errorContainer.withValues(alpha: 0.3)
        ),
    };

    return EduCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Withdrawal to ${withdrawal.method}',
                  style: theme.textTheme.titleSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Ref: ${withdrawal.id}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontFamily: 'monospace',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  withdrawal.dateLabel,
                  style: TextStyle(
                    fontSize: 10,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'MWK ${formatCurrency(withdrawal.amountMwk)}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                withdrawal.status.name.toUpperCase(),
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

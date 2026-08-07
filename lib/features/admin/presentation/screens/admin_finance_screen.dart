import 'package:flutter/material.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../../core/widgets/edu_card.dart';
import '../../../../theme/app_theme.dart';
import '../../data/admin_mock_data.dart';

class AdminFinanceScreen extends StatelessWidget {
  const AdminFinanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final metrics = initialFinanceMetrics;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Financial Overview'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Platform Revenue',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              EduCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    _FinanceRow(
                      label: 'Total Platform Revenue',
                      value: 'MWK ${formatCurrency(metrics.totalRevenue.toInt())}',
                      isHeader: true,
                    ),
                    const Divider(height: 32),
                    _FinanceRow(
                      label: 'Tutor Payouts (85%)',
                      value: 'MWK ${formatCurrency(metrics.tutorPayouts.toInt())}',
                      color: theme.colorScheme.secondary,
                    ),
                    const SizedBox(height: 12),
                    _FinanceRow(
                      label: 'Platform Fees (15%)',
                      value: 'MWK ${formatCurrency(metrics.platformFees.toInt())}',
                      color: theme.colorScheme.primary,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              Text(
                'Withdrawal Requests',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              EduCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiaryContainer,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.outbox_rounded, color: theme.colorScheme.tertiary),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pending Withdrawals',
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            'Action required for ${metrics.pendingWithdrawals > 0 ? "3" : "0"} requests',
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'MWK ${formatCurrency(metrics.pendingWithdrawals.toInt())}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.tertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FinanceRow extends StatelessWidget {
  const _FinanceRow({
    required this.label,
    required this.value,
    this.isHeader = false,
    this.color,
  });

  final String label;
  final String value;
  final bool isHeader;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = isHeader
        ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)
        : theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600, color: color);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: isHeader ? textStyle : theme.textTheme.bodyMedium),
        Text(value, style: textStyle),
      ],
    );
  }
}

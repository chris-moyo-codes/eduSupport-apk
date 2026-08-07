import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/ui_utils.dart';
import '../../../../theme/app_theme.dart';
import '../../application/tutor_profile_controller.dart';
import '../../data/tutor_earnings_mock.dart';

class TutorWithdrawalScreen extends ConsumerStatefulWidget {
  const TutorWithdrawalScreen({super.key});

  @override
  ConsumerState<TutorWithdrawalScreen> createState() =>
      _TutorWithdrawalScreenState();
}

class _TutorWithdrawalScreenState extends ConsumerState<TutorWithdrawalScreen> {
  final _amountController = TextEditingController();
  bool _isProcessing = false;
  bool _isSuccess = false;
  String? _refId;
  String? _errorText;

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _submitWithdrawal(TutorBalance balance, TutorPayoutMethod method) async {
    final amountText = _amountController.text.replaceAll(',', '').trim();
    if (amountText.isEmpty) {
      setState(() => _errorText = 'Please enter an amount.');
      return;
    }
    final amount = int.tryParse(amountText);
    if (amount == null) {
      setState(() => _errorText = 'Please enter a valid number.');
      return;
    }
    if (amount < kMinimumWithdrawalMwk) {
      setState(() => _errorText =
          'Minimum withdrawal is MWK ${formatCurrency(kMinimumWithdrawalMwk)}.');
      return;
    }
    if (amount > balance.availableForWithdrawalMwk) {
      setState(() => _errorText =
          'Amount exceeds available balance (MWK ${formatCurrency(balance.availableForWithdrawalMwk)}).');
      return;
    }

    setState(() {
      _errorText = null;
      _isProcessing = true;
    });

    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      final refId = ref
          .read(tutorEarningsProvider.notifier)
          .requestWithdrawal(amount, method.label);
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
        _refId = refId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final earningsState = ref.watch(tutorEarningsProvider);
    final payoutDetails =
        ref.watch(tutorProfileProvider.select((p) => p.payoutDetails));
    final balance = earningsState.balance;

    if (payoutDetails == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Withdraw Funds')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.account_balance_wallet_outlined,
                    size: 48, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(height: 16),
                const Text('No Payout Method Setup'),
                const SizedBox(height: 8),
                const Text(
                  'Please set up your payout method in your profile before requesting a withdrawal.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Withdraw Funds'),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: _isSuccess
            ? _SuccessView(refId: _refId!)
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Balance info
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer
                            .withValues(alpha: 0.3),
                        borderRadius: EduSupportTheme.radiusLg,
                        border: Border.all(
                            color: theme.colorScheme.primaryContainer),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.account_balance_wallet_rounded,
                              color: theme.colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Available Balance',
                                  style: theme.textTheme.labelMedium?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                Text(
                                  'MWK ${formatCurrency(balance.availableForWithdrawalMwk)}',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: theme.colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Amount input
                    Text(
                      'Amount to withdraw',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w600),
                      decoration: InputDecoration(
                        prefixText: 'MWK ',
                        prefixStyle: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          fontWeight: FontWeight.w600,
                        ),
                        errorText: _errorText,
                        filled: true,
                        fillColor: theme.colorScheme.surfaceContainerLow,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: theme.colorScheme.outlineVariant),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: theme.colorScheme.outlineVariant),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: theme.colorScheme.primary, width: 1.5),
                        ),
                      ),
                      onChanged: (v) {
                        if (_errorText != null) setState(() => _errorText = null);
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Minimum: MWK ${formatCurrency(kMinimumWithdrawalMwk)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Payout method display
                    Text(
                      'Withdrawing to',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: EduSupportTheme.radiusMd,
                        border: Border.all(
                            color: theme.colorScheme.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            payoutDetails.method == TutorPayoutMethod.bank
                                ? Icons.account_balance_rounded
                                : Icons.phone_android_rounded,
                            color: theme.colorScheme.primary,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  payoutDetails.method.label,
                                  style: theme.textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  payoutDetails.accountIdentifier,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () => showNotImplementedSnackBar(context),
                            child: const Text('Change'),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 48),

                    // Submit button
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isProcessing
                            ? null
                            : () => _submitWithdrawal(
                                balance, payoutDetails.method),
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14)),
                        ),
                        child: _isProcessing
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.white),
                              )
                            : const Text('Request Withdrawal'),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}

// ─── Success View ─────────────────────────────────────────────────────────────

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.refId});
  final String refId;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_rounded,
                  size: 40, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              'Withdrawal Requested',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              'Your withdrawal request has been submitted successfully and is currently pending review. Funds will be deposited within 1–2 business days.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    'Reference ID',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    refId,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontFamily: 'monospace',
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 36),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Back to Earnings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

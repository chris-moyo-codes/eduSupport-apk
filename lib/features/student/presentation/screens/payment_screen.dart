import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../theme/app_theme.dart';
import '../../data/premium_repository.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key, required this.plan});

  final PremiumPlan plan;

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.mpamba;
  final _accountController = TextEditingController();
  bool _isProcessing = false;
  bool _isComplete = false;

  @override
  void dispose() {
    _accountController.dispose();
    super.dispose();
  }

  Future<void> _pay() async {
    if (_accountController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Please enter your ${_selectedMethod.fieldLabel.toLowerCase()}.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() => _isProcessing = true);
    // Simulate processing delay
    await Future<void>.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      ref.read(premiumControllerProvider.notifier).activate(widget.plan);
      setState(() {
        _isProcessing = false;
        _isComplete = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Payment'),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: _isComplete
            ? _SuccessView(plan: widget.plan)
            : _PaymentForm(
                plan: widget.plan,
                selectedMethod: _selectedMethod,
                accountController: _accountController,
                isProcessing: _isProcessing,
                onMethodChanged: (m) =>
                    setState(() => _selectedMethod = m),
                onPay: _pay,
              ),
      ),
    );
  }
}

// ─── Payment Form ─────────────────────────────────────────────────────────────

class _PaymentForm extends StatelessWidget {
  const _PaymentForm({
    required this.plan,
    required this.selectedMethod,
    required this.accountController,
    required this.isProcessing,
    required this.onMethodChanged,
    required this.onPay,
  });

  final PremiumPlan plan;
  final PaymentMethod selectedMethod;
  final TextEditingController accountController;
  final bool isProcessing;
  final ValueChanged<PaymentMethod> onMethodChanged;
  final VoidCallback onPay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 48),
      children: [
        // ── Order Summary ──────────────────────────────────────────────────────
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.06),
            borderRadius: EduSupportTheme.radiusLg,
            border: Border.all(
                color: theme.colorScheme.primary.withValues(alpha: 0.25)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'EduSupport Premium — ${plan.label}',
                    style: theme.textTheme.titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Icon(Icons.workspace_premium_rounded,
                      color: theme.colorScheme.primary, size: 20),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Plan', style: theme.textTheme.bodySmall),
                  Text(plan.label, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total due', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                  Text(
                    plan.priceLabel,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: theme.colorScheme.primary,
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
        const SizedBox(height: 28),

        // ── Payment Method Selection ───────────────────────────────────────────
        Text(
          'Payment method',
          style: theme.textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ...PaymentMethod.values.map((method) {
          final isSelected = method == selectedMethod;
          return GestureDetector(
            onTap: () => onMethodChanged(method),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? theme.colorScheme.primary.withValues(alpha: 0.06)
                    : theme.colorScheme.surface,
                borderRadius: EduSupportTheme.radiusMd,
                border: Border.all(
                  color: isSelected
                      ? theme.colorScheme.primary
                      : theme.colorScheme.outlineVariant,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  _MethodIcon(method: method),
                  const SizedBox(width: 12),
                  Text(
                    method.label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  if (isSelected)
                    Icon(Icons.radio_button_checked_rounded,
                        size: 20, color: theme.colorScheme.primary)
                  else
                    Icon(Icons.radio_button_off_rounded,
                        size: 20, color: theme.colorScheme.onSurfaceVariant),
                ],
              ),
            ),
          );
        }),

        const SizedBox(height: 20),

        // ── Account Input ─────────────────────────────────────────────────────
        Text(
          selectedMethod.fieldLabel,
          style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: accountController,
          keyboardType: selectedMethod == PaymentMethod.bank
              ? TextInputType.text
              : TextInputType.phone,
          decoration: InputDecoration(
            hintText: selectedMethod.hint,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant),
            filled: true,
            fillColor: theme.colorScheme.surfaceContainerLow,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  BorderSide(color: theme.colorScheme.primary, width: 1.5),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),

        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerLow,
            borderRadius: EduSupportTheme.radiusMd,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.lock_rounded,
                  size: 14, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'This is a demo payment. No real money will be charged. This flow simulates the EduSupport payment experience.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // ── Pay Button ────────────────────────────────────────────────────────
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: isProcessing ? null : onPay,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: isProcessing
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      ),
                      SizedBox(width: 12),
                      Text('Processing payment…'),
                    ],
                  )
                : Text('Pay ${plan.priceLabel}'),
          ),
        ),
      ],
    );
  }
}

// ─── Method Icon ──────────────────────────────────────────────────────────────

class _MethodIcon extends StatelessWidget {
  const _MethodIcon({required this.method});
  final PaymentMethod method;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (IconData icon, Color color) = switch (method) {
      PaymentMethod.mpamba => (Icons.phone_android_rounded, const Color(0xFF2563EB)),
      PaymentMethod.airtelMoney => (Icons.sim_card_rounded, const Color(0xFFDC2626)),
      PaymentMethod.bank => (Icons.account_balance_rounded, theme.colorScheme.primary),
    };
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 18, color: color),
    );
  }
}

// ─── Success View ─────────────────────────────────────────────────────────────

class _SuccessView extends StatelessWidget {
  const _SuccessView({required this.plan});
  final PremiumPlan plan;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withValues(alpha: 0.7),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.workspace_premium_rounded,
                size: 40, color: Colors.white),
          ),
          const SizedBox(height: 24),
          Text(
            'Welcome to Premium!',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Your ${plan.label} plan is now active. Enjoy access to all premium resources and features.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {
                // Pop back to the screen that opened premium flow
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('Start learning'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: const Text('View Premium Plans'),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/edu_button.dart';
import '../../../../theme/app_theme.dart';
import '../../../auth/application/auth_controller.dart';

class AccountDeletionScreen extends ConsumerStatefulWidget {
  const AccountDeletionScreen({super.key});

  @override
  ConsumerState<AccountDeletionScreen> createState() =>
      _AccountDeletionScreenState();
}

class _AccountDeletionScreenState extends ConsumerState<AccountDeletionScreen> {
  final _passwordController = TextEditingController();
  bool _isProcessing = false;
  String? _errorText;
  bool _confirmDataLoss = false;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    if (!_confirmDataLoss) {
      setState(() => _errorText = 'You must confirm that you understand the consequences.');
      return;
    }
    if (_passwordController.text.trim().isEmpty) {
      setState(() => _errorText = 'Please enter your password to confirm.');
      return;
    }

    setState(() {
      _errorText = null;
      _isProcessing = true;
    });

    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      // Navigate to root and log out
      Navigator.of(context).popUntil((route) => route.isFirst);
      ref.read(authControllerProvider.notifier).logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Delete Account'),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
                  borderRadius: EduSupportTheme.radiusLg,
                  border: Border.all(color: theme.colorScheme.errorContainer),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.warning_amber_rounded,
                        color: theme.colorScheme.error),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Warning: This action is permanent',
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: theme.colorScheme.error,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Once you delete your account, there is no going back. Please be certain.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onErrorContainer,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              Text(
                'What happens when you delete your account:',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 16),
              _buildConsequenceRow(
                context,
                Icons.person_off_rounded,
                'Your profile and personal data will be permanently erased.',
              ),
              _buildConsequenceRow(
                context,
                Icons.calendar_month_rounded,
                'All upcoming sessions will be cancelled.',
              ),
              _buildConsequenceRow(
                context,
                Icons.folder_delete_rounded,
                'Your saved resources and progress will be lost.',
              ),
              _buildConsequenceRow(
                context,
                Icons.money_off_rounded,
                'Any remaining premium subscription time will be forfeited without refund.',
              ),

              const SizedBox(height: 32),
              
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24,
                    height: 24,
                    child: Checkbox(
                      value: _confirmDataLoss,
                      activeColor: theme.colorScheme.error,
                      onChanged: (val) {
                        setState(() {
                          _confirmDataLoss = val ?? false;
                          if (_errorText != null) _errorText = null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _confirmDataLoss = !_confirmDataLoss;
                          if (_errorText != null) _errorText = null;
                        });
                      },
                      child: Text(
                        'I understand that this will permanently delete my account and data.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),

              Text(
                'Verify your identity',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  errorText: _errorText,
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerLow,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
                  ),
                ),
                onChanged: (_) {
                  if (_errorText != null) setState(() => _errorText = null);
                },
              ),

              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                child: EduButton(
                  label: _isProcessing ? 'Deleting...' : 'Delete My Account',
                  variant: EduButtonVariant.destructive,
                  onPressed: _isProcessing ? null : _deleteAccount,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: EduButton(
                  label: 'Cancel',
                  variant: EduButtonVariant.ghost,
                  onPressed: _isProcessing ? null : () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConsequenceRow(BuildContext context, IconData icon, String text) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

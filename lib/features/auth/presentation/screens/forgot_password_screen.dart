import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_text_field.dart';
import '../../application/auth_controller.dart';
import '../../../../theme/app_theme.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _success = false;

  Future<void> _submit() async {
    final email = _emailController.text;
    if (email.isEmpty) return;

    final success = await ref.read(authControllerProvider.notifier).recoverPassword(email);
    if (success && mounted) {
      setState(() => _success = true);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);
    final topPadding = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.black, // Behind image
      body: Stack(
        children: [
          // ── Background Image Hero ──────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.55,
            child: Image.asset(
              'assets/images/login-hero.jpg', // Re-using the strong photographic hero
              fit: BoxFit.cover,
            ),
          ),

          // ── Scrollable Form Area ───────────────────────────────────────────
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SizedBox(height: screenHeight * 0.35), // Space for image to show
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  padding: const EdgeInsets.fromLTRB(32, 40, 32, 32),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: _success ? _buildSuccessState(theme) : _buildFormState(theme, authState),
                  ),
                ),
              ),
            ],
          ),

          // ── Back Button (Floating Top Left) ──────────────────────────────────
          Positioned(
            top: topPadding + 16,
            left: 24,
            child: GestureDetector(
              onTap: () {
                if (!authState.isSubmitting) context.pop();
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: EduSupportTheme.radiusLg,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormState(ThemeData theme, AuthState authState) {
    return Column(
      key: const ValueKey('form'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Typography Hero
        Text(
          'Get back on track.',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            fontFamily: 'Georgia',
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Enter your email address and we\'ll send you a link to reset your password.',
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 32),

        // Error Message
        if (authState.errorMessage != null)
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 24),
            decoration: BoxDecoration(
              color: theme.colorScheme.error.withValues(alpha: 0.1),
              borderRadius: EduSupportTheme.radiusLg,
            ),
            child: Text(
              authState.errorMessage!,
              style: TextStyle(
                color: theme.colorScheme.error,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        // Form
        EduTextField(
          label: 'Email address',
          hintText: 'name@example.com',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          enabled: !authState.isSubmitting,
        ),
        const SizedBox(height: 32),
        EduButton(
          label: 'Send Recovery Link',
          fullWidth: true,
          size: EduButtonSize.large,
          loading: authState.isSubmitting,
          onPressed: _submit,
        ),
        
        const Spacer(),
        const SizedBox(height: 32),
      ],
    );
  }

  Widget _buildSuccessState(ThemeData theme) {
    return Column(
      key: const ValueKey('success'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Spacer(),
        Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary, size: 64),
        const SizedBox(height: 24),
        Text(
          'Recovery simulated',
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
            fontFamily: 'Georgia',
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'If this were connected to a live backend, password reset instructions would have been sent to ${_emailController.text}.',
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 48),
        EduButton(
          label: 'Return to login',
          fullWidth: true,
          size: EduButtonSize.large,
          onPressed: () => context.pop(),
        ),
        const Spacer(),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_text_field.dart';
import '../../application/auth_controller.dart';
import '../../../../theme/app_theme.dart';

class RegistrationScreen extends ConsumerStatefulWidget {
  const RegistrationScreen({super.key});

  @override
  ConsumerState<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends ConsumerState<RegistrationScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  Future<void> _register() async {
    final name = _nameController.text;
    final email = _emailController.text;
    final pass = _passwordController.text;
    
    if (name.isEmpty || email.isEmpty || pass.isEmpty) return;
    if (pass.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password must be at least 8 characters')),
      );
      return;
    }

    final success = await ref.read(authControllerProvider.notifier).register(name, email, pass);
    if (success && mounted) {
      // The authController state change will automatically trigger GoRouter redirect
      // to the dashboard, but we can also show a success snackbar if we want.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Typography Hero
                      Text(
                        'Begin your journey.',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          fontFamily: 'Georgia',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Create an account to access premium resources.',
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
                        label: 'Full Name',
                        hintText: 'e.g. Jane Doe',
                        controller: _nameController,
                        keyboardType: TextInputType.name,
                        enabled: !authState.isSubmitting,
                      ),
                      const SizedBox(height: 20),
                      EduTextField(
                        label: 'Email address',
                        hintText: 'name@example.com',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        enabled: !authState.isSubmitting,
                      ),
                      const SizedBox(height: 20),
                      EduTextField(
                        label: 'Password',
                        hintText: 'Create a password (min 8 chars)',
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        enabled: !authState.isSubmitting,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                            color: theme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                      const SizedBox(height: 32),
                      EduButton(
                        label: 'Sign Up',
                        fullWidth: true,
                        size: EduButtonSize.large,
                        loading: authState.isSubmitting,
                        onPressed: _register,
                      ),
                      
                      const Spacer(),
                      const SizedBox(height: 32),
                      
                      // Bottom Link
                      Center(
                        child: GestureDetector(
                          onTap: () => context.go('/login'),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              text: TextSpan(
                                text: 'Already have an account? ',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign in',
                                    style: TextStyle(
                                      color: theme.colorScheme.onSurface,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
}

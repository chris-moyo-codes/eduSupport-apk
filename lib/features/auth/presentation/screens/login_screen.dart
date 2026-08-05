import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/dev_tools.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_text_field.dart';
import '../../application/auth_controller.dart';
import '../../../../theme/app_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  void _fillDemo(String email, String password) {
    _emailController.text = email;
    _passwordController.text = password;
  }

  Future<void> _login() async {
    final email = _emailController.text;
    final pass = _passwordController.text;
    if (email.isEmpty || pass.isEmpty) return;

    await ref.read(authControllerProvider.notifier).login(email, pass);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Top Logo / Brand
                    GestureDetector(
                      onLongPress: () {
                        DevTools.resetOnboarding(ref);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Onboarding reset.')),
                        );
                      },
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              borderRadius: EduSupportTheme.radiusLg,
                            ),
                            child: Icon(Icons.school_rounded, color: theme.colorScheme.onPrimary, size: 24),
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'EduSupport',
                            style: theme.textTheme.titleLarge?.copyWith(
                              letterSpacing: -0.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),

                    // Typography Hero
                    Text(
                      'Welcome to your workspace.',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        letterSpacing: -1.0,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Enter your credentials to access your personalized learning environment.',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                    ),
                    const Spacer(flex: 2),

                    // Error Message
                    if (authState.errorMessage != null)
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.only(bottom: 24),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error.withValues(alpha: 0.1),
                          borderRadius: EduSupportTheme.radiusLg,
                          border: Border.all(color: theme.colorScheme.error.withValues(alpha: 0.2)),
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
                      label: 'Email Address',
                      hintText: 'name@edusupport.demo',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      enabled: !authState.isSubmitting,
                    ),
                    const SizedBox(height: 20),
                    EduTextField(
                      label: 'Password',
                      hintText: 'Enter your password',
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
                    const SizedBox(height: 40),
                    EduButton(
                      label: 'Sign In',
                      fullWidth: true,
                      size: EduButtonSize.large,
                      loading: authState.isSubmitting,
                      onPressed: _login,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // Demo Links
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: theme.colorScheme.outline.withValues(alpha: 0.3))),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'DEVELOPMENT ACCESS',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                              letterSpacing: 1.0,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _DemoLink(
                                label: 'Student',
                                onTap: () => _fillDemo('student@edusupport.demo', 'Student@123'),
                              ),
                              _DemoLink(
                                label: 'Tutor',
                                onTap: () => _fillDemo('tutor@edusupport.demo', 'Tutor@123'),
                              ),
                              _DemoLink(
                                label: 'Admin',
                                onTap: () => _fillDemo('admin@edusupport.demo', 'Admin@123'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DemoLink extends StatelessWidget {
  const _DemoLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: EduSupportTheme.radiusSm,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}

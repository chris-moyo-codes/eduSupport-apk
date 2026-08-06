import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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
              'assets/images/login-hero.jpg',
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
                        'Your workspace awaits.',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          fontFamily: 'Georgia', // Serif-style text as requested
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Sign in to access your dashboard and resources.',
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
                      const SizedBox(height: 32),
                      EduButton(
                        label: 'Sign In',
                        fullWidth: true,
                        size: EduButtonSize.large,
                        loading: authState.isSubmitting,
                        onPressed: _login,
                      ),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            if (!authState.isSubmitting) {
                              context.push('/forgot-password');
                            }
                          },
                          style: TextButton.styleFrom(
                            foregroundColor: theme.colorScheme.onSurfaceVariant,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            minimumSize: const Size(0, 0),
                          ),
                          child: const Text('Forgot Password?'),
                        ),
                      ),
                      
                      const Spacer(),
                      const SizedBox(height: 24),
                      
                      // Demo Links
                      Center(
                        child: Text(
                          'Demo Environments',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.6),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _DemoLink(
                            label: 'Student',
                            onTap: () => _fillDemo('student@edusupport.demo', 'Student@123'),
                          ),
                          _Divider(),
                          _DemoLink(
                            label: 'Tutor',
                            onTap: () => _fillDemo('tutor@edusupport.demo', 'Tutor@123'),
                          ),
                          _Divider(),
                          _DemoLink(
                            label: 'Admin',
                            onTap: () => _fillDemo('admin@edusupport.demo', 'Admin@123'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Divider(color: theme.colorScheme.outlineVariant),
                      const SizedBox(height: 16),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            if (!authState.isSubmitting) {
                              context.push('/register');
                            }
                          },
                          child: Text.rich(
                            TextSpan(
                              text: 'New here? ',
                              style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
                              children: [
                                TextSpan(
                                  text: 'Create an account',
                                  style: TextStyle(
                                    color: theme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
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

          // ── App Brand (Floating Top Left) ──────────────────────────────────
          Positioned(
            top: topPadding + 16,
            left: 24,
            child: GestureDetector(
              onLongPress: () {
                DevTools.resetOnboarding(ref);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Onboarding reset.')),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                child: Row(
                  children: [
                    Icon(Icons.school_rounded, color: theme.colorScheme.onSurface, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'EduSupport',
                      style: theme.textTheme.titleMedium?.copyWith(
                        letterSpacing: -0.5,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        '•',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
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
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

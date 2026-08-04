import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_card.dart';
import '../../../../core/widgets/edu_text_field.dart';
import '../../application/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final _emailController = TextEditingController(text: 'demo@edusupport.local');
  final _passwordController = TextEditingController(text: 'password');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: EduCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Welcome back to EduSupport',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Sign in to continue into the mobile experience.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 24),
                    EduTextField(
                      label: 'Email',
                      hintText: 'name@edusupport.local',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    EduTextField(
                      label: 'Password',
                      hintText: 'Enter your password',
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 24),
                    EduButton(
                      label: 'Continue',
                      leading: const Icon(Icons.lock_open_rounded),
                      onPressed: () async {
                        await ref.read(authControllerProvider.notifier).login();
                        if (context.mounted) {
                          context.go(AppRoutes.home);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

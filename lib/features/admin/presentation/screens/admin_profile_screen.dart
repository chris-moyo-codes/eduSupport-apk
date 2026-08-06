import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/edu_avatar.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../theme/app_theme.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../auth/application/auth_controller.dart';

class AdminProfileScreen extends ConsumerWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(authControllerProvider.select((s) => s.user));

    if (user == null) {
      // User was logged out while screen was open — pop back immediately.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) Navigator.of(context).popUntil((r) => r.isFirst);
      });
      return const SizedBox.shrink();
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Profile',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              // ── Avatar & Name ──────────────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    EduAvatar(initials: user.initials, size: 80),
                    const SizedBox(height: 16),
                    Text(
                      user.name,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.email,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: EduSupportTheme.radiusMd,
                      ),
                      child: Text(
                        'Administrator',
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // ── Actions ──────────────────────────────────────────────────
              EduButton(
                fullWidth: true,
                variant: EduButtonVariant.secondary,
                label: 'System Settings',
                leading: const Icon(Icons.settings_rounded, size: 20),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('System settings coming soon.')),
                  );
                },
              ),
              const SizedBox(height: 16),
              EduButton(
                fullWidth: true,
                variant: EduButtonVariant.destructive,
                label: 'Sign Out',
                leading: const Icon(Icons.logout_rounded, size: 20),
                onPressed: () async {
                  final confirm = await showLogoutConfirmationDialog(context);
                  if (confirm == true && context.mounted) {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                    ref.read(authControllerProvider.notifier).logout();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

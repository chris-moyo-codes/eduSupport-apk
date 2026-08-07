import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/edu_avatar.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_card.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../notifications/presentation/widgets/notifications_sheet.dart';
import '../../../notifications/presentation/screens/notification_preferences_screen.dart';
import '../../../settings/application/theme_controller.dart';
import '../../../settings/presentation/screens/account_deletion_screen.dart';
import 'tutor_earnings_screen.dart';
import 'tutor_edit_profile_screen.dart';

class TutorProfileScreen extends ConsumerWidget {
  const TutorProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final user = ref.watch(authControllerProvider.select((s) => s.user));
    final themeMode = ref.watch(themeControllerProvider);
    final isDark = themeMode == EduThemeMode.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Tutor Profile'),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 100),
          child: Column(
            children: [
              EduAvatar(initials: user?.initials ?? 'T', size: 80),
              const SizedBox(height: 16),
              Text(
                user?.name ?? 'Tutor Profile',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                user?.email ?? 'tutor@edusupport.demo',
                style: textTheme.bodyLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 16),
              EduButton(
                label: 'Edit Professional Profile',
                variant: EduButtonVariant.outline,
                size: EduButtonSize.small,
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const TutorEditProfileScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 32),
              
              // App Settings
              EduCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                        color: colorScheme.primary,
                      ),
                      title: const Text('Dark Mode'),
                      trailing: Switch.adaptive(
                        value: isDark,
                        activeTrackColor: colorScheme.primary,
                        onChanged: (val) {
                          ref.read(themeControllerProvider.notifier).setTheme(
                                val ? EduThemeMode.dark : EduThemeMode.light,
                              );
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.notifications_active_outlined,
                        color: colorScheme.primary,
                      ),
                      title: const Text('Notifications'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        showModalBottomSheet<void>(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (context) => const NotificationsSheet(),
                        );
                      },
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.settings_suggest_outlined,
                        color: colorScheme.primary,
                      ),
                      title: const Text('Notification Preferences'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const NotificationPreferencesScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Tutor Settings
              EduCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        Icons.workspace_premium_outlined,
                        color: colorScheme.primary,
                      ),
                      title: const Text('Subjects & Expertise'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () => showNotImplementedSnackBar(context),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.event_available_outlined,
                        color: colorScheme.primary,
                      ),
                      title: const Text('Manage Availability'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: Icon(
                        Icons.account_balance_wallet_outlined,
                        color: colorScheme.primary,
                      ),
                      title: const Text('Earnings & Withdrawals'),
                      trailing: const Icon(Icons.chevron_right_rounded),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const TutorEarningsScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                child: EduButton(
                  label: 'Delete Account',
                  variant: EduButtonVariant.outline,
                  leading: Icon(Icons.person_off_rounded, size: 20, color: theme.colorScheme.error),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const AccountDeletionScreen(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: EduButton(
                  label: 'Sign Out',
                  variant: EduButtonVariant.destructive,
                  leading: const Icon(Icons.logout_rounded, size: 20),
                  onPressed: () async {
                    final confirm = await showLogoutConfirmationDialog(context);
                    if (confirm == true && context.mounted) {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                      ref.read(authControllerProvider.notifier).logout();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../theme/app_theme.dart';

// Simple mock providers for preferences state
final pushNotificationsEnabledProvider = StateProvider<bool>((ref) => true);
final emailNotificationsEnabledProvider = StateProvider<bool>((ref) => true);
final sessionRemindersProvider = StateProvider<bool>((ref) => true);
final newResourcesProvider = StateProvider<bool>((ref) => false);
final premiumUpdatesProvider = StateProvider<bool>((ref) => true);
final marketingProvider = StateProvider<bool>((ref) => false);

class NotificationPreferencesScreen extends ConsumerWidget {
  const NotificationPreferencesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Notification Preferences'),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose how and when you want to be notified by EduSupport.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),
              
              _SectionTitle(title: 'Channels'),
              const SizedBox(height: 8),
              _ToggleRow(
                title: 'Push Notifications',
                description: 'Receive alerts on your device',
                provider: pushNotificationsEnabledProvider,
              ),
              _ToggleRow(
                title: 'Email Notifications',
                description: 'Receive updates via your registered email',
                provider: emailNotificationsEnabledProvider,
              ),

              const SizedBox(height: 32),
              
              _SectionTitle(title: 'Academic & Sessions'),
              const SizedBox(height: 8),
              _ToggleRow(
                title: 'Session Reminders',
                description: 'Reminders before your scheduled sessions',
                provider: sessionRemindersProvider,
              ),
              _ToggleRow(
                title: 'New Resources',
                description: 'When new study materials match your subjects',
                provider: newResourcesProvider,
              ),

              const SizedBox(height: 32),

              _SectionTitle(title: 'Account & Updates'),
              const SizedBox(height: 8),
              _ToggleRow(
                title: 'Premium & Billing',
                description: 'Updates about your subscription and features',
                provider: premiumUpdatesProvider,
              ),
              _ToggleRow(
                title: 'Marketing & Offers',
                description: 'Promotions, surveys, and special offers',
                provider: marketingProvider,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }
}

class _ToggleRow extends ConsumerWidget {
  const _ToggleRow({
    required this.title,
    required this.description,
    required this.provider,
  });

  final String title;
  final String description;
  final StateProvider<bool> provider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final value = ref.watch(provider);
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Switch.adaptive(
            value: value,
            activeTrackColor: theme.colorScheme.primary,
            onChanged: (val) {
              ref.read(provider.notifier).state = val;
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/edu_avatar.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_empty_state.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../notifications/application/notification_controller.dart';
import '../../../notifications/presentation/widgets/notifications_sheet.dart';

class TutorPlaceholderScreen extends ConsumerWidget {
  const TutorPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(authControllerProvider.select((s) => s.user));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Tutor Dashboard',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Consumer(
              builder: (context, ref, child) {
                final unreadCount = ref.watch(unreadCountProvider);
                return IconButton(
                  icon: Badge(
                    isLabelVisible: unreadCount > 0,
                    label: Text(unreadCount > 9 ? '9+' : unreadCount.toString()),
                    backgroundColor: const Color(0xFFC05621),
                    child: const Icon(Icons.notifications_none_rounded),
                  ),
                  onPressed: () {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => const NotificationsSheet(),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: EduAvatar(initials: user?.initials ?? 'T', size: 34),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: EduEmptyState(
            icon: Icons.construction_rounded,
            title: 'Tutor Experience Coming Soon',
            description:
                'The full tutor mobile experience is scheduled for development in Phase 4. '
                'Authentication and role-based routing are now fully active.',
            action: EduButton(
              label: 'Sign Out',
              onPressed: () {
                ref.read(authControllerProvider.notifier).logout();
              },
            ),
          ),
        ),
      ),
    );
  }
}

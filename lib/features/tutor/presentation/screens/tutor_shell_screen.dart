import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/edu_avatar.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../notifications/application/notification_controller.dart';
import '../../../notifications/presentation/widgets/notifications_sheet.dart';
import 'tutor_home_screen.dart';
import 'tutor_profile_screen.dart';
import 'tutor_sessions_screen.dart';
import 'tutor_students_screen.dart';

import 'tutor_tasks_screen.dart';

const _tabTitles = ['Home', 'Tasks', 'Students', 'Sessions'];

class TutorShellScreen extends ConsumerStatefulWidget {
  const TutorShellScreen({super.key});

  @override
  ConsumerState<TutorShellScreen> createState() => _TutorShellScreenState();
}

class _TutorShellScreenState extends ConsumerState<TutorShellScreen> {
  int _selectedIndex = 0;

  void _openSessions() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const TutorSessionsScreen(isStandalone: true)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      TutorHomeScreen(
        onOpenSessions: _openSessions,
        onOpenStudents: () => setState(() => _selectedIndex = 2),
      ),
      const TutorTasksScreen(),
      const TutorStudentsScreen(),
      const TutorSessionsScreen(),
    ];

    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          _tabTitles[_selectedIndex],
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 17,
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
                    backgroundColor: colorScheme.secondary,
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
            child: Consumer(
              builder: (context, ref, child) {
                final user = ref.watch(
                  authControllerProvider.select((s) => s.user),
                );
                return GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(builder: (_) => const TutorProfileScreen()),
                  ),
                  child: EduAvatar(initials: user?.initials ?? 'T', size: 34),
                );
              },
            ),
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.primary.withValues(alpha: 0.08),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() => _selectedIndex = index);
        },
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_outlined),
            selectedIcon: Icon(Icons.assignment_rounded),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_alt_outlined),
            selectedIcon: Icon(Icons.people_alt_rounded),
            label: 'Students',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Sessions',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _openSessions,
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Session'),
            )
          : null,
    );
  }
}

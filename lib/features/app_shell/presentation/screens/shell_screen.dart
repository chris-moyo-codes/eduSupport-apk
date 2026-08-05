import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/edu_avatar.dart';
import '../../../auth/application/auth_controller.dart';
import '../../../notifications/application/notification_controller.dart';
import '../../../notifications/presentation/widgets/notifications_sheet.dart';
import '../../../student/presentation/screens/dashboard_screen.dart';
import '../../../student/presentation/screens/downloads_screen.dart';
import '../../../student/presentation/screens/library_screen.dart';
import '../../../student/presentation/screens/profile_screen.dart';
import '../../../student/presentation/screens/sessions_screen.dart';
import '../../../student/presentation/screens/study_screen.dart';
import '../../../student/presentation/screens/tutors_screen.dart';
import '../../../student/presentation/screens/tasks_screen.dart';
import '../../../student/presentation/screens/progress_screen.dart';

/// Titles for each bottom-nav tab.
const _tabTitles = ['Overview', 'Tasks', 'Library', 'Study', 'Tutors', 'Progress'];

class ShellScreen extends ConsumerStatefulWidget {
  const ShellScreen({super.key});

  @override
  ConsumerState<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends ConsumerState<ShellScreen> {
  int _selectedIndex = 0;

  void _openSessions() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const SessionsScreen()),
    );
  }

  void _openDownloads() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const DownloadsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screens = <Widget>[
      DashboardScreen(
        onOpenSessions: _openSessions,
        onOpenTutors: () => setState(() => _selectedIndex = 4),
        onOpenLibrary: () => setState(() => _selectedIndex = 2),
      ),
      const TasksScreen(),
      const LibraryScreen(),
      const StudyScreen(),
      const TutorsScreen(),
      const ProgressScreen(),
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
                    MaterialPageRoute<void>(
                      builder: (_) => ProfileScreen(onOpenDownloads: _openDownloads),
                    ),
                  ),
                  child: EduAvatar(initials: user?.initials ?? '??', size: 34),
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
            icon: Icon(Icons.book_outlined),
            selectedIcon: Icon(Icons.book_rounded),
            label: 'Library',
          ),
          NavigationDestination(
            icon: Icon(Icons.auto_stories_outlined),
            selectedIcon: Icon(Icons.auto_stories_rounded),
            label: 'Study',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_alt_outlined),
            selectedIcon: Icon(Icons.people_alt_rounded),
            label: 'Tutors',
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_up_rounded),
            selectedIcon: Icon(Icons.trending_up_rounded),
            label: 'Progress',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _openSessions,
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              icon: const Icon(Icons.calendar_month_rounded),
              label: const Text('Sessions'),
            )
          : null,
    );
  }
}

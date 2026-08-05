import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/edu_avatar.dart';
import '../../../student/presentation/screens/dashboard_screen.dart';
import '../../../student/presentation/screens/downloads_screen.dart';
import '../../../student/presentation/screens/library_screen.dart';
import '../../../student/presentation/screens/profile_screen.dart';
import '../../../student/presentation/screens/sessions_screen.dart';
import '../../../student/presentation/screens/study_screen.dart';
import '../../../student/presentation/screens/tutors_screen.dart';

/// Titles for each bottom-nav tab.
const _tabTitles = ['Overview', 'Library', 'Study', 'Tutors', 'Profile'];

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
        onOpenTutors: () => setState(() => _selectedIndex = 3),
        onOpenLibrary: () => setState(() => _selectedIndex = 1),
      ),
      const LibraryScreen(),
      const StudyScreen(),
      const TutorsScreen(),
      ProfileScreen(onOpenDownloads: _openDownloads),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          _tabTitles[_selectedIndex],
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A202C),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: GestureDetector(
              onTap: () => setState(() => _selectedIndex = 4),
              child: const EduAvatar(initials: 'SD', size: 34),
            ),
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: screens),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFFFFFFFF),
        indicatorColor: const Color(0xFF212B36).withValues(alpha: 0.08),
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
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _openSessions,
              backgroundColor: const Color(0xFF212B36),
              foregroundColor: Colors.white,
              icon: const Icon(Icons.calendar_month_rounded),
              label: const Text('Sessions'),
            )
          : null,
    );
  }
}

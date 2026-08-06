import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'admin_alerts_screen.dart';
import 'admin_overview_screen.dart';
import 'admin_settings_screen.dart';
import 'admin_users_screen.dart';

import '../../data/admin_repository.dart';

class AdminShellScreen extends ConsumerStatefulWidget {
  const AdminShellScreen({super.key});

  @override
  ConsumerState<AdminShellScreen> createState() => _AdminShellScreenState();
}

class _AdminShellScreenState extends ConsumerState<AdminShellScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    AdminOverviewScreen(),
    AdminUsersScreen(),
    AdminAlertsScreen(),
    AdminSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alertsAsync = ref.watch(adminAlertsProvider);
    
    // Count unacknowledged critical alerts for badge
    int criticalAlertCount = 0;
    if (alertsAsync is AsyncData) {
      final alerts = alertsAsync.value!;
      criticalAlertCount = alerts.where((a) => !a.isAcknowledged).length;
    }

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Overview',
          ),
          const NavigationDestination(
            icon: Icon(Icons.people_outline_rounded),
            selectedIcon: Icon(Icons.people_rounded),
            label: 'Users',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: criticalAlertCount > 0,
              label: Text(criticalAlertCount > 9 ? '9+' : criticalAlertCount.toString()),
              backgroundColor: theme.colorScheme.error,
              child: const Icon(Icons.notifications_none_rounded),
            ),
            selectedIcon: Badge(
              isLabelVisible: criticalAlertCount > 0,
              label: Text(criticalAlertCount > 9 ? '9+' : criticalAlertCount.toString()),
              backgroundColor: theme.colorScheme.error,
              child: const Icon(Icons.notifications_rounded),
            ),
            label: 'Alerts',
          ),
          const NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

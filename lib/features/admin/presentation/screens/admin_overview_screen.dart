import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/edu_avatar.dart';
import '../../../../theme/app_theme.dart';
import '../../../auth/application/auth_controller.dart';
import '../../data/admin_mock_data.dart';
import '../../data/admin_repository.dart';

class AdminOverviewScreen extends ConsumerWidget {
  const AdminOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final user = ref.watch(authControllerProvider.select((s) => s.user));
    final activityAsync = ref.watch(adminActivityProvider);
    final usersAsync = ref.watch(adminUsersProvider('tutor')); // Just to get pending count
    
    int pendingCount = 0;
    if (usersAsync is AsyncData) {
      pendingCount = usersAsync.value!.where((u) => u.status == 'Pending Review').length;
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Admin Dashboard',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: EduAvatar(initials: user?.initials ?? 'A', size: 34),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header & Health ──────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'System Overview',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Platform is running smoothly.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'All Systems Operational',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 32),

              // ── Quick Stats ──────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: _StatCard(
                      label: 'Total Users',
                      value: '12,450',
                      trend: '+12%',
                      trendColor: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StatCard(
                      label: 'Pending Reviews',
                      value: pendingCount.toString(),
                      trend: 'Requires Action',
                      trendColor: pendingCount > 0 ? theme.colorScheme.error : theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // ── Operations Log ───────────────────────────────────────────
              Text(
                'Operations Log',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              activityAsync.when(
                data: (activities) => Column(
                  children: activities.map((activity) => _ActivityTile(activity: activity)).toList(),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Text('Error loading activity: $e'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.trend,
    required this.trendColor,
  });

  final String label;
  final String value;
  final String trend;
  final Color trendColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: EduSupportTheme.radiusLg,
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            trend,
            style: theme.textTheme.labelSmall?.copyWith(
              color: trendColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.activity});
  
  final PlatformActivity activity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    IconData icon;
    Color iconColor;
    
    switch (activity.type) {
      case 'upload':
        icon = Icons.upload_file_rounded;
        iconColor = theme.colorScheme.primary;
        break;
      case 'registration':
        icon = Icons.person_add_rounded;
        iconColor = theme.colorScheme.secondary;
        break;
      default:
        icon = Icons.settings_system_daydream_rounded;
        iconColor = theme.colorScheme.onSurfaceVariant;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: EduSupportTheme.radiusMd,
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity.action,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Initiated by ${activity.user}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            activity.time,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

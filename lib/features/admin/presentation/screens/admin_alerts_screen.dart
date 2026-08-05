import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/edu_button.dart';
import '../../../../theme/app_theme.dart';
import '../../data/admin_mock_data.dart';
import '../../data/admin_repository.dart';

class AdminAlertsScreen extends ConsumerStatefulWidget {
  const AdminAlertsScreen({super.key});

  @override
  ConsumerState<AdminAlertsScreen> createState() => _AdminAlertsScreenState();
}

class _AdminAlertsScreenState extends ConsumerState<AdminAlertsScreen> {
  String _filter = 'all'; // 'all', 'critical', 'unacknowledged'

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alertsAsync = ref.watch(adminAlertsProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'System Alerts',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Filters ────────────────────────────────────────────────────
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  _FilterChip(
                    label: 'All Alerts',
                    isSelected: _filter == 'all',
                    onTap: () => setState(() => _filter = 'all'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Critical',
                    isSelected: _filter == 'critical',
                    onTap: () => setState(() => _filter = 'critical'),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Unacknowledged',
                    isSelected: _filter == 'unacknowledged',
                    onTap: () => setState(() => _filter = 'unacknowledged'),
                  ),
                ],
              ),
            ),
            
            // ── Alerts List ────────────────────────────────────────────────
            Expanded(
              child: alertsAsync.when(
                data: (alerts) {
                  var filtered = alerts;
                  if (_filter == 'critical') {
                    filtered = filtered.where((a) => a.severity == AlertSeverity.critical).toList();
                  } else if (_filter == 'unacknowledged') {
                    filtered = filtered.where((a) => !a.isAcknowledged).toList();
                  }

                  // Sort: Critical first, then warning, then info. Then unacknowledged first.
                  filtered = List.from(filtered)..sort((a, b) {
                    if (a.isAcknowledged != b.isAcknowledged) {
                      return a.isAcknowledged ? 1 : -1;
                    }
                    return a.severity.index.compareTo(b.severity.index);
                  });

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        'No alerts found.',
                        style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _AlertCard(
                        alert: filtered[index],
                        onTap: () => _showAlertDetail(context, filtered[index]),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, s) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlertDetail(BuildContext context, AdminAlert alert) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _AlertDetailSheet(alert: alert),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(99),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(99),
          border: Border.all(
            color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _AlertCard extends StatelessWidget {
  const _AlertCard({required this.alert, required this.onTap});

  final AdminAlert alert;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    IconData icon;
    Color color;
    
    switch (alert.severity) {
      case AlertSeverity.critical:
        icon = Icons.error_rounded;
        color = theme.colorScheme.error;
        break;
      case AlertSeverity.warning:
        icon = Icons.warning_rounded;
        color = Colors.orange;
        break;
      case AlertSeverity.info:
        icon = Icons.info_rounded;
        color = theme.colorScheme.primary;
        break;
    }

    if (alert.isAcknowledged) {
      color = theme.colorScheme.outline;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: EduSupportTheme.radiusLg,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: EduSupportTheme.radiusLg,
          border: Border.all(color: alert.isAcknowledged ? theme.colorScheme.outlineVariant : color.withValues(alpha: 0.3)),
        ),
        child: Opacity(
          opacity: alert.isAcknowledged ? 0.6 : 1.0,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            alert.title,
                            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (alert.isAcknowledged)
                          const Icon(Icons.check_circle_rounded, size: 16, color: Colors.green)
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alert.description,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      alert.time,
                      style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AlertDetailSheet extends ConsumerWidget {
  const _AlertDetailSheet({required this.alert});

  final AdminAlert alert;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    
    IconData icon;
    Color color;
    String severityLabel;
    
    switch (alert.severity) {
      case AlertSeverity.critical:
        icon = Icons.error_rounded;
        color = theme.colorScheme.error;
        severityLabel = 'Critical';
        break;
      case AlertSeverity.warning:
        icon = Icons.warning_rounded;
        color = Colors.orange;
        severityLabel = 'Warning';
        break;
      case AlertSeverity.info:
        icon = Icons.info_rounded;
        color = theme.colorScheme.primary;
        severityLabel = 'Info';
        break;
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(24),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: color, size: 32),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: EduSupportTheme.radiusSm,
                        ),
                        child: Text(
                          severityLabel.toUpperCase(),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: color,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        alert.title,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              alert.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Reported ${alert.time}',
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 32),
            
            if (!alert.isAcknowledged)
              EduButton(
                fullWidth: true,
                label: 'Acknowledge Alert',
                onPressed: () async {
                  await ref.read(adminRepositoryProvider).acknowledgeAlert(alert.id);
                  ref.invalidate(adminAlertsProvider);
                  if (context.mounted) Navigator.pop(context);
                },
              )
            else
              EduButton(
                fullWidth: true,
                label: 'Close',
                variant: EduButtonVariant.outline,
                onPressed: () => Navigator.pop(context),
              ),
          ],
        ),
      ),
    );
  }
}

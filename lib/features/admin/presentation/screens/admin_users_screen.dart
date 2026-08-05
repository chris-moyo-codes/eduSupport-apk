import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/edu_button.dart';
import '../../../../theme/app_theme.dart';
import '../../data/admin_mock_data.dart';
import '../../data/admin_repository.dart';

class AdminUsersScreen extends ConsumerStatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  ConsumerState<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends ConsumerState<AdminUsersScreen> {
  String _activeSegment = 'student'; // 'student' or 'tutor'
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final usersAsync = ref.watch(adminUsersProvider(_activeSegment));

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'User Management',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // ── Controls ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _SegmentButton(
                          label: 'Students',
                          isActive: _activeSegment == 'student',
                          onTap: () => setState(() => _activeSegment = 'student'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _SegmentButton(
                          label: 'Tutors',
                          isActive: _activeSegment == 'tutor',
                          onTap: () => setState(() => _activeSegment = 'tutor'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    onChanged: (val) => setState(() => _searchQuery = val),
                    decoration: InputDecoration(
                      hintText: 'Search by name or email...',
                      prefixIcon: const Icon(Icons.search_rounded),
                      filled: true,
                      fillColor: theme.colorScheme.surface,
                      border: OutlineInputBorder(
                        borderRadius: EduSupportTheme.radiusMd,
                        borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: EduSupportTheme.radiusMd,
                        borderSide: BorderSide(color: theme.colorScheme.outlineVariant),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    ),
                  ),
                ],
              ),
            ),
            
            // ── List ───────────────────────────────────────────────────────
            Expanded(
              child: usersAsync.when(
                data: (users) {
                  final filtered = users.where((u) => 
                    u.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                    u.email.toLowerCase().contains(_searchQuery.toLowerCase())
                  ).toList();

                  if (filtered.isEmpty) {
                    return const Center(child: Text('No users found.'));
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _UserCard(
                        user: filtered[index],
                        onTap: () => _showUserDetail(context, filtered[index]),
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

  void _showUserDetail(BuildContext context, AdminUser user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _UserDetailSheet(user: user),
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: EduSupportTheme.radiusMd,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isActive ? theme.colorScheme.primary : theme.colorScheme.surface,
          borderRadius: EduSupportTheme.radiusMd,
          border: Border.all(
            color: isActive ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: isActive ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({required this.user, required this.onTap});

  final AdminUser user;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPending = user.status == 'Pending Review';

    return InkWell(
      onTap: onTap,
      borderRadius: EduSupportTheme.radiusLg,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: EduSupportTheme.radiusLg,
          border: Border.all(color: theme.colorScheme.outlineVariant),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                user.name[0].toUpperCase(),
                style: TextStyle(color: theme.colorScheme.onPrimaryContainer),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    user.email,
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            if (isPending)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.errorContainer,
                  borderRadius: EduSupportTheme.radiusSm,
                ),
                child: Text(
                  'Pending',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onErrorContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: EduSupportTheme.radiusSm,
                ),
                child: Text(
                  user.status,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _UserDetailSheet extends ConsumerWidget {
  const _UserDetailSheet({required this.user});

  final AdminUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isPending = user.status == 'Pending Review';

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
                CircleAvatar(
                  radius: 32,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text(
                    user.name[0].toUpperCase(),
                    style: theme.textTheme.headlineMedium?.copyWith(
                      color: theme.colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        user.email,
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            _InfoRow(label: 'Role', value: user.role.toUpperCase()),
            _InfoRow(label: 'Status', value: user.status),
            _InfoRow(label: 'Joined', value: user.joinedDate),
            if (user.role == 'student' && user.riskLevel != null)
              _InfoRow(label: 'Engagement Risk', value: user.riskLevel!),
            if (user.role == 'tutor' && user.rating != null)
              _InfoRow(label: 'Rating', value: '${user.rating} / 5.0'),
              
            const SizedBox(height: 32),
            
            if (isPending) ...[
              Row(
                children: [
                  Expanded(
                    child: EduButton(
                      label: 'Reject',
                      variant: EduButtonVariant.outline,
                      onPressed: () async {
                        await ref.read(adminRepositoryProvider).setTutorStatus(user.id, 'Rejected');
                        ref.invalidate(adminUsersProvider);
                        if (context.mounted) Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: EduButton(
                      label: 'Approve',
                      onPressed: () async {
                        await ref.read(adminRepositoryProvider).setTutorStatus(user.id, 'Active');
                        ref.invalidate(adminUsersProvider);
                        if (context.mounted) Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ] else ...[
              EduButton(
                fullWidth: true,
                label: 'Close',
                variant: EduButtonVariant.outline,
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

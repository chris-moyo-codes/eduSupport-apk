import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/edu_badge.dart';
import '../../../../core/widgets/edu_empty_state.dart';
import '../../../../theme/app_theme.dart';
import '../../data/student_mock_data.dart';
import '../../data/task_repository.dart';
import '../../../../app/router/app_routes.dart';

// ─── Status helpers ───────────────────────────────────────────────────────────

({String label, EduBadgeTone tone}) taskStatusBadge(TaskStatus status) {
  return switch (status) {
    TaskStatus.pending   => (label: 'Pending',    tone: EduBadgeTone.warning),
    TaskStatus.submitted => (label: 'Submitted',  tone: EduBadgeTone.info),
    TaskStatus.graded    => (label: 'Graded',     tone: EduBadgeTone.success),
    TaskStatus.overdue   => (label: 'Overdue',    tone: EduBadgeTone.error),
  };
}

// ─── Task List Item ───────────────────────────────────────────────────────────

class _TaskListItem extends StatelessWidget {
  const _TaskListItem({ required this.task, required this.onTap });

  final StudentTask task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final badge = taskStatusBadge(task.status);

    return InkWell(
      onTap: onTap,
      borderRadius: EduSupportTheme.radiusLg,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: EduSupportTheme.radiusLg,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                EduBadge(label: badge.label, tone: badge.tone),
                const Spacer(),
                Icon(Icons.chevron_right_rounded, size: 20, color: theme.colorScheme.onSurfaceVariant),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              task.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              '${task.subject} · ${task.grade}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.schedule_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 5),
                Text(
                  'Due ${task.dueDateLabel}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tasks Screen ─────────────────────────────────────────────────────────────

class TasksScreen extends ConsumerStatefulWidget {
  const TasksScreen({super.key});

  @override
  ConsumerState<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends ConsumerState<TasksScreen> {
  String _filter = 'all';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tasksAsync = ref.watch(tasksProvider);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ──────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tasks',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.5,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 4),
                tasksAsync.when(
                  data: (tasks) {
                    final pending = tasks.where((t) => t.status == TaskStatus.pending || t.status == TaskStatus.overdue).length;
                    return Text(
                      pending > 0 ? '$pending task${pending > 1 ? "s" : ""} awaiting submission' : 'All caught up',
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    );
                  },
                  loading: () => const SizedBox.shrink(),
                  error: (err, stack) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Filter tabs ──────────────────────────────────────────────────
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                for (final f in ['all', 'pending', 'submitted', 'graded'])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: _FilterChip(
                      label: f[0].toUpperCase() + f.substring(1),
                      isSelected: _filter == f,
                      onTap: () => setState(() => _filter = f),
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── List ─────────────────────────────────────────────────────────
          Expanded(
            child: tasksAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => EduEmptyState(
                icon: Icons.error_outline_rounded,
                title: 'Failed to load tasks',
                description: 'Please try again.',
              ),
              data: (tasks) {
                final filtered = _filter == 'all'
                    ? tasks
                    : tasks.where((t) => t.status.name == _filter).toList();

                if (filtered.isEmpty) {
                  return EduEmptyState(
                    icon: Icons.assignment_outlined,
                    title: 'No tasks here',
                    description: _filter == 'all'
                        ? 'Your tutor hasn\'t assigned any tasks yet.'
                        : 'No $_filter tasks found.',
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                  itemCount: filtered.length,
                  separatorBuilder: (ctx, index) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => _TaskListItem(
                    task: filtered[i],
                    onTap: () => context.go('${AppRoutes.tasks}/${filtered[i].id}'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Filter Chip ──────────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  const _FilterChip({ required this.label, required this.isSelected, required this.onTap });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.onSurface : theme.colorScheme.surface,
          borderRadius: EduSupportTheme.radiusMd,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: isSelected ? theme.colorScheme.surface : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

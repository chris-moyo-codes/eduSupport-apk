import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../theme/app_theme.dart';
import '../../../student/data/student_mock_data.dart';
import '../../../student/data/task_repository.dart';
import '../../../../core/widgets/edu_empty_state.dart';

class TutorTasksScreen extends ConsumerStatefulWidget {
  const TutorTasksScreen({super.key});

  @override
  ConsumerState<TutorTasksScreen> createState() => _TutorTasksScreenState();
}

class _TutorTasksScreenState extends ConsumerState<TutorTasksScreen> {
  String _filter = 'needs_review';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tasksAsync = ref.watch(tasksProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLowest,
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Row(
              children: [
                _FilterChip(
                  label: 'Needs Review',
                  selected: _filter == 'needs_review',
                  onSelected: () => setState(() => _filter = 'needs_review'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Reviewed',
                  selected: _filter == 'reviewed',
                  onSelected: () => setState(() => _filter = 'reviewed'),
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'All',
                  selected: _filter == 'all',
                  onSelected: () => setState(() => _filter = 'all'),
                ),
              ],
            ),
          ),

          // List
          Expanded(
            child: tasksAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => EduEmptyState(
                icon: Icons.error_outline_rounded,
                title: 'Failed to load submissions',
                description: 'Please try again.',
              ),
              data: (tasks) {
                // Tutors only see submitted/graded tasks
                final reviewable = tasks.where((t) => t.status == TaskStatus.submitted || t.status == TaskStatus.graded).toList();
                
                final filtered = _filter == 'all'
                    ? reviewable
                    : reviewable.where((t) => t.status == (_filter == 'needs_review' ? TaskStatus.submitted : TaskStatus.graded)).toList();

                if (filtered.isEmpty) {
                  return EduEmptyState(
                    icon: Icons.assignment_turned_in_outlined,
                    title: 'No submissions here',
                    description: _filter == 'all'
                        ? 'There are no submissions to review yet.'
                        : 'No $_filter submissions found.',
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 100), // padding for fab/nav
                  itemCount: filtered.length,
                  separatorBuilder: (ctx, index) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => _TutorTaskListItem(
                    task: filtered[i],
                    onTap: () => context.go('${AppRoutes.tutorTasks}/${filtered[i].id}'),
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

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ActionChip(
      label: Text(
        label,
        style: TextStyle(
          color: selected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      backgroundColor: selected ? theme.colorScheme.primary : theme.colorScheme.surfaceContainer,
      onPressed: onSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: selected ? Colors.transparent : theme.colorScheme.outlineVariant,
        ),
      ),
    );
  }
}

class _TutorTaskListItem extends StatelessWidget {
  const _TutorTaskListItem({required this.task, required this.onTap});

  final StudentTask task;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Tutor sees 'submitted' as Needs Review, 'graded' as Reviewed
    final isNeedsReview = task.status == TaskStatus.submitted;
    
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  task.subject.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: isNeedsReview ? Colors.blue.shade50 : Colors.green.shade50,
                    borderRadius: EduSupportTheme.radiusSm,
                    border: Border.all(
                      color: isNeedsReview ? Colors.blue.shade200 : Colors.green.shade200,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isNeedsReview ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
                        size: 12,
                        color: isNeedsReview ? Colors.blue.shade700 : Colors.green.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        isNeedsReview ? 'Needs Review' : 'Reviewed',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isNeedsReview ? Colors.blue.shade700 : Colors.green.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              task.title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.person_outline_rounded, size: 14, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  'Student ID: ${task.id.split('-').last}', // mock
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const Spacer(),
                Icon(Icons.chevron_right_rounded, size: 20, color: theme.colorScheme.onSurfaceVariant),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

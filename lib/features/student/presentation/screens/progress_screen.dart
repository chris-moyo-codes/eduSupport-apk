import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/edu_card.dart';
import '../../../../theme/app_theme.dart';
import '../../data/student_mock_data.dart';
import '../../data/resource_repository.dart';

class ProgressScreen extends ConsumerWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    // Derived stats
    final tasks = mockStudentTasks;
    final gradedTasks = tasks.where((t) => t.status == TaskStatus.graded).toList();
    final submittedTasks = tasks.where((t) => t.status == TaskStatus.submitted).toList();
    final pendingTasks = tasks.where((t) => t.status == TaskStatus.pending || t.status == TaskStatus.overdue).toList();

    final resourcesAsync = ref.watch(resourcesProvider);
    final resources = resourcesAsync.valueOrNull ?? studentResources; // fallback while loading
    
    final completedResources = resources.where((r) => r.status == 'completed').toList();
    final inProgressResources = resources.where((r) => r.status == 'in_progress').toList();
    final savedResources = resources.where((r) => r.isSaved).toList();

    double? avgGradePercent;
    if (gradedTasks.isNotEmpty) {
      double total = 0;
      int count = 0;
      for (final t in gradedTasks) {
        final g = t.awardedGrade;
        if (g != null) {
          final parts = g.split('/');
          if (parts.length == 2) {
            final num = double.tryParse(parts[0]);
            final den = double.tryParse(parts[1]);
            if (num != null && den != null && den > 0) {
              total += (num / den) * 100;
              count++;
            }
          }
        }
      }
      if (count > 0) avgGradePercent = total / count;
    }

    final double totalCourseProgress = studentCourses.isEmpty
        ? 0
        : studentCourses.map((c) => c.progress).reduce((a, b) => a + b) /
            studentCourses.length;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────
            Text(
              'Your Learning Journey',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 4),
            Text(
              'A snapshot of where you are, what you\'ve completed, and what needs attention.',
              style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
            const SizedBox(height: 20),

            // ── Stats row ─────────────────────────────────────────────────
            _SectionLabel(label: 'Overview'),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.check_circle_outline_rounded,
                    iconColor: Colors.green.shade600,
                    iconBg: Colors.green.shade50,
                    value: '${gradedTasks.length}',
                    label: 'Graded',
                    sub: 'of ${tasks.length} tasks',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    icon: Icons.hourglass_empty_rounded,
                    iconColor: cs.primary,
                    iconBg: cs.primary.withValues(alpha: 0.08),
                    value: '${submittedTasks.length}',
                    label: 'Awaiting',
                    sub: 'under review',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.warning_amber_rounded,
                    iconColor: Colors.amber.shade700,
                    iconBg: Colors.amber.shade50,
                    value: '${pendingTasks.length}',
                    label: 'Pending',
                    sub: 'need action',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    icon: Icons.book_outlined,
                    iconColor: cs.primary,
                    iconBg: cs.primary.withValues(alpha: 0.08),
                    value: '${completedResources.length}',
                    label: 'Completed',
                    sub: '${inProgressResources.length} in progress',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Course Progress ───────────────────────────────────────────
            _SectionLabel(label: 'Active Courses'),
            const SizedBox(height: 10),
            EduCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Avg. ${totalCourseProgress.round()}% complete',
                          style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  ...studentCourses.map((course) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        course.title,
                                        style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${course.subject} · ${course.grade}',
                                        style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${course.progress}%',
                                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(999),
                              child: LinearProgressIndicator(
                                value: course.progress / 100,
                                backgroundColor: cs.surfaceContainerHigh,
                                valueColor: AlwaysStoppedAnimation<Color>(cs.primary),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Performance ───────────────────────────────────────────────
            _SectionLabel(label: 'Assignment Performance'),
            const SizedBox(height: 10),
            if (avgGradePercent != null)
              EduCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: cs.primary, width: 3),
                          ),
                          child: Center(
                            child: Text(
                              '${avgGradePercent.round()}%',
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Average Grade', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                            Text(
                              'Based on ${gradedTasks.length} graded assignment${gradedTasks.length != 1 ? 's' : ''}',
                              style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (gradedTasks.isNotEmpty) ...{
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                      const SizedBox(height: 12),
                      ...gradedTasks.map((t) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_rounded, color: Colors.green.shade600, size: 16),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(t.title,
                                          style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis),
                                      Text(t.subject, style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  t.awardedGrade ?? '—',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                              ],
                            ),
                          )),
                    },
                  ],
                ),
              )
            else
              EduCard(
                child: Row(
                  children: [
                    Icon(Icons.star_border_rounded, color: cs.onSurfaceVariant, size: 32),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('No grades yet', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                          Text('Grades will appear here once your tutor reviews your work.',
                              style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 24),

            // ── Tutor Feedback ────────────────────────────────────────────
            if (gradedTasks.any((t) => t.gradeFeedback != null)) ...{
              _SectionLabel(label: 'Tutor Feedback'),
              const SizedBox(height: 10),
              ...gradedTasks.where((t) => t.gradeFeedback != null).map((task) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: EduSupportTheme.radiusLg,
                        border: Border.all(color: Colors.green.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  task.title,
                                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (task.awardedGrade != null)
                                Text(
                                  task.awardedGrade!,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: Colors.green.shade800,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${task.subject} · ${task.tutorName}',
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.green.shade700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            task.gradeFeedback!,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.green.shade900,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 8),
            },

            // ── Saved Resources ───────────────────────────────────────────
            if (savedResources.isNotEmpty) ...{
              _SectionLabel(label: 'Saved Resources'),
              const SizedBox(height: 10),
              ...savedResources.take(3).map((r) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: cs.surface,
                        borderRadius: EduSupportTheme.radiusLg,
                        border: Border.all(color: cs.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: cs.primary.withValues(alpha: 0.08),
                              borderRadius: EduSupportTheme.radiusMd,
                            ),
                            child: Icon(Icons.bookmark_rounded, color: cs.primary, size: 18),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(r.title,
                                    style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Text('${r.subject} · ${r.grade}',
                                    style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
                              ],
                            ),
                          ),
                          Icon(Icons.chevron_right_rounded, color: cs.onSurfaceVariant, size: 18),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 16),
            },

            // ── What's Next ───────────────────────────────────────────────
            _SectionLabel(label: 'Continue Your Journey'),
            const SizedBox(height: 10),
            _QuickActionRow(
              icon: Icons.book_outlined,
              label: 'Browse Library',
              sub: 'Textbooks, guides, past papers',
              cs: cs,
              theme: theme,
            ),
            const SizedBox(height: 8),
            _QuickActionRow(
              icon: Icons.assignment_outlined,
              label: 'View Assignments',
              sub: 'Submit work & see feedback',
              cs: cs,
              theme: theme,
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Supporting Widgets ───────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.value,
    required this.label,
    required this.sub,
  });

  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String value;
  final String label;
  final String sub;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return EduCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(color: iconBg, borderRadius: EduSupportTheme.radiusMd),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(height: 10),
          Text(value,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700, height: 1)),
          const SizedBox(height: 2),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)),
          Text(sub,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 11,
              )),
        ],
      ),
    );
  }
}

class _QuickActionRow extends StatelessWidget {
  const _QuickActionRow({
    required this.icon,
    required this.label,
    required this.sub,
    required this.cs,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final String sub;
  final ColorScheme cs;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: EduSupportTheme.radiusLg,
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.08),
              borderRadius: EduSupportTheme.radiusMd,
            ),
            child: Icon(icon, color: cs.primary, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                Text(sub, style: theme.textTheme.bodySmall?.copyWith(color: cs.onSurfaceVariant)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_rounded, color: cs.onSurfaceVariant, size: 18),
        ],
      ),
    );
  }
}

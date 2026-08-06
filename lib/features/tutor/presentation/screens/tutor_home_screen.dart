import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/edu_badge.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_card.dart';
import '../../../../core/widgets/edu_section_header.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../auth/application/auth_controller.dart';
import '../../data/tutor_mock_data.dart';
import '../widgets/student_list_row.dart';
import '../widgets/tutor_metric_card.dart';
import 'tutor_student_detail_screen.dart';
import 'tutor_session_detail_screen.dart';

class TutorHomeScreen extends ConsumerWidget {
  const TutorHomeScreen({
    super.key,
    required this.onOpenSessions,
    required this.onOpenStudents,
  });

  final VoidCallback onOpenSessions;
  final VoidCallback onOpenStudents;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final user = ref.watch(authControllerProvider.select((s) => s.user));
    
    final sessions = ref.watch(tutorSessionsProvider);
    final metrics = ref.watch(tutorMetricsProvider);
    final students = ref.watch(tutorStudentsProvider);
    
    final upcomingSessions = sessions.where((s) => s.status == SessionStatus.scheduled).toList();
    final nextSession = upcomingSessions.isNotEmpty ? upcomingSessions.first : null;
    final needsAttentionStudents = students.where((s) => s.needsAttention).toList();

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Welcome ──────────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good morning, ${user?.name.split(' ').first ?? 'Tutor'}.',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "You have ${upcomingSessions.length} sessions scheduled today.",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Priority Session ─────────────────────────────────────────────
            if (nextSession != null) ...[
              EduSectionHeader(
                title: 'Next Session',
                trailing: EduButton(
                  label: 'View Schedule',
                  variant: EduButtonVariant.ghost,
                  size: EduButtonSize.small,
                  onPressed: onOpenSessions,
                ),
              ),
              const SizedBox(height: 12),
              _PrioritySessionCard(session: nextSession),
              const SizedBox(height: 24),
            ],

            // ── Metrics ──────────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: TutorMetricCard(
                    title: 'Active Students',
                    value: metrics.activeStudents.toString(),
                    icon: Icons.people_alt_rounded,
                    trendIcon: Icons.arrow_upward_rounded,
                    trendText: '+2',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TutorMetricCard(
                    title: 'Hours Taught',
                    value: metrics.hoursTaught.toString(),
                    icon: Icons.schedule_rounded,
                    trendIcon: Icons.arrow_upward_rounded,
                    trendText: '12h this week',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ── Action Required ─────────────────────────────────────────────
            if (needsAttentionStudents.isNotEmpty) ...[
              const EduSectionHeader(title: 'Needs Attention'),
              const SizedBox(height: 12),
              ...needsAttentionStudents.map((student) => StudentListRow(
                student: student,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => TutorStudentDetailScreen(student: student),
                    ),
                  );
                },
              )),
              const SizedBox(height: 12),
              Center(
                child: EduButton(
                  label: 'View All Students',
                  variant: EduButtonVariant.ghost,
                  onPressed: onOpenStudents,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PrioritySessionCard extends ConsumerWidget {
  const _PrioritySessionCard({required this.session});

  final TutorSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final student = ref.watch(tutorStudentsProvider).firstWhere(
          (s) => s.id == session.studentId,
        );

    final isStartingSoon = session.startTime.difference(DateTime.now()).inHours < 1;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => TutorSessionDetailScreen(session: session),
          ),
        );
      },
      child: EduCard(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                EduBadge(
                  label: isStartingSoon ? 'Starting Soon' : 'Upcoming',
                  tone: EduBadgeTone.info,
                ),
                Icon(Icons.more_horiz_rounded, color: colorScheme.onSurfaceVariant),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              DateFormat.jm().format(session.startTime),
              style: textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${session.subject} with ${student.name}',
              style: textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: EduButton(
                    label: 'Join Session',
                    variant: EduButtonVariant.primary,
                    onPressed: () => showNotImplementedSnackBar(context),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: EduButton(
                    label: 'Review Notes',
                    variant: EduButtonVariant.secondary,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => TutorSessionDetailScreen(session: session),
                        ),
                      );
                    },
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


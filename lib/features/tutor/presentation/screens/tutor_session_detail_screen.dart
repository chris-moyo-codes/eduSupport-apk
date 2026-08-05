import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/edu_badge.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_card.dart';
import '../../../../core/widgets/edu_section_header.dart';
import '../../data/tutor_mock_data.dart';
import '../widgets/student_list_row.dart';
import 'tutor_student_detail_screen.dart';

class TutorSessionDetailScreen extends ConsumerWidget {
  const TutorSessionDetailScreen({super.key, required this.session});

  final TutorSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final student = ref.watch(tutorStudentsProvider).firstWhere(
          (s) => s.id == session.studentId,
        );

    final isCompleted = session.status == SessionStatus.completed;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Session Details'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time & Status Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMMd().format(session.startTime),
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${DateFormat.jm().format(session.startTime)} • ${session.durationMinutes} min',
                      style: textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                _StatusBadge(status: session.status),
              ],
            ),
            const SizedBox(height: 24),
            
            // Subject & Topic
            EduCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subject',
                    style: textTheme.labelMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    session.subject,
                    style: textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Student
            const EduSectionHeader(title: 'Student'),
            const SizedBox(height: 12),
            StudentListRow(
              student: student,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => TutorStudentDetailScreen(student: student),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),

            // Session Notes
            const EduSectionHeader(title: 'Session Notes'),
            const SizedBox(height: 12),
            EduCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (session.notes != null) ...[
                    Text(
                      session.notes!,
                      style: textTheme.bodyLarge,
                    ),
                  ] else ...[
                    Text(
                      isCompleted 
                          ? 'No notes were recorded for this session.'
                          : 'Notes can be added during or after the session.',
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                  if (!isCompleted) ...[
                    const SizedBox(height: 16),
                    EduButton(
                      label: 'Add Pre-session Note',
                      variant: EduButtonVariant.outline,
                      onPressed: () {},
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Primary Action
            if (!isCompleted) ...[
              SizedBox(
                width: double.infinity,
                child: EduButton(
                  label: 'Start Session',
                  leading: const Icon(Icons.video_camera_front_rounded, size: 16),
                  variant: EduButtonVariant.primary,
                  onPressed: () {},
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final SessionStatus status;

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case SessionStatus.scheduled:
        return const EduBadge(label: 'Upcoming', tone: EduBadgeTone.info);
      case SessionStatus.completed:
        return const EduBadge(label: 'Completed', tone: EduBadgeTone.neutral);
      case SessionStatus.cancelled:
        return const EduBadge(label: 'Cancelled', tone: EduBadgeTone.error);
      case SessionStatus.inProgress:
        return const EduBadge(label: 'Live Now', tone: EduBadgeTone.warning);
    }
  }
}

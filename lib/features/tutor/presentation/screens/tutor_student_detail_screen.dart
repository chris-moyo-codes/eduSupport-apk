import 'package:flutter/material.dart';

import '../../../../core/widgets/edu_avatar.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_card.dart';
import '../../../../core/widgets/edu_section_header.dart';
import '../../data/tutor_mock_data.dart';

class TutorStudentDetailScreen extends StatelessWidget {
  const TutorStudentDetailScreen({super.key, required this.student});

  final TutorStudent student;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.surfaceContainerLowest,
      appBar: AppBar(
        title: const Text('Student Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Identity
            Center(
              child: Column(
                children: [
                  EduAvatar(initials: student.initials, size: 80),
                  const SizedBox(height: 16),
                  Text(
                    student.name,
                    style: textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${student.grade} • ${student.subject}',
                    style: textTheme.bodyLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Progress Card
            const EduSectionHeader(title: 'Overall Progress'),
            const SizedBox(height: 12),
            EduCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Mastery Score',
                        style: textTheme.titleMedium,
                      ),
                      Text(
                        '${(student.progressScore * 100).toInt()}%',
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: _getProgressColor(colorScheme, student.progressScore),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: student.progressScore,
                    backgroundColor: colorScheme.surfaceContainerHighest,
                    color: _getProgressColor(colorScheme, student.progressScore),
                    minHeight: 8,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Actions
            Row(
              children: [
                Expanded(
                  child: EduButton(
                    label: 'Message',
                    leading: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                    variant: EduButtonVariant.secondary,
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: EduButton(
                    label: 'Schedule',
                    leading: const Icon(Icons.calendar_month_outlined, size: 16),
                    variant: EduButtonVariant.primary,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            
            // Notes Placeholder
            const EduSectionHeader(title: 'Tutor Notes'),
            const SizedBox(height: 12),
            EduCard(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Add private notes about ${student.name.split(' ').first}\'s learning style, goals, or areas needing improvement.',
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getProgressColor(ColorScheme colorScheme, double score) {
    if (score >= 0.8) return colorScheme.primary;
    if (score >= 0.6) return const Color(0xFFC05621); // Warning tone
    return colorScheme.error;
  }
}

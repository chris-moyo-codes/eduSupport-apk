import 'package:flutter/material.dart';

import '../../../../core/widgets/edu_avatar.dart';
import '../../data/tutor_mock_data.dart';

class StudentListRow extends StatelessWidget {
  const StudentListRow({
    super.key,
    required this.student,
    this.onTap,
  });

  final TutorStudent student;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
          ),
          child: Row(
        children: [
          EduAvatar(
            initials: student.initials,
            size: 44,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        student.name,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (student.needsAttention) ...[
                      const SizedBox(width: 8),
                      Icon(
                        Icons.error_outline_rounded,
                        color: colorScheme.error,
                        size: 16,
                      ),
                    ]
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${student.grade} • ${student.subject}',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Progress indicator
          SizedBox(
            width: 40,
            height: 40,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: student.progressScore,
                  backgroundColor: colorScheme.surfaceContainerHighest,
                  color: _getProgressColor(colorScheme, student.progressScore),
                  strokeWidth: 3,
                ),
                Text(
                  '${(student.progressScore * 100).toInt()}%',
                  style: textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
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

  Color _getProgressColor(ColorScheme colorScheme, double score) {
    if (score >= 0.8) return colorScheme.primary;
    if (score >= 0.6) return colorScheme.secondary; // Warning tone
    return colorScheme.error;
  }
}

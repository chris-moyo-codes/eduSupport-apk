import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/edu_badge.dart';
import '../../../../core/widgets/edu_card.dart';
import '../../data/tutor_mock_data.dart';

class TutorSessionTile extends StatelessWidget {
  const TutorSessionTile({
    super.key,
    required this.session,
    required this.studentName,
    this.onTap,
  });

  final TutorSession session;
  final String studentName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    final isCompleted = session.status == SessionStatus.completed;

    return GestureDetector(
      onTap: onTap,
      child: EduCard(
        padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time Column
          SizedBox(
            width: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.jm().format(session.startTime),
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${session.durationMinutes} min',
                  style: textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          
          // Vertical Divider
          Container(
            width: 2,
            height: 48,
            margin: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isCompleted 
                ? colorScheme.outlineVariant 
                : colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Content Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        studentName,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(status: session.status),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  session.subject,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
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

import 'package:flutter/material.dart';

import '../../../../core/utils/ui_utils.dart';
import '../../../../core/widgets/edu_avatar.dart';
import '../../../../core/widgets/edu_badge.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_card.dart';
import '../../../../core/widgets/edu_empty_state.dart';
import '../../../../theme/app_theme.dart';
import '../../data/student_mock_data.dart';

class SessionsScreen extends StatelessWidget {
  const SessionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final upcoming =
        studentSessions.where((s) => s.status == 'upcoming').toList();
    final completed =
        studentSessions.where((s) => s.status == 'completed').toList();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          'Your Sessions',
          style: theme.textTheme.titleMedium?.copyWith(fontSize: 17),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: TextButton(
              onPressed: () => showNotImplementedSnackBar(context),
              child: Text(
                'Find a Tutor',
                style: TextStyle(
                  fontSize: 13,
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Upcoming ────────────────────────────────────────────────────
              Text(
                'Upcoming',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              if (upcoming.isEmpty)
                EduEmptyState(
                  icon: Icons.calendar_today_rounded,
                  title: 'No upcoming sessions',
                  description:
                      'Browse available tutors and book your first session.',
                )
              else
                ...upcoming.map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _SessionCard(session: s),
                  ),
                ),

              const SizedBox(height: 24),

              // ── Past Sessions ────────────────────────────────────────────────
              if (completed.isNotEmpty) ...[
                Text(
                  'Past Sessions',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 12),
                ...completed.map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _SessionCard(session: s),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.session});
  final StudentSession session;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUpcoming = session.status == 'upcoming';
    final isActive = session.status == 'active';
    final isCompleted = session.status == 'completed';

    final (badgeTone, badgeLabel) = switch (session.status) {
      'upcoming'  => (EduBadgeTone.info, 'Upcoming'),
      'active'    => (EduBadgeTone.success, 'Live Now'),
      'completed' => (EduBadgeTone.neutral, 'Completed'),
      'cancelled' => (EduBadgeTone.error, 'Cancelled'),
      _           => (EduBadgeTone.neutral, session.status),
    };

    return EduCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: avatar + subject + badge
          Row(
            children: [
              EduAvatar(initials: session.tutorInitials, size: 38),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      session.tutorName,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      session.subject,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isActive)
                    Container(
                      width: 7,
                      height: 7,
                      margin: const EdgeInsets.only(right: 5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  EduBadge(label: badgeLabel, tone: badgeTone),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Topic
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TOPIC',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.8,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                session.topic,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Time info
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today_rounded,
                      size: 13, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    session.date,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.schedule_rounded,
                      size: 13, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    '${session.time} · ${session.durationMinutes} min',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Tutor notes (completed)
          if (isCompleted && session.notes != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: EduSupportTheme.radiusLg,
                border: Border(
                  left: BorderSide(
                    color: theme.colorScheme.outlineVariant,
                    width: 3,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TUTOR NOTES',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    session.notes!,
                    style: theme.textTheme.bodySmall?.copyWith(height: 1.5),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Actions
          if (isActive)
            EduButton(
              label: 'Join Session Now',
              variant: EduButtonVariant.primary,
              leading: const Icon(Icons.videocam_rounded, size: 16),
              fullWidth: true,
              onPressed: () => showNotImplementedSnackBar(context),
            ),
          if (isUpcoming)
            Row(
              children: [
                Expanded(
                  child: EduButton(
                    label: 'Join Room',
                    variant: EduButtonVariant.secondary,
                    size: EduButtonSize.small,
                    leading: const Icon(Icons.videocam_rounded, size: 15),
                    fullWidth: true,
                    onPressed: () => showNotImplementedSnackBar(context),
                  ),
                ),
                const SizedBox(width: 10),
                EduButton(
                  label: 'Cancel',
                  variant: EduButtonVariant.ghost,
                  size: EduButtonSize.small,
                  onPressed: () => showNotImplementedSnackBar(context),
                ),
              ],
            ),
          if (isCompleted)
            EduButton(
              label: 'Book Again',
              variant: EduButtonVariant.outline,
              size: EduButtonSize.small,
              leading: const Icon(Icons.bookmark_outline_rounded, size: 15),
              onPressed: () => showNotImplementedSnackBar(context),
            ),
        ],
      ),
    );
  }
}

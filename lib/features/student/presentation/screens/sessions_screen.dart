import 'package:flutter/material.dart';

import '../../../../core/widgets/edu_avatar.dart';
import '../../../../core/widgets/edu_badge.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_card.dart';
import '../../../../core/widgets/edu_empty_state.dart';
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
      backgroundColor: const Color(0xFFF0F0EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Your Sessions',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A202C),
          ),
        ),
        leading: const BackButton(color: Color(0xFF1A202C)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Find a Tutor',
                style: TextStyle(
                  fontSize: 13,
                  color: Color(0xFFC05621),
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
                  color: const Color(0xFF1A202C),
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
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF38A169),
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
                  const Icon(Icons.calendar_today_rounded,
                      size: 13, color: Color(0xFF718096)),
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
                  const Icon(Icons.schedule_rounded,
                      size: 13, color: Color(0xFF718096)),
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
                color: const Color(0xFFF5F5F1),
                borderRadius: BorderRadius.circular(8),
                border: const Border(
                  left: BorderSide(
                    color: Color(0xFFC8C5BC),
                    width: 3,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'TUTOR NOTES',
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.0,
                      color: Color(0xFF718096),
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
          const Divider(height: 1, color: Color(0xFFE4E2DC)),
          const SizedBox(height: 12),

          // Actions
          if (isActive)
            EduButton(
              label: 'Join Session Now',
              variant: EduButtonVariant.primary,
              leading: const Icon(Icons.videocam_rounded, size: 16),
              fullWidth: true,
              onPressed: () {},
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
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 10),
                EduButton(
                  label: 'Cancel',
                  variant: EduButtonVariant.ghost,
                  size: EduButtonSize.small,
                  onPressed: () {},
                ),
              ],
            ),
          if (isCompleted)
            EduButton(
              label: 'Book Again',
              variant: EduButtonVariant.outline,
              size: EduButtonSize.small,
              leading: const Icon(Icons.bookmark_outline_rounded, size: 15),
              onPressed: () {},
            ),
        ],
      ),
    );
  }
}

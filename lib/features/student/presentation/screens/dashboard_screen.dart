import 'package:flutter/material.dart';

import '../../../../core/widgets/edu_badge.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_card.dart';
import '../../data/student_mock_data.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    this.onOpenSessions,
    this.onOpenTutors,
    this.onOpenLibrary,
  });

  final VoidCallback? onOpenSessions;
  final VoidCallback? onOpenTutors;
  final VoidCallback? onOpenLibrary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final featuredCourse = studentCourses.first;
    final nextSession = studentSessions.first;

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
                        'Good morning, Student.',
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "You're on a 4-day learning streak. Keep it up.",
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ── Featured Course Hero ──────────────────────────────────────────
            EduCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Continue Learning',
                        style: theme.textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.8,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Spacer(),
                      if (featuredCourse.isDownloaded)
                        EduBadge(label: 'Offline Ready', tone: EduBadgeTone.success),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    featuredCourse.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${featuredCourse.subject} · ${featuredCourse.grade}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: featuredCourse.progress / 100,
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                    color: theme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(4),
                    minHeight: 6,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${featuredCourse.progress}% complete',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              'Last accessed ${featuredCourse.lastAccessed}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      EduButton(
                        label: 'Continue',
                        variant: EduButtonVariant.primary,
                        size: EduButtonSize.small,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ── Study Activity ────────────────────────────────────────────────
            Text(
              'Study Activity',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'This week: ${studentWeeklyActivity.map((a) => a.hours).reduce((a, b) => a + b)} hours studied',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 22),

            // ── Upcoming Session ──────────────────────────────────────────────
            Row(
              children: [
                Text(
                  'Upcoming Session',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: onOpenSessions,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    'View all',
                    style: TextStyle(
                      fontSize: 13,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            EduCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          nextSession.tutorInitials,
                          style: TextStyle(
                            color: theme.colorScheme.onPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              nextSession.subject,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              nextSession.tutorName,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      EduBadge(label: 'Upcoming', tone: EduBadgeTone.info),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    nextSession.topic,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 13,
                          color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        '${nextSession.date} · ${nextSession.time}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.schedule_rounded, size: 13,
                          color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        '${nextSession.durationMinutes} min',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: EduButton(
                          label: 'Join Room',
                          variant: EduButtonVariant.secondary,
                          size: EduButtonSize.small,
                          leading: const Icon(Icons.videocam_rounded, size: 16),
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
                ],
              ),
            ),

            const SizedBox(height: 22),

            // ── Quick Actions ─────────────────────────────────────────────────
            Text(
              'Quick Actions',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: EduButton(
                    label: 'Open Library',
                    variant: EduButtonVariant.secondary,
                    leading: const Icon(Icons.book_rounded, size: 16),
                    fullWidth: true,
                    onPressed: onOpenLibrary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: EduButton(
                    label: 'Find a Tutor',
                    variant: EduButtonVariant.outline,
                    leading: const Icon(Icons.people_alt_rounded, size: 16),
                    fullWidth: true,
                    onPressed: onOpenTutors,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            // ── Offline Library ───────────────────────────────────────────────
            Text(
              'Offline Library',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 10),
            ...studentCourses.skip(1).map(
              (course) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: EduCard(
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.menu_book_rounded, color: theme.colorScheme.primary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              course.title,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Expanded(
                                  child: LinearProgressIndicator(
                                    value: course.progress / 100,
                                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                                    color: theme.colorScheme.primary,
                                    borderRadius: BorderRadius.circular(2),
                                    minHeight: 4,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${course.progress}%',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (course.isDownloaded)
                        const Icon(Icons.download_done_rounded,
                            size: 18, color: Color(0xFF38A169)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

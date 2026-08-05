import 'package:flutter/material.dart';

import '../../../../core/widgets/edu_badge.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../theme/app_theme.dart';
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
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Welcome ──────────────────────────────────────────────────────
            Text(
              'Good morning, Student.',
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 32),

            // ── Featured Course Hero ──────────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerLow,
                borderRadius: EduSupportTheme.radiusXl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: EduSupportTheme.radiusSm,
                        ),
                        child: Text(
                          'CONTINUE',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (featuredCourse.isDownloaded)
                        EduBadge(label: 'Offline Ready', tone: EduBadgeTone.success),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    featuredCourse.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${featuredCourse.subject} · ${featuredCourse.grade}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  LinearProgressIndicator(
                    value: featuredCourse.progress / 100,
                    backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                    color: theme.colorScheme.primary,
                    borderRadius: EduSupportTheme.radiusSm,
                    minHeight: 4,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${featuredCourse.progress}% complete',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 2),
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
                        label: 'Resume',
                        variant: EduButtonVariant.primary,
                        size: EduButtonSize.small,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Upcoming Session ──────────────────────────────────────────────
            Row(
              children: [
                Text(
                  'Upcoming Session',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
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
                      fontSize: 14,
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: EduSupportTheme.radiusLg,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: theme.colorScheme.primary.withValues(alpha: 0.1),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          nextSession.tutorInitials,
                          style: TextStyle(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
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
                            const SizedBox(height: 2),
                            Text(
                              nextSession.tutorName,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    nextSession.topic,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded, size: 16,
                          color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Text(
                        '${nextSession.date} · ${nextSession.time}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(Icons.schedule_rounded, size: 16,
                          color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 6),
                      Text(
                        '${nextSession.durationMinutes} min',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: EduButton(
                          label: 'Join Room',
                          variant: EduButtonVariant.primary,
                          size: EduButtonSize.small,
                          leading: const Icon(Icons.videocam_rounded, size: 18),
                          fullWidth: true,
                          onPressed: () {},
                        ),
                      ),
                      const SizedBox(width: 12),
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

            const SizedBox(height: 32),

            // ── Quick Actions ─────────────────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: EduButton(
                    label: 'Library',
                    variant: EduButtonVariant.secondary,
                    leading: const Icon(Icons.book_rounded, size: 18),
                    fullWidth: true,
                    onPressed: onOpenLibrary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: EduButton(
                    label: 'Tutors',
                    variant: EduButtonVariant.outline,
                    leading: const Icon(Icons.people_alt_rounded, size: 18),
                    fullWidth: true,
                    onPressed: onOpenTutors,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // ── Offline Library ───────────────────────────────────────────────
            Text(
              'Offline Library',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: EduSupportTheme.radiusLg,
              ),
              child: Column(
                children: studentCourses.skip(1).map((course) {
                  final isLast = course == studentCourses.last;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                                borderRadius: EduSupportTheme.radiusMd,
                              ),
                              child: Icon(Icons.menu_book_rounded, 
                                  color: theme.colorScheme.primary, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    course.title,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
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
                                          borderRadius: EduSupportTheme.radiusSm,
                                          minHeight: 4,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Text(
                                        '${course.progress}%',
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          color: theme.colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            if (course.isDownloaded)
                              Icon(Icons.download_done_rounded,
                                  size: 24, color: theme.colorScheme.primary)
                            else
                              Icon(Icons.chevron_right_rounded,
                                  size: 24, color: theme.colorScheme.onSurfaceVariant),
                          ],
                        ),
                      ),
                      if (!isLast)
                        Divider(height: 1, indent: 84, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

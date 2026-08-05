import 'package:flutter/material.dart';

import '../../../../core/widgets/edu_badge.dart';
import '../../../../core/widgets/edu_section_header.dart';
import '../../../../theme/app_theme.dart';
import '../../data/student_mock_data.dart';
import 'flashcard_viewer_screen.dart';

class StudyScreen extends StatelessWidget {
  const StudyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deck = studentFlashcardDeck;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EduSectionHeader(
              title: 'Active Study',
              subtitle: 'Pick up exactly where you left off.',
            ),
            const SizedBox(height: 16),

            // ── Up Next Hero (Soft light card) ────────────────────────────────
            Container(
              width: double.infinity,
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
                          'UP NEXT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.8,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(Icons.bolt_rounded, size: 20, color: theme.colorScheme.secondary),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    deck.title,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${deck.subject} · ${deck.totalCards} cards to review',
                    style: TextStyle(
                      fontSize: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => FlashcardViewerScreen(deck: deck),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_circle_filled_rounded),
                      label: const Text('Start Review'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: theme.colorScheme.onPrimary,
                        minimumSize: const Size(0, 52),
                        shape: RoundedRectangleBorder(
                            borderRadius: EduSupportTheme.radiusLg),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Suggested Activities ─────────────────────────────────────────
            Row(
              children: [
                Text(
                  'Suggested Activities',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: EduSupportTheme.radiusLg,
              ),
              child: Column(
                children: studentStudyItems.map((item) {
                  final isLast = item == studentStudyItems.last;
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
                              child: Icon(Icons.book_outlined, color: theme.colorScheme.primary, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.subject} · ${item.type}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: LinearProgressIndicator(
                                          value: item.progress / 100,
                                          backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                                          color: theme.colorScheme.primary,
                                          borderRadius: EduSupportTheme.radiusSm,
                                          minHeight: 4,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      EduBadge(
                                        label: item.isCompleted ? 'Done' : '${item.progress}%',
                                        tone: item.isCompleted
                                            ? EduBadgeTone.success
                                            : item.progress > 0
                                                ? EduBadgeTone.info
                                                : EduBadgeTone.neutral,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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

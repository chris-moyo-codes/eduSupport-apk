import 'package:flutter/material.dart';

import '../../../../core/widgets/edu_badge.dart';
import '../../../../core/widgets/edu_card.dart';
import '../../../../core/widgets/edu_progress_indicator.dart';
import '../../../../core/widgets/edu_section_header.dart';
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

            // ── Up Next Hero (dark card) ─────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF212B36),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'UP NEXT FOR YOU',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.2,
                      color: Color(0x60FFFFFF),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    deck.title,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${deck.subject} · ${deck.totalCards} cards to review',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xB3FFFFFF),
                    ),
                  ),
                  const SizedBox(height: 20),
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
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFF212B36),
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Suggested Activities ─────────────────────────────────────────
            Row(
              children: [
                const Icon(Icons.bolt_rounded, size: 18, color: Color(0xFFC05621)),
                const SizedBox(width: 6),
                Text(
                  'Suggested Activities',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A202C),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            ...studentStudyItems.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: EduCard(
                  child: Row(
                    children: [
                      EduProgressIndicator(
                        progress: item.progress / 100,
                        size: 52,
                        strokeWidth: 5,
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${item.subject} · ${item.type}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
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
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

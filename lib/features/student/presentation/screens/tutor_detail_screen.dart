import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/ui_utils.dart';
import '../../../../core/widgets/edu_avatar.dart';
import '../../../../core/widgets/edu_badge.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_card.dart';
import '../../../../core/widgets/report_bottom_sheet.dart';
import '../../../../theme/app_theme.dart';
import '../../data/student_mock_data.dart';
import '../../data/tutor_reviews_mock.dart';

class StudentTutorDetailScreen extends ConsumerWidget {
  const StudentTutorDetailScreen({super.key, required this.tutor});

  final StudentTutor tutor;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final reviews = ref.watch(
      tutorRatingControllerProvider
          .select((list) => list.where((r) => r.tutorId == tutor.id).toList()),
    );
    final avgRating = reviews.isEmpty
        ? tutor.rating
        : reviews.fold(0.0, (s, r) => s + r.rating) / reviews.length;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(tutor.name),
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            onSelected: (value) {
              if (value == 'report') {
                showModalBottomSheet<void>(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (_) => ReportBottomSheet(
                    reportTargetName: tutor.name,
                    reportTargetRole: 'tutor',
                  ),
                );
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'report',
                child: Row(
                  children: [
                    Icon(Icons.flag_outlined, size: 18),
                    SizedBox(width: 10),
                    Text('Report Tutor'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Identity Header ──────────────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        EduAvatar(initials: tutor.initials, size: 80),
                        Positioned(
                          bottom: -2,
                          right: -2,
                          child: _AvailabilityDot(
                              availability: tutor.availability),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      tutor.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      tutor.tagline,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    // Quick stats
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _QuickStat(
                          icon: Icons.star_rounded,
                          value: avgRating.toStringAsFixed(1),
                          color: const Color(0xFFF59E0B),
                        ),
                        _Divider(),
                        _QuickStat(
                          icon: Icons.check_circle_outline_rounded,
                          value: '${tutor.sessionsCompleted}',
                          label: 'sessions',
                          color: theme.colorScheme.primary,
                        ),
                        _Divider(),
                        _QuickStat(
                          icon: Icons.reviews_rounded,
                          value: '${reviews.length}',
                          label: 'reviews',
                          color: theme.colorScheme.secondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Availability Banner ──────────────────────────────────────────
              _AvailabilityBanner(availability: tutor.availability),
              const SizedBox(height: 8),

              // ── Book Session Button ──────────────────────────────────────────
              EduButton(
                fullWidth: true,
                variant: tutor.availability == 'available'
                    ? EduButtonVariant.primary
                    : EduButtonVariant.secondary,
                label: tutor.availability == 'available'
                    ? 'Request Session'
                    : tutor.availability == 'busy'
                        ? 'Join Waitlist'
                        : 'Currently Unavailable',
                leading: const Icon(Icons.calendar_month_rounded, size: 18),
                onPressed: tutor.availability == 'offline'
                    ? null
                    : () => showNotImplementedSnackBar(context),
              ),
              const SizedBox(height: 28),

              // ── Subjects ─────────────────────────────────────────────────────
              _SectionTitle(title: 'Subjects'),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: tutor.subjects
                    .map((s) => EduBadge(
                        label: '${s.name} · ${s.level}',
                        tone: EduBadgeTone.info))
                    .toList(),
              ),
              const SizedBox(height: 24),

              // ── Details Card ─────────────────────────────────────────────────
              EduCard(
                padding: EdgeInsets.zero,
                child: Column(
                  children: [
                    _DetailRow(
                      icon: Icons.location_on_outlined,
                      label: 'Location',
                      value: tutor.location,
                    ),
                    const Divider(height: 1),
                    _DetailRow(
                      icon: Icons.schedule_rounded,
                      label: 'Response time',
                      value: tutor.responseTime,
                    ),
                    const Divider(height: 1),
                    _DetailRow(
                      icon: Icons.translate_rounded,
                      label: 'Languages',
                      value: tutor.languages.join(', '),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── Reviews Section ───────────────────────────────────────────────
              Row(
                children: [
                  _SectionTitle(title: 'Reviews'),
                  const Spacer(),
                  if (reviews.isNotEmpty)
                    Text(
                      '${reviews.length} review${reviews.length == 1 ? '' : 's'}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              if (reviews.isEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLow,
                    borderRadius: EduSupportTheme.radiusLg,
                  ),
                  child: Text(
                    'No reviews yet. Be the first to review this tutor.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              else
                ...reviews.map(
                  (review) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _ReviewCard(review: review),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Local Widgets ────────────────────────────────────────────────────────────

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context)
          .textTheme
          .titleMedium
          ?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}

class _QuickStat extends StatelessWidget {
  const _QuickStat({
    required this.icon,
    required this.value,
    this.label,
    required this.color,
  });
  final IconData icon;
  final String value;
  final String? label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 4),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
            ],
          ),
          if (label != null)
            Text(
              label!,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}

class _AvailabilityDot extends StatelessWidget {
  const _AvailabilityDot({required this.availability});
  final String availability;

  @override
  Widget build(BuildContext context) {
    final color = switch (availability) {
      'available' => Theme.of(context).colorScheme.primary,
      'busy' => Theme.of(context).colorScheme.secondary,
      _ => Theme.of(context).colorScheme.outline,
    };
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(
          color: Theme.of(context).colorScheme.surface,
          width: 2.5,
        ),
      ),
    );
  }
}

class _AvailabilityBanner extends StatelessWidget {
  const _AvailabilityBanner({required this.availability});
  final String availability;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (color, bg, text, icon) = switch (availability) {
      'available' => (
          theme.colorScheme.primary,
          theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
          'Available now — can book immediately',
          Icons.check_circle_outline_rounded,
        ),
      'busy' => (
          theme.colorScheme.secondary,
          theme.colorScheme.secondaryContainer.withValues(alpha: 0.5),
          'Currently in a session — join the waitlist',
          Icons.schedule_rounded,
        ),
      _ => (
          theme.colorScheme.onSurfaceVariant,
          theme.colorScheme.surfaceContainerLow,
          'Currently offline — check back later',
          Icons.offline_bolt_outlined,
        ),
    };
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: bg, borderRadius: EduSupportTheme.radiusMd),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.bodySmall
                ?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow(
      {required this.icon, required this.label, required this.value});
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});
  final TutorReview review;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return EduCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              EduAvatar(initials: review.studentInitials, size: 36),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.studentName,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    if (review.sessionSubject != null)
                      Text(
                        review.sessionSubject!,
                        style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _StarRow(rating: review.rating),
                  const SizedBox(height: 2),
                  Text(
                    review.dateLabel,
                    style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            review.reviewText,
            style: theme.textTheme.bodySmall?.copyWith(height: 1.55),
          ),
        ],
      ),
    );
  }
}

class _StarRow extends StatelessWidget {
  const _StarRow({required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        return Icon(
          i < rating.floor()
              ? Icons.star_rounded
              : (i < rating && rating % 1 >= 0.5)
                  ? Icons.star_half_rounded
                  : Icons.star_outline_rounded,
          size: 14,
          color: const Color(0xFFF59E0B),
        );
      }),
    );
  }
}

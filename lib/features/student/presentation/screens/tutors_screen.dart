import 'package:flutter/material.dart';

import '../../../../core/utils/ui_utils.dart';
import '../../../../core/widgets/edu_avatar.dart';
import '../../../../core/widgets/edu_badge.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_card.dart';
import '../../../../core/widgets/edu_empty_state.dart';
import '../../../../core/widgets/edu_search_field.dart';
import '../../../../core/widgets/edu_stat_chip.dart';
import '../../data/student_mock_data.dart';

const _filterLabels = ['All Subjects', 'Available Now'];

class TutorsScreen extends StatefulWidget {
  const TutorsScreen({super.key});

  @override
  State<TutorsScreen> createState() => _TutorsScreenState();
}

class _TutorsScreenState extends State<TutorsScreen> {
  String _query = '';
  String _activeFilter = 'All Subjects';

  List<StudentTutor> get _filtered {
    return studentTutors.where((t) {
      final matchesQuery = _query.isEmpty ||
          t.name.toLowerCase().contains(_query.toLowerCase()) ||
          t.subjects.any(
            (s) => s.name.toLowerCase().contains(_query.toLowerCase()),
          );
      final matchesFilter = _activeFilter == 'All Subjects' ||
          (_activeFilter == 'Available Now' && t.availability == 'available');
      return matchesQuery && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final filtered = _filtered;
    final featured = filtered.where((t) => t.featured).toList();
    final others = filtered.where((t) => !t.featured).toList();

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Fixed search/filter header ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              children: [
                EduSearchField(
                  hintText: 'Search tutors by name or subject…',
                  onChanged: (v) => setState(() => _query = v),
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _filterLabels.map((label) {
                      final active = label == _activeFilter;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () => setState(() => _activeFilter = label),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: active
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.surface,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(
                                color: active
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.outline.withValues(alpha: 0.5),
                              ),
                            ),
                            child: Text(
                              label,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: active
                                    ? theme.colorScheme.onPrimary
                                    : theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 12),
              ],
            ),
          ),

          // ── Scrollable tutor list ─────────────────────────────────────────
          Expanded(
            child: filtered.isEmpty
                ? EduEmptyState(
                    icon: Icons.people_alt_outlined,
                    title: 'No tutors found',
                    description:
                        'Try adjusting your search or availability filter.',
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                    children: [
                      if (featured.isNotEmpty) ...[
                        _SectionHeader(
                          icon: Icons.verified_rounded,
                          label: 'Top-Rated Tutors',
                        ),
                        const SizedBox(height: 10),
                        ...featured.map(
                          (t) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _TutorCard(tutor: t),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                      if (others.isNotEmpty) ...[
                        _SectionHeader(
                          icon: Icons.people_alt_rounded,
                          label: 'All Tutors',
                        ),
                        const SizedBox(height: 10),
                        ...others.map(
                          (t) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: _TutorCard(tutor: t),
                          ),
                        ),
                      ],
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.label,
  });
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 16, color: theme.colorScheme.secondary),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}

class _TutorCard extends StatelessWidget {
  const _TutorCard({required this.tutor});
  final StudentTutor tutor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isOffline = tutor.availability == 'offline';

    final (dotColor, availLabel) = switch (tutor.availability) {
      'available' => (theme.colorScheme.primary,   'Available now'),
      'busy'      => (theme.colorScheme.secondary,  'In a session'),
      _           => (theme.colorScheme.outline,     'Offline'),
    };

    return EduCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: avatar + name + rating
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  EduAvatar(initials: tutor.initials, size: 44),
                  Positioned(
                    bottom: -1,
                    right: -1,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: dotColor,
                        border: Border.all(
                          color: theme.colorScheme.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tutor.name,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      availLabel,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: dotColor,
                      ),
                    ),
                  ],
                ),
              ),
              // Star rating
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star_rounded,
                      size: 14, color: theme.colorScheme.secondary),
                  const SizedBox(width: 3),
                  Text(
                    tutor.rating.toStringAsFixed(1),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Tagline
          Text(
            tutor.tagline,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 10),

          // Subject badges
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: tutor.subjects
                .map(
                  (s) => EduBadge(
                    label: '${s.name} · ${s.level}',
                    tone: EduBadgeTone.info,
                  ),
                )
                .toList(),
          ),

          const SizedBox(height: 10),

          // Stats row
          Wrap(
            spacing: 14,
            runSpacing: 6,
            children: [
              EduStatChip(
                icon: Icons.check_circle_outline_rounded,
                label: '${tutor.sessionsCompleted} sessions',
              ),
              EduStatChip(
                icon: Icons.location_on_outlined,
                label: tutor.location,
              ),
              EduStatChip(
                icon: Icons.schedule_rounded,
                label: tutor.responseTime,
              ),
            ],
          ),

          const SizedBox(height: 14),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Action button
          Row(
            children: [
              Expanded(
                child: EduButton(
                  label: isOffline
                      ? 'Unavailable'
                      : tutor.availability == 'available'
                          ? 'Request Session'
                          : 'Join Waitlist',
                  variant: isOffline
                      ? EduButtonVariant.outline
                      : EduButtonVariant.primary,
                  size: EduButtonSize.small,
                  fullWidth: true,
                  onPressed: isOffline ? null : () => showNotImplementedSnackBar(context),
                ),
              ),
              const SizedBox(width: 10),
              EduButton(
                label: 'Profile',
                variant: EduButtonVariant.ghost,
                size: EduButtonSize.small,
                onPressed: () => showNotImplementedSnackBar(context),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

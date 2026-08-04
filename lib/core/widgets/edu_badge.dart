import 'package:flutter/material.dart';

enum EduBadgeTone { neutral, success, warning, error, info }

class EduBadge extends StatelessWidget {
  const EduBadge({
    super.key,
    required this.label,
    this.tone = EduBadgeTone.neutral,
  });

  final String label;
  final EduBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final color = switch (tone) {
      EduBadgeTone.neutral => Theme.of(context).colorScheme.outlineVariant,
      EduBadgeTone.success => Theme.of(context).colorScheme.primary,
      EduBadgeTone.warning => Theme.of(context).colorScheme.secondary,
      EduBadgeTone.error => Theme.of(context).colorScheme.error,
      EduBadgeTone.info => Theme.of(context).colorScheme.tertiary,
    };

    final foreground = switch (tone) {
      EduBadgeTone.neutral => Theme.of(context).colorScheme.onSurface,
      EduBadgeTone.success => Theme.of(context).colorScheme.onPrimary,
      EduBadgeTone.warning => Theme.of(context).colorScheme.onSecondary,
      EduBadgeTone.error => Theme.of(context).colorScheme.onError,
      EduBadgeTone.info => Theme.of(context).colorScheme.onTertiary,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: foreground,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

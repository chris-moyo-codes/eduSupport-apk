import 'package:flutter/material.dart';

enum EduBadgeTone { neutral, info, success, warning, error }

class EduBadge extends StatelessWidget {
  const EduBadge({super.key, required this.label, this.tone = EduBadgeTone.neutral});

  final String label;
  final EduBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final (bg, fg) = switch (tone) {
      EduBadgeTone.neutral  => (cs.surfaceContainerHigh, cs.onSurfaceVariant),
      EduBadgeTone.info     => (cs.primaryContainer,     cs.onPrimaryContainer),
      EduBadgeTone.success  => (cs.secondaryContainer,   cs.onSecondaryContainer),
      EduBadgeTone.warning  => (cs.tertiaryContainer,    cs.onTertiaryContainer),
      EduBadgeTone.error    => (cs.errorContainer,       cs.onErrorContainer),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

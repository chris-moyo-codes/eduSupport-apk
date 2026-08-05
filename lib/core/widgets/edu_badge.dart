import 'package:flutter/material.dart';

enum EduBadgeTone { neutral, info, success, warning, error }

class EduBadge extends StatelessWidget {
  const EduBadge({super.key, required this.label, this.tone = EduBadgeTone.neutral});

  final String label;
  final EduBadgeTone tone;

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (tone) {
      EduBadgeTone.neutral  => (const Color(0xFFEEEDE8), const Color(0xFF4A5568)),
      EduBadgeTone.info     => (const Color(0xFFEBF4FF), const Color(0xFF2B6CB0)),
      EduBadgeTone.success  => (const Color(0xFFE6FFED), const Color(0xFF22543D)),
      EduBadgeTone.warning  => (const Color(0xFFFEF3C7), const Color(0xFF92400E)),
      EduBadgeTone.error    => (const Color(0xFFFED7D7), const Color(0xFF9B2C2C)),
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

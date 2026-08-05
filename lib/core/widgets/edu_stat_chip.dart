import 'package:flutter/material.dart';

/// A compact inline chip for metadata: rating, location, sessions count etc.
class EduStatChip extends StatelessWidget {
  const EduStatChip({super.key, required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final muted = Theme.of(context).colorScheme.onSurfaceVariant;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: muted),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: muted),
        ),
      ],
    );
  }
}

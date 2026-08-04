import 'package:flutter/material.dart';

class EduProgressIndicator extends StatelessWidget {
  const EduProgressIndicator({
    super.key,
    required this.progress,
    this.size = 88,
    this.strokeWidth = 8,
  });

  final double progress;
  final double size;
  final double strokeWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        value: progress.clamp(0, 1),
        strokeWidth: strokeWidth,
        backgroundColor: Theme.of(context).colorScheme.outlineVariant,
      ),
    );
  }
}

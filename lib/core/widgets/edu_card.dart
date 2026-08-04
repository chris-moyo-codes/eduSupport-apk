import 'package:flutter/material.dart';

class EduCard extends StatelessWidget {
  const EduCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius,
    this.elevated = true,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      side: BorderSide(color: Theme.of(context).colorScheme.outline),
    );

    return Card(
      margin: margin,
      elevation: elevated ? 1 : 0,
      shape: shape,
      color: Theme.of(context).colorScheme.surface,
      child: Padding(padding: padding, child: child),
    );
  }
}

import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

class EduCard extends StatelessWidget {
  const EduCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius,
    this.elevated = false,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final bool elevated;

  @override
  Widget build(BuildContext context) {
    final shape = RoundedRectangleBorder(
      borderRadius: borderRadius ?? EduSupportTheme.radiusLg,
      side: BorderSide(
        color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.5),
        width: 1,
      ),
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

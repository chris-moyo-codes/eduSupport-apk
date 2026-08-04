import 'package:flutter/material.dart';

class EduAvatar extends StatelessWidget {
  const EduAvatar({
    super.key,
    this.initials = 'ES',
    this.size = 40,
    this.backgroundColor,
  });

  final String initials;
  final double size;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Text(
        initials,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.onPrimary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

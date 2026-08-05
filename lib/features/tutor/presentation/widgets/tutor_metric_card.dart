import 'package:flutter/material.dart';

import '../../../../core/widgets/edu_card.dart';

class TutorMetricCard extends StatelessWidget {
  const TutorMetricCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.trendIcon,
    this.trendText,
    this.isPositiveTrend = true,
  });

  final String title;
  final String value;
  final IconData icon;
  final IconData? trendIcon;
  final String? trendText;
  final bool isPositiveTrend;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return EduCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                icon,
                color: colorScheme.primary,
                size: 24,
              ),
              if (trendIcon != null && trendText != null) ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trendIcon,
                      size: 14,
                      color: isPositiveTrend ? Colors.green[700] : colorScheme.error,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      trendText!,
                      style: textTheme.labelSmall?.copyWith(
                        color: isPositiveTrend ? Colors.green[700] : colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

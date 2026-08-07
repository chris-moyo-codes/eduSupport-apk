import 'package:flutter/material.dart';
import '../../../../core/widgets/edu_badge.dart';
import '../../../../core/widgets/edu_card.dart';
import '../../../../theme/app_theme.dart';
import '../../data/admin_mock_data.dart';

class AdminTutorVerificationScreen extends StatelessWidget {
  const AdminTutorVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final applications = initialTutorApplications;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Tutor Verification'),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: applications.length,
          itemBuilder: (context, index) {
            final app = applications[index];
            final isPending = app.status == 'pending';

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: EduCard(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            app.name,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        EduBadge(
                          label: app.status.toUpperCase(),
                          tone: isPending ? EduBadgeTone.warning : EduBadgeTone.success,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      app.email,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      children: app.subjects.map((s) => EduBadge(
                        label: s,
                        tone: EduBadgeTone.info,
                      )).toList(),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Submitted ${app.submittedDate}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    if (isPending) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {},
                              child: const Text('Review Docs'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: FilledButton(
                              onPressed: () {},
                              style: FilledButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                              ),
                              child: const Text('Approve'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/widgets/edu_avatar.dart';
import '../../../../core/widgets/edu_badge.dart';
import '../../../../core/widgets/edu_card.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../auth/application/auth_controller.dart';

class ShellScreen extends ConsumerWidget {
  const ShellScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(mockRoleProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'EduSupport ${role.name[0].toUpperCase()}${role.name.substring(1)}',
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: EduAvatar(initials: role.name.substring(0, 1).toUpperCase()),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Premium mobile foundation',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Design system tokens, reusable widgets, and the mobile application shell are now in place.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        EduBadge(
                          label: 'Role: ${role.name}',
                          tone: EduBadgeTone.info,
                        ),
                        const EduBadge(
                          label: 'Mock local state',
                          tone: EduBadgeTone.success,
                        ),
                        const EduBadge(
                          label: 'Frontend only',
                          tone: EduBadgeTone.neutral,
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    EduCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current shell',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'This placeholder destination proves the app shell, role-aware navigation, and shared UI foundation.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: EduButton(
                                  label: 'Switch role',
                                  variant: EduButtonVariant.secondary,
                                  onPressed: () =>
                                      context.go(AppRoutes.rolePicker),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          const NavigationDestination(
            icon: Icon(Icons.book_rounded),
            label: 'Library',
          ),
          const NavigationDestination(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Sessions',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

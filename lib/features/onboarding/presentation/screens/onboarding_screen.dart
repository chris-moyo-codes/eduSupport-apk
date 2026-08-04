import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_router.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../core/widgets/edu_card.dart';
import '../../application/onboarding_controller.dart';

class OnboardingScreen extends ConsumerWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final onboardingState = ref.watch(onboardingControllerProvider);

    if (onboardingState.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final pages = [
      _OnboardingPageData(
        title: 'Learn with EduSupport',
        description:
            'Premium learning support, trusted tutoring, and practical resources built for consistent progress.',
        assetPath: 'assets/images/african-tutor-kids-hero-CKNi_PkA.webp',
      ),
      _OnboardingPageData(
        title: 'Stay focused',
        description:
            'Offline-friendly study tools and calm, readable interfaces help students keep momentum even when the connection is unstable.',
      ),
      _OnboardingPageData(
        title: 'Move confidently',
        description:
            'Continue into the mock local auth flow and experience the EduSupport mobile foundation in a real user journey.',
      ),
    ];

    final page = pages[onboardingState.currentPage.clamp(0, pages.length - 1)];

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: EduCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      if (page.assetPath != null)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                          child: Image.asset(
                            page.assetPath!,
                            fit: BoxFit.cover,
                            height: 260,
                            width: double.infinity,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              page.title,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              page.description,
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      await ref
                          .read(onboardingControllerProvider.notifier)
                          .skip();
                      if (context.mounted) {
                        context.go(AppRoutes.login);
                      }
                    },
                    child: const Text('Skip'),
                  ),
                  Row(
                    children: List.generate(
                      pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: onboardingState.currentPage == index ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: onboardingState.currentPage == index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.outline,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (onboardingState.currentPage > 0)
                    Expanded(
                      child: EduButton(
                        label: 'Back',
                        variant: EduButtonVariant.outline,
                        onPressed: () => ref
                            .read(onboardingControllerProvider.notifier)
                            .previousPage(),
                      ),
                    ),
                  if (onboardingState.currentPage > 0)
                    const SizedBox(width: 12),
                  Expanded(
                    child: EduButton(
                      label: onboardingState.currentPage == pages.length - 1
                          ? 'Get Started'
                          : 'Continue',
                      onPressed: () async {
                        if (onboardingState.currentPage == pages.length - 1) {
                          await ref
                              .read(onboardingControllerProvider.notifier)
                              .complete();
                          if (context.mounted) {
                            context.go(AppRoutes.login);
                          }
                        } else {
                          ref
                              .read(onboardingControllerProvider.notifier)
                              .nextPage();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  const _OnboardingPageData({
    required this.title,
    required this.description,
    this.assetPath,
  });

  final String title;
  final String description;
  final String? assetPath;
}

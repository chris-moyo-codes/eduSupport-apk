import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/widgets/edu_button.dart';
import '../../../../theme/app_theme.dart';
import '../../application/onboarding_controller.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  double _currentPage = 0;

  final List<_OnboardingPageData> _pages = [
    _OnboardingPageData(
      title: 'Premium learning support.',
      description: 'Trusted tutoring and practical resources built for consistent progress.',
      imagePath: 'assets/images/onboarding-hero.webp',
    ),
    _OnboardingPageData(
      title: 'Focus on what matters.',
      description: 'Calm interfaces and reliable offline tools to keep your momentum going.',
      imagePath: 'assets/images/african-tutor-kids-hero-CKNi_PkA.webp',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNext() {
    final currentIndex = _pageController.page?.round() ?? 0;
    if (currentIndex == _pages.length - 1) {
      ref.read(onboardingControllerProvider.notifier).complete();
      context.go(AppRoutes.login);
    } else {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: EduSupportTheme.easeEduSpring,
      );
      ref.read(onboardingControllerProvider.notifier).nextPage();
    }
  }

  void _onSkip() {
    ref.read(onboardingControllerProvider.notifier).skip();
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(onboardingControllerProvider);
    final theme = Theme.of(context);
    final screenHeight = MediaQuery.of(context).size.height;

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentIndex = state.currentPage.clamp(0, _pages.length - 1);
    final isLastPage = currentIndex == _pages.length - 1;

    return Scaffold(
      backgroundColor: Colors.black, // Dark behind image
      body: Stack(
        children: [
          // ── Background Image Hero ──────────────────────────────────────────
          // We use a PageView for the images to slide them in sync with the text
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight * 0.55,
            child: Stack(
              children: List.generate(_pages.length, (index) {
                final double value = (_currentPage - index).abs();
                final double opacity = (1 - value).clamp(0.0, 1.0);
                return Positioned.fill(
                  child: Opacity(
                    opacity: opacity,
                    child: Image.asset(
                      _pages[index].imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              }),
            ),
          ),

          // ── Brand Logo ─────────────────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 24,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: EduSupportTheme.radiusLg,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.school_rounded, color: theme.colorScheme.onSurface, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'EduSupport',
                    style: theme.textTheme.titleMedium?.copyWith(
                      letterSpacing: -0.5,
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Skip Button ────────────────────────────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            right: 16,
            child: TextButton(
              onPressed: _onSkip,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.black.withValues(alpha: 0.3),
              ),
              child: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
            ),
          ),

          // ── Content Area (White Panel) ─────────────────────────────────────
          Positioned(
            top: screenHeight * 0.45, // Overlap the image slightly
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: _pageController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _pages.length,
                      onPageChanged: (index) {
                        // The state controller can track this if needed
                      },
                      itemBuilder: (context, index) {
                        final page = _pages[index];
                        final double value = (_currentPage - index).abs();
                        final double opacity = (1 - value * 1.5).clamp(0.0, 1.0);
                        final double translateY = value * 20;

                        return Transform.translate(
                          offset: Offset(0, translateY),
                          child: Opacity(
                            opacity: opacity,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(32, 40, 32, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    page.title,
                                    style: theme.textTheme.headlineMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      height: 1.1,
                                      letterSpacing: -0.5,
                                      fontFamily: 'Georgia',
                                      color: theme.colorScheme.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    page.description,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // Bottom Controls
                  Padding(
                    padding: const EdgeInsets.fromLTRB(32, 0, 32, 40),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Indicators
                        Row(
                          children: List.generate(
                            _pages.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: EduSupportTheme.easeEdu,
                              margin: const EdgeInsets.only(right: 8),
                              width: currentIndex == index ? 24 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: currentIndex == index
                                    ? theme.colorScheme.primary
                                    : theme.colorScheme.outline,
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                          ),
                        ),
                        
                        // CTA
                        EduButton(
                          label: isLastPage ? 'Get Started' : 'Next',
                          size: EduButtonSize.large,
                          onPressed: _onNext,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPageData {
  _OnboardingPageData({
    required this.title,
    required this.description,
    required this.imagePath,
  });

  final String title;
  final String description;
  final String imagePath;
}

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
      title: 'Premium\nlearning support.',
      description: 'Trusted tutoring and practical resources built for consistent progress.',
    ),
    _OnboardingPageData(
      title: 'Focus on\nwhat matters.',
      description: 'Calm interfaces and reliable offline tools to keep your momentum going.',
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

    if (state.isLoading) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentIndex = state.currentPage.clamp(0, _pages.length - 1);
    final isLastPage = currentIndex == _pages.length - 1;

    return Scaffold(
      backgroundColor: Colors.black, // Dark behind the image
      body: Stack(
        children: [
          // Global Hero Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/onboarding-hero.webp',
              fit: BoxFit.cover,
              alignment: Alignment(-0.3 + (_currentPage * 0.1), 0), // Subtle parallax
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    theme.colorScheme.surface.withValues(alpha: 0.5),
                    theme.colorScheme.surface,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),
          
          // Page Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: TextButton(
                      onPressed: _onSkip,
                      style: TextButton.styleFrom(
                        foregroundColor: theme.colorScheme.onSurfaceVariant,
                      ),
                      child: const Text('Skip', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                       // Update the controller state just in case, though mostly UI driven
                       // Actually Riverpod controller tracks index for other purposes if needed
                    },
                    itemBuilder: (context, index) {
                      final page = _pages[index];
                      // Calculate opacity based on scroll distance for fade effect
                      final double value = (_currentPage - index).abs();
                      final double opacity = (1 - value * 1.5).clamp(0.0, 1.0);
                      final double translateY = value * 20;

                      return Transform.translate(
                        offset: Offset(0, translateY),
                        child: Opacity(
                          opacity: opacity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  page.title,
                                  style: theme.textTheme.headlineLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    height: 1.1,
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
                                const SizedBox(height: 48), // Space before indicators
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                
                // Bottom Navigation
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
        ],
      ),
    );
  }
}

class _OnboardingPageData {
  _OnboardingPageData({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}

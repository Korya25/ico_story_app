// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ico_story_app/core/router/app_routes.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/widgets/background_container.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';
import 'package:ico_story_app/features/on_boreading/widgets/onboarding_bottom_navigation.dart';
import 'package:ico_story_app/features/on_boreading/widgets/onboarding_page_view.dart';
import 'package:ico_story_app/features/on_boreading/model/onboarding_model.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final List _pages = OnboardingModel.pages;
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int index) => setState(() => _currentPage = index);

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _skipToEnd() {
    _pageController.animateToPage(
      _pages.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void _navigateToHome() {
    context.goNamed(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final current = _pages[_currentPage];

    return Scaffold(
      body: BackgroundContainer(
        color: current.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_currentPage < _pages.length - 1)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: _skipToEnd,
                  child: CustomText(
                    "تخطي",
                    fontWeight: FontWeight.w500,
                    color: AppColors.white,
                    fontSize: 18,
                    // 35
                  ),
                ),
              ),
            Flexible(
              child: OnboardingPageView(
                controller: _pageController,
                pages: _pages,
                currentPage: _currentPage,
                onPageChanged: _onPageChanged,
              ),
            ),
            OnboardingBottomNavigation(
              currentPage: _currentPage,
              totalPages: _pages.length,
              onNext: _nextPage,
              onGetStarted: _navigateToHome,
            ),
          ],
        ),
      ),
    );
  }
}

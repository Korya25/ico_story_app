import 'package:flutter/material.dart';
import 'package:ico_story_app/features/onboarding/widgets/onboarding_widget.dart';

class OnboardingPageView extends StatelessWidget {
  final PageController controller;
  final List pages;
  final int currentPage;
  final Function(int) onPageChanged;
  final VoidCallback? onGetStarted;

  const OnboardingPageView({
    super.key,
    required this.controller,
    required this.pages,
    required this.currentPage,
    required this.onPageChanged,
    this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      onPageChanged: onPageChanged,
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return OnboardingWidget(
          page: pages[index],
          animationDelay: index * 200,
        );
      },
    );
  }
}

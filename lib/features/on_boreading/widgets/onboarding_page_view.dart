import 'package:flutter/material.dart';
import 'package:ico_story_app/features/on_boreading/widgets/onboarding_widget.dart';

class OnboardingPageView extends StatelessWidget {
  final PageController controller;
  final List pages;
  final int currentPage;
  final Function(int) onPageChanged;
  final VoidCallback onGetStarted;

  const OnboardingPageView({
    super.key,
    required this.controller,
    required this.pages,
    required this.currentPage,
    required this.onPageChanged,
    required this.onGetStarted,
  });

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: controller,
      onPageChanged: onPageChanged,
      itemCount: pages.length,
      itemBuilder: (context, index) {
        return OnboardinWidget(
          page: pages[index],
          isLastPage: index == pages.length - 1,
          onGetStarted: onGetStarted,
          animationDelay: index * 200,
        );
      },
    );
  }
}

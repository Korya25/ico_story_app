// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class OnboardingBottomNavigation extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback? onNext;

  const OnboardingBottomNavigation({
    super.key,
    required this.currentPage,
    required this.totalPages,
    this.onNext,
  });

  bool get isLastPage => currentPage == totalPages - 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          _buildPageIndicator(),
          const SizedBox(height: 24),
          isLastPage ? const SizedBox.shrink() : _buildNextButton(context),
        ],
      ),
    );
  }

  Widget _buildPageIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        totalPages,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentPage == index ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentPage == index
                ? Colors.white
                : Colors.white.withOpacity(0.4),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onNext,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Theme.of(context).primaryColor,
        ),
        child: const Text("التالي"),
      ),
    );
  }
}

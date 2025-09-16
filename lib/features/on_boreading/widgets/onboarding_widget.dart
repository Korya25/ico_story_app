// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
import 'package:ico_story_app/features/on_boreading/model/onboarding_model.dart';

class OnboardinWidget extends StatelessWidget {
  final OnboardingModel page;
  final bool isLastPage;
  final VoidCallback? onGetStarted;
  final int animationDelay;

  const OnboardinWidget({
    super.key,
    required this.page,
    this.isLastPage = false,
    this.onGetStarted,
    this.animationDelay = 0,
  });

  @override
  Widget build(BuildContext context) {
    Widget iconOrImage;
    if (page.imagePath != null) {
      iconOrImage = Image.asset(page.imagePath!, height: 200, width: 200);
    } else if (page.iconData != null) {
      iconOrImage = Icon(page.iconData, size: 100, color: page.iconColor);
    } else {
      iconOrImage = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppAnimations.fadeInUp(
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: iconOrImage,
            ),
            delay: Duration(milliseconds: animationDelay),
          ),
          const SizedBox(height: 16),
          AppAnimations.fadeInUp(
            Text(
              page.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            delay: Duration(milliseconds: animationDelay + 100),
          ),
          const SizedBox(height: 12),
          AppAnimations.fadeInUp(
            Text(
              page.description,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
            ),
            delay: Duration(milliseconds: animationDelay + 200),
          ),
          const SizedBox(height: 48),
          if (isLastPage)
            AppAnimations.fadeInUp(
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onGetStarted,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: page.backgroundColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    "ابدأ الآن",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              delay: Duration(milliseconds: animationDelay + 300),
            ),
        ],
      ),
    );
  }
}

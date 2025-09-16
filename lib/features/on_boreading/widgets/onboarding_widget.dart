// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';
import 'package:ico_story_app/features/on_boreading/model/onboarding_model.dart';

class OnboardinWidget extends StatelessWidget {
  final OnboardingModel page;
  final int animationDelay;

  const OnboardinWidget({
    super.key,
    required this.page,
    this.animationDelay = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    Widget iconOrImage;

    if (page.imagePath != null) {
      iconOrImage = Image.asset(
        page.imagePath!,
        height: isTablet ? 280 : 180,
        width: isTablet ? 280 : 180,
      );
    } else if (page.iconData != null) {
      iconOrImage = Icon(
        page.iconData,
        size: isTablet ? 280 : 100,
        color: page.iconColor,
      );
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
            CustomText(
              page.title,
              color: AppColors.white,
              textAlign: TextAlign.center,
              mobileFontSize: 22,
              tabletFontSize: 38,
              fontWeight: FontWeight.bold,
            ),
            delay: Duration(milliseconds: animationDelay + 100),
          ),
          const SizedBox(height: 12),
          AppAnimations.fadeInUp(
            CustomText(
              page.description,
              color: Colors.white,
              textAlign: TextAlign.center,
              mobileFontSize: 18,
              tabletFontSize: 28,
              height: 1.5,
            ),
            delay: Duration(milliseconds: animationDelay + 200),
          ),
        ],
      ),
    );
  }
}

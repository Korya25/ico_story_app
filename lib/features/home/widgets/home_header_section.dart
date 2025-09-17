import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ico_story_app/core/constants/app_assets.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';
import 'package:ico_story_app/features/home/widgets/custom_card_bacground.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    return CustomCardBacground(
      child: Column(
        children: [
          AppAnimations.pulse(
            Image.asset(AppAssets.icoLogo, width: isTablet ? 200 : 100),
          ),
          Gap(isTablet ? 24 : 18),
          CustomText(
            '🌟 أهلاً وسهلاً بك في عالم القصص الرائع! 🌟',
            fontSize: isTablet ? 20 : 18,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
            textAlign: TextAlign.center,
          ),
          Gap(isTablet ? 16 : 8),
          CustomText(
            'اختر مجموعة القصص المفضلة لديك واستمتع بالمغامرة!',
            fontSize: isTablet ? 18 : 16,
            color: AppColors.white,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

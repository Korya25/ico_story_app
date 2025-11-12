import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';
import 'package:ico_story_app/features/home/widgets/common/custom_card_bacground.dart';

class HomeHeaderSection extends StatelessWidget {
  const HomeHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    return CustomCardBacground(
      child: Center(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              spacing: 20,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.cardBackground,
                  ),
                  padding: EdgeInsets.all(12),
                  child: Image.asset(
                    'assets/images/app/icologo.png',
                    width: isTablet ? 200 : 100,
                    height: 100,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.cardBackground,
                  ),
                  padding: EdgeInsets.all(12),
                  child: Image.asset(
                    'assets/images/app/directaid.png',
                    width: isTablet ? 220 : 100,
                    height: 100,
                  ),
                ),
              ],
            ),
            Gap(isTablet ? 24 : 18),
            CustomText(
              '🌟 أهلاً بك في عالم القصص 🌟',
              fontSize: isTablet ? 20 : 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
              textAlign: TextAlign.center,
            ),
            Gap(isTablet ? 16 : 8),
            CustomText(
              'اختر مجموعة القصص المفضلة لديك\n واستمتع بالمغامرة',
              fontSize: isTablet ? 18 : 16,
              color: AppColors.textPrimary,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w400,
            ),
          ],
        ),
      ),
    );
  }
}

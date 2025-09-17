import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';
import 'package:ico_story_app/features/home/widgets/common/custom_card_bacground.dart';

class HomeStoryCard extends StatelessWidget {
  const HomeStoryCard({
    super.key,
    required this.imagePath,
    required this.title,
    this.onTap,
  });
  final String imagePath;
  final String title;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // image card
          CustomCardBacground(
            borderRadius: 10000,
            padding: EdgeInsets.all(16),
            child: Image.asset(
              imagePath,
              height: isTablet ? 150 : 75,
              width: isTablet ? 150 : 75,
            ),
          ),
          Gap(8),

          // title
          CustomText(
            title,
            fontSize: isTablet ? 20 : 18,
            color: AppColors.white,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}

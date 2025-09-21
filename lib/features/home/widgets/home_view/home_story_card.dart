import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
          Image.asset(imagePath, width: isTablet ? 0.4.sh : 0.18.sh),
          Gap(8),

          // title
          CustomCardBacground(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            borderRadius: 8,
            child: CustomText(
              title,
              fontSize: isTablet ? 20 : 18,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

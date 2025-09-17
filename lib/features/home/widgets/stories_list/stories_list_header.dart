// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';
import 'package:ico_story_app/features/home/widgets/common/custom_card_bacground.dart';

class StoriesListHeader extends StatelessWidget {
  const StoriesListHeader({
    super.key,
    required this.categoryTitle,
    required this.storyCount,
  });
  final String categoryTitle;
  final int storyCount;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return Row(
      children: [
        // Back Button
        AppAnimations.slideInRight(
          GestureDetector(
            onTap: () {
              context.pop();
            },
            child: CustomCardBacground(
              borderRadius: 12,
              padding: EdgeInsets.all(isTablet ? 12 : 10),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: AppColors.white,
                size: isTablet ? 24 : 20,
              ),
            ),
          ),
          delay: Duration(milliseconds: 100),
        ),

        Gap(isTablet ? 20 : 16),

        // Category Info
        Expanded(
          child: AppAnimations.fadeInDown(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CustomText(
                      categoryTitle,
                      fontSize: isTablet ? 24 : 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ],
                ),
                Gap(isTablet ? 8 : 6),
                CustomText(
                  'عدد القصص : $storyCount',
                  fontSize: isTablet ? 16 : 14,
                  color: AppColors.white.withOpacity(0.9),
                ),
              ],
            ),
            delay: Duration(milliseconds: 200),
          ),
        ),
      ],
    );
  }
}

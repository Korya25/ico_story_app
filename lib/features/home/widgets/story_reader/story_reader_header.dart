// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
import 'package:ico_story_app/core/widgets/custom_back_button.dart';
import 'package:ico_story_app/core/widgets/custom_icon_cackground.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';

class StoryReaderHeader extends StatelessWidget {
  final String storyTitle;
  final int currentPage;
  final int totalPages;
  final VoidCallback onAudioToggle;

  const StoryReaderHeader({
    super.key,
    required this.storyTitle,
    required this.currentPage,
    required this.totalPages,
    required this.onAudioToggle,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return AppAnimations.slideInDown(
      Container(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Row(
          children: [
            // Big, Friendly Back Button
            CustomBackButton(),

            Gap(isTablet ? 16 : 12),

            // Story Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CustomText(
                    storyTitle,
                    fontSize: isTablet ? 22 : 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white,
                  ),
                  if (totalPages > 0) ...[
                    Gap(4),
                    CustomText(
                      'صفحة ${currentPage + 1} من $totalPages',
                      fontSize: isTablet ? 16 : 14,
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ],
                ],
              ),
            ),

            // Audio Status - Big and Clear
            CustomIconBackground(
              onTap: onAudioToggle,
              child: Icon(
                Icons.volume_up,
                color: AppColors.white,
                size: isTablet ? 28 : 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

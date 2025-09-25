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
  final VoidCallback onAudioToggle;

  const StoryReaderHeader({
    super.key,
    required this.storyTitle,
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
            AppAnimations.fadeInRight(
              delay: Duration(milliseconds: 250),
              CustomBackButton(),
            ),

            Gap(isTablet ? 16 : 12),

            // Story Info
            Expanded(
              child: AppAnimations.bounceInDown(
                delay: Duration(milliseconds: 350),

                Center(
                  child: CustomText(
                    storyTitle,
                    fontSize: isTablet ? 22 : 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),

            // Audio Status - Big and Clear
            Row(
              children: [
                CustomText(
                  "استمع إلى القصة",
                  fontSize: isTablet ? 14 : 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),

                Gap(isTablet ? 16 : 12),
                AppAnimations.fadeInLeft(
                  delay: Duration(milliseconds: 350),
                  CustomIconBackground(
                    onTap: onAudioToggle,
                    child: Icon(
                      Icons.volume_up,
                      color: AppColors.textPrimary,
                      size: isTablet ? 26 : 22,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

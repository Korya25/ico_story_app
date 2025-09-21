// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
import 'package:ico_story_app/core/widgets/custom_back_button.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';

class StoriesListHeader extends StatelessWidget {
  const StoriesListHeader({super.key, required this.categoryTitle});
  final String categoryTitle;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return Row(
      children: [
        // Back Button
        AppAnimations.slideInRight(
          CustomBackButton(),
          delay: Duration(milliseconds: 100),
        ),

        Gap(isTablet ? 20 : 16),

        // Category Info
        Expanded(
          child: AppAnimations.fadeInLeft(
            CustomText(
              categoryTitle,
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
            delay: Duration(milliseconds: 200),
          ),
        ),
      ],
    );
  }
}

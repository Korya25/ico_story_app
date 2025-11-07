// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';

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
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300, width: 2),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                imagePath,
                width: isTablet ? 250 : 0.18.sh,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Gap(12),

          // title
          CustomText(
            title,
            fontSize: isTablet ? 20 : 18.h,
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}

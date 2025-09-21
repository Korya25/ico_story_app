import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';
import 'package:ico_story_app/features/home/widgets/common/custom_card_bacground.dart';

class StoryListCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final void Function() onTap;

  const StoryListCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomCardBacground(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        borderRadius: 12,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(imagePath, fit: BoxFit.cover, width: double.infinity),

              const Gap(12),

              CustomText(
                title,
                fontSize: 18,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

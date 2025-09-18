import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/custom_icon_cackground.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return CustomIconBackground(
      onTap: () {
        context.pop();
      },
      child: Icon(
        Icons.arrow_back_ios_new,
        color: AppColors.white,
        size: isTablet ? 24 : 20,
      ),
    );
  }
}

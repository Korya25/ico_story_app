import 'package:flutter/material.dart';
import 'package:ico_story_app/core/constants/app_assets.dart';
import 'package:ico_story_app/core/style/app_colors.dart';

class OnboardingModel {
  final String title;
  final String description;
  final String? imagePath;
  final IconData? iconData;
  final Color backgroundColor;
  final Color iconColor;

  OnboardingModel({
    required this.title,
    required this.description,
    this.imagePath,
    this.iconData,
    required this.backgroundColor,
    required this.iconColor,
  });

  static final List<OnboardingModel> pages = [
    OnboardingModel(
      title: "إنجاز نفتخر به",
      description:
          "حائزة على جائزة خليفة للإبداع التربوي على مستوى الوطن العربي",
      imagePath: AppAssets.onboarding6,
      backgroundColor: AppColors.primary,
      iconColor: AppColors.accent,
    ),

    OnboardingModel(
      title: "تصفح القصص بسهولة",
      description: "اختر القصة المفضلة لديك وابدأ القراءة مباشرة",
      imagePath: AppAssets.onboarding2,
      backgroundColor: AppColors.secondary,
      iconColor: AppColors.white,
    ),
    OnboardingModel(
      title: "استمع إلى الأنشودة ",
      description: "بعد الانتهاء من كل قصة استمع إلى الأنشودة وتابع الكلمات",
      imagePath: AppAssets.onboarding3,
      backgroundColor: AppColors.accent,
      iconColor: AppColors.primary,
    ),
    OnboardingModel(
      title: "مرحبًا في ICO Stories",
      description: "استعد لمغامرة ممتعة مع القصص التعليمية و التربوية للأطفال",
      imagePath: AppAssets.onboarding1,
      backgroundColor: AppColors.primary,
      iconColor: AppColors.accent,
    ),
  ];
}

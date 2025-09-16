import 'package:flutter/material.dart';
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
      title: "مرحبًا في ICO Stories!",
      description: "استعد لمغامرة ممتعة مع القصص التعليمية للأطفال.",
      imagePath: 'assets/images/onboreading1.png',
      backgroundColor: AppColors.primary,
      iconColor: AppColors.accent,
    ),
    OnboardingModel(
      title: "تصفح القصص بسهولة",
      description: "اختر القصة المفضلة لديك وابدأ القراءة مباشرة.",
      imagePath: 'assets/images/onboreading2.png',
      backgroundColor: AppColors.secondary,
      iconColor: AppColors.white,
    ),
    OnboardingModel(
      title: "استمتع بالانشودة!",
      description: "بعد الانتهاء من كل قصة، استمع إلى الانشودة وتابع الكلمات.",
      imagePath: 'assets/images/onboreading3.png',
      backgroundColor: AppColors.accent,
      iconColor: AppColors.primary,
    ),
    OnboardingModel(
      title: "ابدأ المغامرة الآن!",
      description: "كل شيء جاهز! دعنا نبدأ رحلة التعلم والمرح معًا.",
      imagePath: 'assets/images/onboreading4.png',
      backgroundColor: AppColors.primary,
      iconColor: AppColors.accent,
    ),
  ];
}

// ignore_for_file: deprecated_member_use, avoid_print

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
import 'package:ico_story_app/features/home/widgets/home_view/home_header_section.dart';
import 'package:ico_story_app/features/home/widgets/home_view/social_button.dart';
import 'package:ico_story_app/features/home/widgets/home_view/stories_card_widget.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Gap(isTablet ? 10 : 40),
              // Header Section
              AppAnimations.bounceInDown(
                HomeHeaderSection(),
                delay: Duration(milliseconds: 600),
              ),
              Gap(isTablet ? 40 : 20),

              // Main story cards
              StoriesCardsWidget(),
              Gap(isTablet ? 40 : 20),

              // Social media
              SocialButton(),
              Gap(isTablet ? 10 : 10),
            ],
          ),
        ),
      ),
    );
  }
}

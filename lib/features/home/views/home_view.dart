import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/about_us_social_button.dart';
import 'package:ico_story_app/features/home/widgets/home_header.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // header
                HomeHeader(),
                Gap(isTablet ? 60 : 40),
                // body
                HomeViewBody(),

                // social row
                Gap(isTablet ? 120 : 60),

                AboutUsSocialButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

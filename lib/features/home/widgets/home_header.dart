import 'package:flutter/material.dart';
import 'package:ico_story_app/core/constants/app_assets.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //
        AppAnimations.elasticInDown(
          delay: Duration(milliseconds: 100),
          duration: Duration(seconds: 1),
          Image.asset(AppAssets.icoLogo, width: isTablet ? 200 : 100),
        ),
      ],
    );
  }
}

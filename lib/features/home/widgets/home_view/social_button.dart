import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ico_story_app/core/constants/app_assets.dart';
import 'package:ico_story_app/core/constants/app_constant.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';
import 'package:ico_story_app/core/widgets/social_media_row.dart';
import 'package:ico_story_app/features/home/widgets/common/custom_card_bacground.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppAnimations.bounceInUp(
      CustomCardBacground(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(
          child: Column(
            children: [
              CustomText(
                ' تابعونا للمزيد من المتعة ',
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                textAlign: TextAlign.center,
              ),
              Gap(24),
              SocialMediaRow(
                items: [
                  SocialMediaItem(
                    platform: AppConstant.twitter,
                    icon: AppAssets.x,
                    url: AppConstant.twitterLink,
                  ),
                  SocialMediaItem(
                    platform: AppConstant.insta,
                    icon: AppAssets.insta,
                    url: AppConstant.instaLink,
                  ),
                  SocialMediaItem(
                    platform: AppConstant.facebook,
                    icon: AppAssets.facebook,
                    url: AppConstant.facebookLink,
                  ),
                ],
                onTap: (platform) {
                  debugPrint("Clicked on $platform");
                },
              ),
            ],
          ),
        ),
      ),
      delay: Duration(milliseconds: 1500),
    );
  }
}

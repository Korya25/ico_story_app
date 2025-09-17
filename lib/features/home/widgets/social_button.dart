import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ico_story_app/core/constants/app_assets.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';
import 'package:ico_story_app/core/widgets/social_media_row.dart';
import 'package:ico_story_app/features/home/widgets/custom_card_bacground.dart';

class SocialButton extends StatelessWidget {
  const SocialButton({super.key});

  @override
  Widget build(BuildContext context) {
    return AppAnimations.bounceInUp(
      CustomCardBacground(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            CustomText(
              ' تابعونا للمزيد من المتعة ',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
              textAlign: TextAlign.center,
            ),
            Gap(24),
            SocialMediaRow(
              items: [
                SocialMediaItem(
                  platform: "twitter",
                  icon: AppAssets.x,
                  url: "https://twitter.com/ensan",
                ),
                SocialMediaItem(
                  platform: "insta",
                  icon: AppAssets.insta,
                  url: "https://instagram.com/ensan",
                ),
                SocialMediaItem(
                  platform: "facebook",
                  icon: AppAssets.facebook,
                  url: "https://facebook.com/ensan",
                ),
              ],
              onTap: (platform) {
                debugPrint("Clicked on $platform");
              },
            ),
          ],
        ),
      ),
      delay: Duration(milliseconds: 1200),
    );
  }
}

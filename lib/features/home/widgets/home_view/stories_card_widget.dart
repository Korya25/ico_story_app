// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ico_story_app/core/constants/app_assets.dart';
import 'package:ico_story_app/core/router/app_routes.dart';
import 'package:ico_story_app/features/home/widgets/home_view/home_story_card.dart';

class StoriesCardsWidget extends StatelessWidget {
  const StoriesCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 24,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            HomeStoryCard(
              onTap: () => context.pushNamed(
                AppRoutes.storiesList,
                extra: {'categoryTitle': 'قصص حروف', 'storyCount': 20},
              ),
              imagePath: AppAssets.icoLogo,
              title: 'قصص حروف',
            ),
            HomeStoryCard(
              imagePath: AppAssets.icoLogo,
              title: 'قصص سيرة',
              onTap: () => context.pushNamed(
                AppRoutes.storiesList,

                extra: {'categoryTitle': 'قصص سيرة', 'storyCount': 8},
              ),
            ),

            //
          ],
        ),
        HomeStoryCard(
          imagePath: AppAssets.icoLogo,
          title: 'كنوز المعرفة',
          onTap: () => context.pushNamed(
            AppRoutes.storiesList,
            extra: {'categoryTitle': 'كنوز المعرفة', 'storyCount': 11},
          ),
        ),
      ],
    );
  }
}

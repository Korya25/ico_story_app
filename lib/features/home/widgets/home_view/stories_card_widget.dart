// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ico_story_app/core/constants/app_assets.dart';
import 'package:ico_story_app/core/router/app_routes.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
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
            AppAnimations.bounceInRight(
              delay: Duration(milliseconds: 1000),
              HomeStoryCard(
                onTap: () => context.pushNamed(
                  AppRoutes.storiesList,
                  extra: {'categoryTitle': 'قصص حروف', 'storyCount': 20},
                ),
                imagePath: AppAssets.charsStories,
                title: 'قصص حروف',
              ),
            ),
            AppAnimations.bounceInLeft(
              delay: Duration(milliseconds: 1000),

              HomeStoryCard(
                imagePath: AppAssets.serahStories,
                title: 'قصص سيرة',
                onTap: () => context.pushNamed(
                  AppRoutes.storiesList,

                  extra: {'categoryTitle': 'قصص سيرة', 'storyCount': 8},
                ),
              ),
            ),

            //
          ],
        ),
        AppAnimations.bounceInUp(
          delay: Duration(milliseconds: 1300),

          HomeStoryCard(
            imagePath: AppAssets.knoozStories,
            title: 'كنوز المعرفة',
            onTap: () => context.pushNamed(
              AppRoutes.storiesList,
              extra: {'categoryTitle': 'كنوز القيم', 'storyCount': 11},
            ),
          ),
        ),
      ],
    );
  }
}

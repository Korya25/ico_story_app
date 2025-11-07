import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ico_story_app/core/constants/app_constant.dart';
import 'package:ico_story_app/core/router/app_routes.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
import 'package:ico_story_app/features/home/data/story_categories_list.dart';

import 'package:ico_story_app/features/home/widgets/home_view/home_story_card.dart';

class StoriesCardsWidget extends StatelessWidget {
  const StoriesCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List categories = StoryCategoriesList.categories;
    return Column(
      spacing: 24,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          spacing: 16,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: categories.take(2).toList().asMap().entries.map((entry) {
            final index = entry.key;
            final category = entry.value;

            return index == 0
                ? AppAnimations.bounceInRight(
                    HomeStoryCard(
                      imagePath: category.imagePath,
                      title: category.title,
                      onTap: () => context.pushNamed(
                        AppRoutes.storiesList,
                        extra: {AppConstant.categoryTitle: category.id},
                      ),
                    ),
                    delay: const Duration(milliseconds: 1000),
                  )
                : AppAnimations.bounceInLeft(
                    HomeStoryCard(
                      imagePath: category.imagePath,
                      title: category.title,
                      onTap: () => context.pushNamed(
                        AppRoutes.storiesList,
                        extra: {AppConstant.categoryTitle: category.id},
                      ),
                    ),
                    delay: const Duration(milliseconds: 1000),
                  );
          }).toList(),
        ),
        AppAnimations.bounceInUp(
          HomeStoryCard(
            imagePath: categories[2].imagePath,
            title: categories[2].title,
            onTap: () => context.pushNamed(
              AppRoutes.storiesList,
              extra: {AppConstant.categoryTitle: categories[2].id},
            ),
          ),
          delay: const Duration(milliseconds: 1300),
        ),
      ],
    );
  }
}

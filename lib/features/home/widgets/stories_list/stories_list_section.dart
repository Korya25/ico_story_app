import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ico_story_app/core/constants/app_assets.dart';
import 'package:ico_story_app/core/router/app_routes.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/features/home/models/story_list.dart';
import 'package:ico_story_app/features/home/widgets/stories_list/story_list_card.dart';

class StoriesListSection extends StatelessWidget {
  const StoriesListSection({super.key, required this.categoryTitle});

  final String categoryTitle;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    final stories = StoryList.getStoriesForCategory(categoryTitle);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 250,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: isTablet ? 250 : 220,
      ),

      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return StoryListCard(
          title: story.title,
          imagePath: AppAssets.icoLogo,
          onTap: () {
            context.pushNamed(AppRoutes.storyReader, extra: story);
          },
        );
      },
    );
  }
}

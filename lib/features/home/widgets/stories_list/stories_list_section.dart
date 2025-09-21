import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';
import 'package:ico_story_app/core/router/app_routes.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/features/home/data/story_list.dart';
import 'package:ico_story_app/features/home/widgets/stories_list/story_list_card.dart';

class StoriesListSection extends StatelessWidget {
  const StoriesListSection({super.key, required this.categoryTitle});

  final String categoryTitle;

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    final stories = StoryList.getStoriesForCategory(categoryTitle);

    return MasonryGridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isTablet ? 3 : 2, // عدد الأعمدة
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      itemCount: stories.length,
      itemBuilder: (context, index) {
        final story = stories[index];
        return StoryListCard(
          title: story.title,
          imagePath: story.coverImage,
          onTap: () {
            context.pushNamed(AppRoutes.storyReader, extra: story);
          },
        );
      },
    );
  }
}

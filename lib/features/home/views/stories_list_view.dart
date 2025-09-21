// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/utils/function.dart';
import 'package:ico_story_app/features/home/widgets/stories_list/stories_list_header.dart';
import 'package:ico_story_app/features/home/widgets/stories_list/stories_list_section.dart';

// ===== STORIES LIST SCREEN =====
class StoriesListView extends StatelessWidget {
  final String categoryTitle;

  const StoriesListView({super.key, required this.categoryTitle});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 16),
        child: CustomScrollView(
          slivers: [
            // Custom Header
            SliverToBoxAdapter(child: Gap(50)),

            SliverToBoxAdapter(
              child: StoriesListHeader(
                categoryTitle: returnTitle(categoryTitle),
                storyCount: 100000000000,
              ),
            ),

            SliverToBoxAdapter(
              child: StoriesListSection(categoryTitle: categoryTitle),
            ),
          ],
        ),
      ),
    );
  }
}

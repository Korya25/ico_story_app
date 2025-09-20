import 'package:flutter/material.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/widgets/background_container.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';
import 'package:ico_story_app/features/home/models/story_model.dart';
import 'package:ico_story_app/features/home/views/simple_story_reader_screen.dart';

class SimpleStoriesListScreen extends StatelessWidget {
  const SimpleStoriesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stories = StoryList.getStories();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: BackgroundContainer(
        color: AppColors.primary,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                child: const CustomText(
                  'قصصي الجميلة',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),

              // Stories List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: stories.length,
                  itemBuilder: (context, index) {
                    final story = stories[index];
                    return _buildStoryCard(context, story);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStoryCard(BuildContext context, StoryModel story) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SimpleStoryReaderScreen(story: story),
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Story Cover
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.book,
                  color: AppColors.primary,
                  size: 30,
                ),
              ),

              const SizedBox(width: 16),

              // Story Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      story.title,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(height: 4),
                    CustomText(
                      'اضغط للقراءة',
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
              ),

              // Arrow
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textSecondary,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// lib/core/theme/app_colors.dart
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';
import 'package:ico_story_app/core/style/app_colors.dart';

// lib/models/category.dart
class Category {
  final String id;
  final String title;
  final String icon;
  final Color backgroundColor;
  final Color iconColor;

  Category({
    required this.id,
    required this.title,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });
}

// lib/models/story.dart
class Story {
  final String id;
  final String title;
  final String thumbnail;
  final String categoryId;
  final String description;

  Story({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.categoryId,
    required this.description,
  });
}

class CategoryCard extends StatelessWidget {
  final Category category;
  final VoidCallback onTap;
  final int animationDelay;

  const CategoryCard({
    super.key,
    required this.category,
    required this.onTap,
    this.animationDelay = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return AppAnimations.fadeInUp(
      delay: Duration(milliseconds: animationDelay * 200),
      GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: isTablet ? 12.w : 8.w,
            vertical: isTablet ? 12.h : 8.h,
          ),
          decoration: BoxDecoration(
            color: category.backgroundColor,
            borderRadius: BorderRadius.circular(isTablet ? 24.r : 20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: isTablet ? 15 : 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Container(
            padding: EdgeInsets.all(isTablet ? 32.w : 24.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: isTablet ? 100.w : 80.w,
                  height: isTablet ? 100.h : 80.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(isTablet ? 20.r : 16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    _getIconData(category.icon),
                    size: isTablet ? 50.sp : 40.sp,
                    color: category.iconColor,
                  ),
                ),
                SizedBox(height: isTablet ? 24.h : 16.h),
                CustomText(
                  category.title,
                  fontSize: isTablet ? 18.sp : 16.sp,
                  tabletFontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'letters':
        return Icons.abc;
      case 'stories':
        return Icons.menu_book;
      case 'biography':
        return Icons.person_outline;
      default:
        return Icons.book;
    }
  }
}

class InstitutionHeader extends StatelessWidget {
  const InstitutionHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return AppAnimations.fadeInDown(
      Container(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 32.w : 24.w,
          vertical: isTablet ? 24.h : 16.h,
        ),
        child: Row(
          children: [
            AppAnimations.zoomIn(
              Container(
                width: isTablet ? 80.w : 60.w,
                height: isTablet ? 80.h : 60.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(isTablet ? 16.r : 12.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.school,
                  color: Colors.white,
                  size: isTablet ? 40.sp : 30.sp,
                ),
              ),
            ),
            SizedBox(width: isTablet ? 20.w : 16.w),
            Expanded(
              child: AppAnimations.fadeInLeft(
                delay: const Duration(milliseconds: 300),
                CustomText(
                  "نقرأ لنكبر معًا",
                  fontSize: isTablet ? 22.sp : 18.sp,
                  tabletFontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                  textAlign: TextAlign.start,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  List<Category> get _categories => [
    Category(
      id: 'letters',
      title: 'قصص حروف',
      icon: 'letters',
      backgroundColor: AppColors.accent,
      iconColor: AppColors.primary,
    ),
    Category(
      id: 'arabic_stories',
      title: 'قصص عربية',
      icon: 'stories',
      backgroundColor: AppColors.secondary,
      iconColor: AppColors.primary,
    ),
    Category(
      id: 'biography',
      title: 'قصص سيرة',
      icon: 'biography',
      backgroundColor: AppColors.primary,
      iconColor: Colors.white,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const InstitutionHeader(),
              SizedBox(height: isTablet ? 32.h : 24.h),

              // Welcome section
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32.w : 24.w,
                ),
                child: AppAnimations.fadeInUp(
                  delay: const Duration(milliseconds: 200),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        "مرحباً بك في",
                        fontSize: isTablet ? 18.sp : 16.sp,
                        tabletFontSize: 20.sp,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        "ICO Stories",
                        fontSize: isTablet ? 32.sp : 28.sp,
                        tabletFontSize: 36.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: isTablet ? 40.h : 32.h),

              // Categories title
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32.w : 24.w,
                ),
                child: AppAnimations.fadeInUp(
                  delay: const Duration(milliseconds: 400),
                  CustomText(
                    "اختر فئة القصص",
                    fontSize: isTablet ? 24.sp : 20.sp,
                    tabletFontSize: 26.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),

              SizedBox(height: isTablet ? 24.h : 20.h),

              // Categories grid
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 20.w : 16.w,
                ),
                child: isTablet ? _buildTabletLayout() : _buildMobileLayout(),
              ),

              SizedBox(height: isTablet ? 40.h : 32.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabletLayout() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        return CategoryCard(
          category: _categories[index],
          animationDelay: index,
          onTap: () => _navigateToCategory(context, _categories[index]),
        );
      },
    );
  }

  Widget _buildMobileLayout() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _categories.length,
      itemBuilder: (context, index) {
        return CategoryCard(
          category: _categories[index],
          animationDelay: index,
          onTap: () => _navigateToCategory(context, _categories[index]),
        );
      },
    );
  }

  void _navigateToCategory(BuildContext context, Category category) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            CategoryScreen(category: category),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  final Category category;

  const CategoryScreen({super.key, required this.category});

  List<Story> get _stories => [
    Story(
      id: '1',
      title: 'قصة الحرف أ',
      thumbnail: 'assets/images/story1.png',
      categoryId: category.id,
      description: 'قصة جميلة عن حرف الألف',
    ),
    Story(
      id: '2',
      title: 'قصة الحرف ب',
      thumbnail: 'assets/images/story2.png',
      categoryId: category.id,
      description: 'قصة ممتعة عن حرف الباء',
    ),
    Story(
      id: '3',
      title: 'قصة الحرف ت',
      thumbnail: 'assets/images/story3.png',
      categoryId: category.id,
      description: 'مغامرة مع حرف التاء',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: category.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: isTablet ? 28.sp : 24.sp,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: CustomText(
          category.title,
          fontSize: isTablet ? 22.sp : 20.sp,
          tabletFontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              category.backgroundColor,
              category.backgroundColor.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 24.w : 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppAnimations.fadeInUp(
                  CustomText(
                    "اختر قصة للقراءة",
                    fontSize: isTablet ? 20.sp : 18.sp,
                    tabletFontSize: 22.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: isTablet ? 24.h : 20.h),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isTablet ? 3 : 2,
                      childAspectRatio: 0.8,
                      crossAxisSpacing: isTablet ? 20 : 16,
                      mainAxisSpacing: isTablet ? 20 : 16,
                    ),
                    itemCount: _stories.length,
                    itemBuilder: (context, index) {
                      return StoryCard(
                        story: _stories[index],
                        animationDelay: index,
                        onTap: () => _openStory(_stories[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openStory(Story story) {
    // TODO: Navigate to story reading screen
    print('Opening story: ${story.title}');
  }
}

class StoryCard extends StatelessWidget {
  final Story story;
  final VoidCallback onTap;
  final int animationDelay;

  const StoryCard({
    super.key,
    required this.story,
    required this.onTap,
    this.animationDelay = 0,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return AppAnimations.fadeInUp(
      delay: Duration(milliseconds: animationDelay * 150),
      GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(isTablet ? 20.r : 16.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.2),
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(isTablet ? 20.r : 16.r),
                    ),
                  ),
                  child: Icon(
                    Icons.menu_book,
                    size: isTablet ? 60.sp : 50.sp,
                    color: AppColors.secondary,
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 16.w : 12.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomText(
                        story.title,
                        fontSize: isTablet ? 16.sp : 14.sp,
                        tabletFontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 4.h),
                      CustomText(
                        story.description,
                        fontSize: isTablet ? 12.sp : 10.sp,
                        tabletFontSize: 14.sp,
                        color: AppColors.textSecondary,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

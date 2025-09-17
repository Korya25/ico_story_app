// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:ico_story_app/core/style/app_colors.dart';

class Category {
  final String id;
  final String title;
  final Color backgroundColor;
  final String iconAsset;

  Category({
    required this.id,
    required this.title,
    required this.backgroundColor,
    required this.iconAsset,
  });
}

class Story {
  final String id;
  final String categoryId;
  final String title; // Arabic text
  final String thumbnailAsset; // placeholder asset path

  Story({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.thumbnailAsset,
  });
}

class CategoryCard extends StatelessWidget {
  final String title;
  final String iconAsset;
  final Color backgroundColor;
  final VoidCallback onTap;

  const CategoryCard({
    super.key,
    required this.title,
    required this.iconAsset,
    required this.backgroundColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Responsive height for tablet vs phone
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final cardHeight = isTablet ? 180.0 : 140.0;

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: Container(
          height: cardHeight,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: backgroundColor.withOpacity(0.6),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: isTablet ? 80 : 64,
                child: Image.asset(iconAsset, fit: BoxFit.contain),
              ),
              const SizedBox(height: 14),
              Text(
                title,
                style: TextStyle(
                  fontSize: isTablet ? 26 : 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Cairo',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryScreen extends StatelessWidget {
  final Category category;
  final List<Story> stories;

  const CategoryScreen({
    super.key,
    required this.category,
    required this.stories,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final crossAxisCount = isTablet ? 3 : 2;
    final childAspectRatio = isTablet ? 3 / 4 : 3 / 4;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: category.backgroundColor,
          title: Text(
            category.title,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
          centerTitle: true,
          toolbarHeight: isTablet ? 80 : kToolbarHeight,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            itemCount: stories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              final story = stories[index];
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                elevation: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(24),
                        ),
                        child: Image.asset(
                          story.thumbnailAsset,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        story.title,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 22 : 18,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  // Placeholder categories
  final List<Category> categories = [
    Category(
      id: 'letters',
      title: 'قصص حروف',
      backgroundColor: AppColors.accent,
      iconAsset: 'assets/images/onboreading1.png',
    ),
    Category(
      id: 'arabic',
      title: 'قصص عربية',
      backgroundColor: AppColors.secondary,
      iconAsset: 'assets/images/onboreading1.png',
    ),
    Category(
      id: 'biography',
      title: 'قصص سيرة',
      backgroundColor: AppColors.primary,
      iconAsset: 'assets/images/onboreading1.png',
    ),
  ];

  // Placeholder stories per category
  final Map<String, List<Story>> storiesByCategory = {
    'letters': [
      Story(
        id: 'l1',
        categoryId: 'letters',
        title: 'قصة حرف الألف',
        thumbnailAsset: 'assets/images/onboreading1.png',
      ),
      Story(
        id: 'l2',
        categoryId: 'letters',
        title: 'قصة حرف الباء',
        thumbnailAsset: 'assets/images/onboreading1.png',
      ),
    ],
    'arabic': [
      Story(
        id: 'a1',
        categoryId: 'arabic',
        title: 'قصة الأسد',
        thumbnailAsset: 'assets/images/onboreading1.png',
      ),
      Story(
        id: 'a2',
        categoryId: 'arabic',
        title: 'قصة النحلة',
        thumbnailAsset: 'assets/images/onboreading1.png',
      ),
    ],
    'biography': [
      Story(
        id: 'b1',
        categoryId: 'biography',
        title: 'سيرة عمر بن الخطاب',
        thumbnailAsset: 'assets/images/onboreading1.png',
      ),
      Story(
        id: 'b2',
        categoryId: 'biography',
        title: 'سيرة خالد بن الوليد',
        thumbnailAsset: 'assets/images/onboreading1.png',
      ),
    ],
  };

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.shortestSide >= 600;
    final logoSize = isTablet ? 120.0 : 80.0;
    final sloganFontSize = isTablet ? 36.0 : 28.0;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isTablet ? 32 : 16,
            vertical: isTablet ? 24 : 12,
          ),
          child: Column(
            children: [
              // Top Section: Logo + Slogan
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/onboreading1.png',
                    width: logoSize,
                    height: logoSize,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(width: isTablet ? 24 : 12),
                  Expanded(
                    child: Text(
                      'نقرأ لنكبر معًا',
                      style: TextStyle(
                        fontSize: sloganFontSize,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        fontFamily: 'Cairo',
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                ],
              ),
              SizedBox(height: isTablet ? 36 : 24),

              // Categories Section
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: categories.map((category) {
                    return CategoryCard(
                      title: category.title,
                      iconAsset: category.iconAsset,
                      backgroundColor: category.backgroundColor,
                      onTap: () {
                        final stories = storiesByCategory[category.id] ?? [];
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => CategoryScreen(
                              category: category,
                              stories: stories,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

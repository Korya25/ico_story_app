// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:ico_story_app/core/constants/app_assets.dart';
import 'package:ico_story_app/core/style/app_colors.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';
import 'package:ico_story_app/core/widgets/animate_do.dart';
import 'package:ico_story_app/core/widgets/custom_text.dart';

class StoriesCardsWidget extends StatelessWidget {
  const StoriesCardsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    final cardSize = isTablet ? 140.0 : 100.0;
    final iconSize = isTablet ? 50.0 : 35.0;

    final card1 = _StoryCardData(
      title: 'قصص سيرة',
      subtitle: '12 قصة رائعة',
      emoji: '👤',
      color: AppColors.secondary,
      icon: Icons.person_outline,
      delay: 200,
    );

    final card2 = _StoryCardData(
      title: 'كنوز القيم',
      subtitle: '15 كنز ثمين',
      emoji: '💎',
      color: AppColors.primary,
      icon: Icons.diamond_outlined,
      delay: 400,
    );

    final card3 = _StoryCardData(
      title: 'قصص حروف',
      subtitle: '28 حرف ممتع',
      emoji: '📚',
      color: AppColors.accent,
      icon: Icons.abc_outlined,
      delay: 600,
    );

    return Column(
      children: [
        // First row with 2 cards
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppAnimations.bounceIn(
              _buildEnhancedCircularCard(
                context: context,
                data: card1,
                cardSize: cardSize,
                iconSize: iconSize,
              ),
              delay: Duration(milliseconds: card1.delay),
            ),
            SizedBox(width: isTablet ? 20 : 16),
            AppAnimations.bounceIn(
              _buildEnhancedCircularCard(
                context: context,
                data: card2,
                cardSize: cardSize,
                iconSize: iconSize,
              ),
              delay: Duration(milliseconds: card2.delay),
            ),
          ],
        ),

        SizedBox(height: isTablet ? 20 : 12),

        // Second row with 1 card centered
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppAnimations.bounceIn(
              _buildEnhancedCircularCard(
                context: context,
                data: card3,
                cardSize: cardSize,
                iconSize: iconSize,
              ),
              delay: Duration(milliseconds: card3.delay),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEnhancedCircularCard({
    required BuildContext context,
    required _StoryCardData data,
    required double cardSize,
    required double iconSize,
  }) {
    final isTablet = context.isTablet;

    return GestureDetector(
      onTap: () {
        print('${data.title} tapped');
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppAnimations.pulse(
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [AppColors.white, data.color.withOpacity(0.05)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: data.color.withOpacity(0.3),
                    spreadRadius: 3,
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 1,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
                border: Border.all(
                  color: data.color.withOpacity(0.3),
                  width: 3,
                ),
              ),
              padding: EdgeInsets.all(16),
              child: Image.asset(AppAssets.icoLogo, height: 100),
            ),
            infinite: false,
          ),
          SizedBox(height: isTablet ? 16 : 12),
          AppAnimations.slideInUp(
            CustomText(
              data.title,
              fontSize: isTablet ? 16 : 13,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
              textAlign: TextAlign.center,
            ),
            delay: Duration(milliseconds: 500),
          ),
          SizedBox(height: isTablet ? 6 : 4),
          AppAnimations.fadeIn(
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 12 : 8,
                vertical: isTablet ? 6 : 4,
              ),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.white.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: CustomText(
                data.subtitle,
                fontSize: isTablet ? 12 : 11,
                fontWeight: FontWeight.w600,
                color: data.color,
                textAlign: TextAlign.center,
              ),
            ),
            delay: Duration(milliseconds: 700),
          ),
        ],
      ),
    );
  }
}

// ===== DATA CLASS =====
class _StoryCardData {
  final String title;
  final String subtitle;
  final String emoji;
  final Color color;
  final IconData icon;
  final int delay;

  _StoryCardData({
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.color,
    required this.icon,
    required this.delay,
  });
}

// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:ico_story_app/core/style/app_colors.dart';

class CustomCardBacground extends StatelessWidget {
  const CustomCardBacground({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.height,
    this.width,
  });
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final double? height;
  final double? width;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      padding: padding ?? EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.white.withOpacity(0.15),
            AppColors.secondary.withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? 20),
        border: Border.all(color: AppColors.white.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }
}

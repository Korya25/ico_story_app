import 'package:flutter/material.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double mobileFontSize;
  final double tabletFontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;
  final double? height;

  const CustomText(
    this.text, {
    super.key,
    required this.mobileFontSize,
    required this.tabletFontSize,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.textAlign = TextAlign.start,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: isTablet ? tabletFontSize : mobileFontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
      ),
    );
  }
}

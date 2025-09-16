import 'package:flutter/material.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';

class CustomText extends StatelessWidget {
  final String text;
  final double fontSize;
  final double? tabletFontSize;
  final FontWeight fontWeight;
  final Color color;
  final TextAlign textAlign;

  const CustomText(
    this.text, {
    super.key,
    required this.fontSize,
    this.tabletFontSize,
    this.fontWeight = FontWeight.normal,
    this.color = Colors.black,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;
    final effectiveFontSize = isTablet
        ? (tabletFontSize ?? fontSize * 1.6)
        : fontSize;

    return Text(
      text,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: effectiveFontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}

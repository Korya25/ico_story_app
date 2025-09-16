import 'package:flutter/material.dart';
import 'package:ico_story_app/core/utils/context_extension.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final FontWeight fontWeight;
  final double mobileFontSize;
  final double tabletFontSize;
  final double? width;
  final double? height;
  final AlignmentGeometry alignment;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor = Colors.white,
    this.foregroundColor = Colors.black,
    this.fontWeight = FontWeight.bold,
    this.mobileFontSize = 16,
    this.tabletFontSize = 22,
    this.width,
    this.height,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final isTablet = context.isTablet;

    return Align(
      alignment: alignment,
      child: SizedBox(
        width: width ?? (isTablet ? 600 : double.infinity),
        height: height ?? (isTablet ? 60 : 48),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            text,
            style: TextStyle(
              fontSize: isTablet ? tabletFontSize : mobileFontSize,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}

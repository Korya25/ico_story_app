// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  final Color color;
  final Widget child;

  const BackgroundContainer({
    super.key,
    required this.color,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color, color.withOpacity(0.8)],
        ),
      ),
      child: SafeArea(child: child),
    );
  }
}

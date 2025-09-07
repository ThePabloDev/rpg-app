import 'package:flutter/material.dart';

class RPGBackground extends StatelessWidget {
  final Widget child;
  final String? backgroundImage;
  final Color overlayColor;
  final double overlayOpacity;
  final Color? backgroundColor;

  const RPGBackground({
    super.key,
    required this.child,
    this.backgroundImage = "assets/images/mclass.png",
    this.overlayColor = Colors.black,
    this.overlayOpacity = 0.7,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            image: backgroundImage != null
                ? DecorationImage(
                    image: AssetImage(backgroundImage!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
        ),
        // Overlay
        Container(
          color: overlayColor.withValues(alpha: overlayOpacity),
        ),
        // Content
        child,
      ],
    );
  }
}

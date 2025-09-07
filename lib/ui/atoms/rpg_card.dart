import 'package:flutter/material.dart';

class RPGCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final double borderRadius;
  final bool withBorder;
  final Color borderColor;
  final double borderWidth;
  final bool withShadow;

  const RPGCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderRadius = 20,
    this.withBorder = true,
    this.borderColor = Colors.amber,
    this.borderWidth = 2,
    this.withShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.black.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(borderRadius),
        border: withBorder ? Border.all(color: borderColor, width: borderWidth) : null,
        boxShadow: withShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: child,
    );
  }
}

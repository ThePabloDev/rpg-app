import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum RPGTextStyle {
  title,
  subtitle,
  body,
  caption,
  button,
}

class RPGText extends StatelessWidget {
  final String text;
  final RPGTextStyle style;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool withShadow;

  const RPGText(
    this.text, {
    super.key,
    required this.style,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.withShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle;
    
    switch (style) {
      case RPGTextStyle.title:
        textStyle = GoogleFonts.cinzel(
          textStyle: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color ?? Colors.amber,
          ),
        );
        break;
      case RPGTextStyle.subtitle:
        textStyle = GoogleFonts.cinzel(
          textStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: color ?? Colors.amber,
          ),
        );
        break;
      case RPGTextStyle.body:
        textStyle = TextStyle(
          fontSize: 16,
          color: color ?? Colors.white,
        );
        break;
      case RPGTextStyle.caption:
        textStyle = TextStyle(
          fontSize: 14,
          color: color ?? Colors.white70,
        );
        break;
      case RPGTextStyle.button:
        textStyle = TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: color ?? Colors.black,
        );
        break;
    }

    if (withShadow) {
      textStyle = textStyle.copyWith(
        shadows: const [
          Shadow(
            blurRadius: 10,
            color: Colors.black,
            offset: Offset(2, 2),
          ),
        ],
      );
    }

    return Text(
      text,
      style: textStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}

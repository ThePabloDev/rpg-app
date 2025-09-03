import 'package:flutter/material.dart';
import 'app_colors.dart';

class TextAtom extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final String? semanticsLabel;
  final int? maxLines;
  final TextOverflow? overflow;

  const TextAtom(
    this.text, {
    Key? key,
    this.style,
    this.semanticsLabel,
    this.maxLines,
    this.overflow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel ?? text,
      child: Text(
        text,
        maxLines: maxLines,
        overflow: overflow,
        style: style ??
            const TextStyle(
              color: AppColors.textHigh,
              fontSize: 16,
            ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../atoms/rpg_button.dart';

class RPGActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final RPGButtonType type;
  final bool isLoading;
  final double? width;
  final IconData? icon;
  final String? semanticLabel;

  const RPGActionButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = RPGButtonType.primary,
    this.isLoading = false,
    this.width,
    this.icon,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: semanticLabel ?? 'Botão $text',
      child: RPGButton(
        text: text,
        onPressed: onPressed,
        type: type,
        isLoading: isLoading,
        width: width ?? double.infinity,
        icon: icon,
      ),
    );
  }
}

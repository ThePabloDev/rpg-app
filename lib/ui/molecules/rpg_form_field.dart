import 'package:flutter/material.dart';
import '../atoms/rpg_text_field.dart';

class RPGFormField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final Function(String)? onChanged;
  final int? maxLines;
  final String? initialValue;
  final String? semanticLabel;

  const RPGFormField({
    super.key,
    required this.label,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.maxLines = 1,
    this.initialValue,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          container: true,
          label: semanticLabel ?? 'Campo de $label',
          textField: true,
          child: RPGTextField(
            labelText: label,
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            obscureText: obscureText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            readOnly: readOnly,
            onTap: onTap,
            onChanged: onChanged,
            maxLines: maxLines,
            initialValue: initialValue,
          ),
        ),
      ],
    );
  }
}

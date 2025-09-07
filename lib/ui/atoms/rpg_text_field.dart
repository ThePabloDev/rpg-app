import 'package:flutter/material.dart';

class RPGTextField extends StatefulWidget {
  final String? labelText;
  final String? hintText;
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

  const RPGTextField({
    super.key,
    this.labelText,
    this.hintText,
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
  });

  @override
  State<RPGTextField> createState() => _RPGTextFieldState();
}

class _RPGTextFieldState extends State<RPGTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      initialValue: widget.initialValue,
      keyboardType: widget.keyboardType,
      obscureText: _obscureText,
      readOnly: widget.readOnly,
      onTap: widget.onTap,
      onChanged: widget.onChanged,
      maxLines: _obscureText ? 1 : widget.maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: widget.labelText,
        hintText: widget.hintText,
        labelStyle: const TextStyle(color: Colors.amber),
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: widget.prefixIcon != null
            ? Icon(widget.prefixIcon, color: Colors.amber)
            : null,
        suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  color: Colors.amber,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : widget.suffixIcon,
        filled: true,
        fillColor: Colors.grey[900],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.amber),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.amber),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.amber, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: widget.validator,
    );
  }
}

import 'package:flutter/material.dart';

class RPGDropdown<T> extends StatelessWidget {
  final String? labelText;
  final String? hintText;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const RPGDropdown({
    super.key,
    this.labelText,
    this.hintText,
    this.value,
    required this.items,
    required this.itemLabel,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        labelStyle: const TextStyle(color: Colors.amber),
        hintStyle: TextStyle(color: Colors.grey[400]),
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
      dropdownColor: Colors.grey[900],
      style: const TextStyle(color: Colors.white),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.amber),
      items: items
          .map((item) => DropdownMenuItem<T>(
                value: item,
                child: Text(
                  itemLabel(item),
                  style: const TextStyle(color: Colors.white),
                ),
              ))
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}

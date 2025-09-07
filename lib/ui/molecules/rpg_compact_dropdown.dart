import 'package:flutter/material.dart';

class RPGCompactDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final void Function(T?)? onChanged;
  final String? Function(T?)? validator;

  const RPGCompactDropdown({
    super.key,
    required this.label,
    this.value,
    required this.items,
    required this.itemLabel,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      constraints: const BoxConstraints(maxWidth: 180),
      child: DropdownButtonFormField<T>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.amber.withValues(alpha: 0.8),
            fontSize: 14,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          filled: true,
          fillColor: Colors.grey[900]?.withValues(alpha: 0.5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.amber.withValues(alpha: 0.3)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.amber.withValues(alpha: 0.3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.amber, width: 2),
          ),
        ),
        dropdownColor: Colors.grey[900],
        style: const TextStyle(color: Colors.white, fontSize: 14),
        icon: const Icon(Icons.expand_more, color: Colors.amber, size: 20),
        items: items
            .map((item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    itemLabel(item),
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    overflow: TextOverflow.ellipsis,
                  ),
                ))
            .toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}

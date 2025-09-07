import 'package:flutter/material.dart';
import '../atoms/rpg_text.dart';

class RPGAttributeSlider extends StatefulWidget {
  final String attribute;
  final int value;
  final int minValue;
  final int maxValue;
  final void Function(int) onChanged;

  const RPGAttributeSlider({
    super.key,
    required this.attribute,
    required this.value,
    this.minValue = 8,
    this.maxValue = 18,
    required this.onChanged,
  });

  @override
  State<RPGAttributeSlider> createState() => _RPGAttributeSliderState();
}

class _RPGAttributeSliderState extends State<RPGAttributeSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber, width: 1),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: RPGText(
              widget.attribute,
              style: RPGTextStyle.body,
              color: Colors.amber,
            ),
          ),
          Expanded(
            flex: 3,
            child: Slider(
              value: widget.value.toDouble(),
              min: widget.minValue.toDouble(),
              max: widget.maxValue.toDouble(),
              divisions: widget.maxValue - widget.minValue,
              activeColor: Colors.amber,
              inactiveColor: Colors.grey[600],
              onChanged: (value) {
                widget.onChanged(value.round());
              },
            ),
          ),
          Container(
            width: 40,
            height: 30,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: RPGText(
                widget.value.toString(),
                style: RPGTextStyle.body,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

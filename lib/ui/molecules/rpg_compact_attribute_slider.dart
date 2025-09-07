import 'package:flutter/material.dart';
import '../atoms/rpg_text.dart';

class RPGCompactAttributeSlider extends StatelessWidget {
  final String attribute;
  final int value;
  final int minValue;
  final int maxValue;
  final void Function(int) onChanged;

  const RPGCompactAttributeSlider({
    super.key,
    required this.attribute,
    required this.value,
    this.minValue = 8,
    this.maxValue = 18,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: RPGText(
              attribute,
              style: RPGTextStyle.body,
              color: Colors.amber,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: Colors.amber,
                inactiveTrackColor: Colors.amber.withValues(alpha: 0.3),
                thumbColor: Colors.amber,
                overlayColor: Colors.amber.withValues(alpha: 0.2),
                trackHeight: 4,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
              ),
              child: Slider(
                value: value.toDouble(),
                min: minValue.toDouble(),
                max: maxValue.toDouble(),
                divisions: maxValue - minValue,
                onChanged: (value) {
                  onChanged(value.round());
                },
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.amber.withValues(alpha: 0.3),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: RPGText(
                value.toString(),
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

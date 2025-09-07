import 'package:flutter/material.dart';
import '../atoms/rpg_text.dart';

class RPGSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color? iconColor;

  const RPGSectionHeader({
    super.key,
    required this.title,
    required this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: iconColor ?? Colors.amber,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RPGText(
                  title,
                  style: RPGTextStyle.subtitle,
                ),
                Container(
                  height: 2,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(1),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

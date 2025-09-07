import 'package:flutter/material.dart';
import '../atoms/rpg_text.dart';
import '../atoms/rpg_card.dart';
import '../../models/magia.dart';

class MagiaCard extends StatelessWidget {
  final Magia magia;
  final VoidCallback? onTap;

  const MagiaCard({
    super.key,
    required this.magia,
    this.onTap,
  });

  Color _getSchoolColor(String school) {
    switch (school.toLowerCase()) {
      case 'abjuration':
      case 'abjuração':
        return Colors.blue;
      case 'conjuration':
      case 'conjuração':
        return Colors.green;
      case 'divination':
      case 'adivinhação':
        return Colors.purple;
      case 'enchantment':
      case 'encantamento':
        return Colors.pink;
      case 'evocation':
      case 'evocação':
        return Colors.red;
      case 'illusion':
      case 'ilusão':
        return Colors.indigo;
      case 'necromancy':
      case 'necromancia':
        return Colors.grey;
      case 'transmutation':
      case 'transmutação':
        return Colors.orange;
      default:
        return Colors.amber;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RPGCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: RPGText(
                      magia.name,
                      style: RPGTextStyle.subtitle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getSchoolColor(magia.school),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: RPGText(
                      magia.level,
                      style: RPGTextStyle.caption,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              RPGText(
                magia.school,
                style: RPGTextStyle.caption,
                color: _getSchoolColor(magia.school),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoRow(Icons.access_time, magia.castingTime),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoRow(Icons.my_location, magia.range),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              RPGText(
                magia.description,
                style: RPGTextStyle.caption,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.amber.withValues(alpha: 0.7)),
        const SizedBox(width: 4),
        Expanded(
          child: RPGText(
            text,
            style: RPGTextStyle.caption,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

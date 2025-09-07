import 'package:flutter/material.dart';
import '../atoms/rpg_text.dart';
import '../atoms/rpg_card.dart';
import '../atoms/rpg_button.dart';
import '../../models/magia.dart';

class MagiaDetailCard extends StatelessWidget {
  final Magia magia;
  final VoidCallback? onClose;

  const MagiaDetailCard({
    super.key,
    required this.magia,
    this.onClose,
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
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.amber),
          onPressed: onClose ?? () => Navigator.of(context).pop(),
        ),
        title: RPGText(
          magia.name,
          style: RPGTextStyle.subtitle,
          color: Colors.amber,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: RPGCard(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header com nome e nível
                Row(
                  children: [
                    Expanded(
                      child: RPGText(
                        magia.name,
                        style: RPGTextStyle.title,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: _getSchoolColor(magia.school),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: RPGText(
                        magia.level,
                        style: RPGTextStyle.body,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Escola
                _buildDetailRow('Escola', magia.school, _getSchoolColor(magia.school)),
                const SizedBox(height: 12),

                // Tempo de conjuração
                _buildDetailRow('Tempo de Conjuração', magia.castingTime),
                const SizedBox(height: 12),

                // Alcance
                _buildDetailRow('Alcance', magia.range),
                const SizedBox(height: 12),

                // Componentes
                _buildDetailRow('Componentes', magia.components),
                const SizedBox(height: 12),

                // Duração
                _buildDetailRow('Duração', magia.duration),
                const SizedBox(height: 12),

                // Ritual e Concentração (se aplicável)
                if (magia.ritual != null || magia.concentration != null) ...[
                  Row(
                    children: [
                      if (magia.ritual == 'yes' || magia.ritual == 'sim')
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.purple.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.purple),
                          ),
                          child: const RPGText('Ritual', style: RPGTextStyle.caption),
                        ),
                      const SizedBox(width: 8),
                      if (magia.concentration == 'yes' || magia.concentration == 'sim')
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.orange.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: const RPGText('Concentração', style: RPGTextStyle.caption),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Descrição
                const RPGText('Descrição', style: RPGTextStyle.subtitle),
                const SizedBox(height: 8),
                RPGText(
                  magia.description,
                  style: RPGTextStyle.body,
                ),

                // Níveis superiores (se aplicável)
                if (magia.higherLevel != null && magia.higherLevel!.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  const RPGText('Em Níveis Superiores', style: RPGTextStyle.subtitle),
                  const SizedBox(height: 8),
                  RPGText(
                    magia.higherLevel!,
                    style: RPGTextStyle.body,
                  ),
                ],

                const SizedBox(height: 24),
                
                // Botão de fechar
                Center(
                  child: RPGButton(
                    text: 'Fechar',
                    type: RPGButtonType.secondary,
                    onPressed: onClose ?? () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, [Color? valueColor]) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RPGText(label, style: RPGTextStyle.subtitle),
        const SizedBox(height: 4),
        RPGText(
          value,
          style: RPGTextStyle.body,
          color: valueColor,
        ),
      ],
    );
  }
}

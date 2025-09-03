import 'package:flutter/material.dart';
import 'character_card.dart';

class CharacterListItem extends StatelessWidget {
  final String name;
  final String subtitle;

  const CharacterListItem({Key? key, required this.name, required this.subtitle}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CharacterCard(
      name: name,
      subtitle: subtitle,
      onTap: () {
        // ...existing code...
        // Exemplo de ação: abrir detalhes (integre conforme seu roteamento)
      },
      onAction: () {
        // ...existing code...
      },
    );
  }
}
import 'package:flutter/material.dart';
import '../ui/screens/templates/app_template.dart';
import '../ui/organisms/character_creation_form_organism.dart';

class TelaCriacaoPersonagem extends StatelessWidget {
  const TelaCriacaoPersonagem({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTemplate(
      title: 'Criar Personagem',
      body: CharacterCreationFormOrganism(
        onCreateCharacter: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Personagem criado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        },
      ),
    );
  }
}

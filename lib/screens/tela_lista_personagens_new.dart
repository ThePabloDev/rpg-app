import 'package:flutter/material.dart';
import '../ui/screens/templates/app_template.dart';
import '../ui/atoms/rpg_text.dart';

class TelaListaPersonagens extends StatelessWidget {
  const TelaListaPersonagens({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppTemplate(
      title: 'Meus Personagens',
      body: Center(
        child: RPGText(
          'Nenhum personagem criado ainda.',
          style: RPGTextStyle.body,
        ),
      ),
    );
  }
}

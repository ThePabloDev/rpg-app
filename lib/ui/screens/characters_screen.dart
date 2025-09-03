import 'package:flutter/material.dart';
import '../atoms/app_colors.dart';
import '../molecules/character_list_item.dart';

class CharactersScreen extends StatelessWidget {
  const CharactersScreen({Key? key}) : super(key: key);

  // Exemplo de dados; substitua pelos seus modelos
  List<Map<String, String>> get sample => [
        {'name': 'Aldric', 'subtitle': 'Guerreiro - Nível 5'},
        {'name': 'Mira', 'subtitle': 'Maga - Nível 4'},
        {'name': 'Thorn', 'subtitle': 'Arqueiro - Nível 6'},
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: const Text('Personagens', style: TextStyle(color: AppColors.textHigh)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textHigh),
      ),
      body: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 12),
          itemCount: sample.length,
          itemBuilder: (context, index) {
            final item = sample[index];
            return CharacterListItem(name: item['name']!, subtitle: item['subtitle']!);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // ...existing code...
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
        tooltip: 'Adicionar personagem',
      ),
    );
  }
}
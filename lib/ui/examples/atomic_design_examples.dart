import 'package:flutter/material.dart';
import '../ui_components.dart';

/// Exemplo de como usar os componentes do Atomic Design
/// 
/// Este arquivo demonstra o uso de cada nível da arquitetura:
/// - Átomos
/// - Moléculas  
/// - Organismos
/// - Templates
class ExemplosAtomicDesign extends StatelessWidget {
  const ExemplosAtomicDesign({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTemplate(
      title: 'Exemplos Atomic Design',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // EXEMPLOS DE ÁTOMOS
            _buildSectionTitle('🔬 ÁTOMOS'),
            
            // RPGText
            const RPGText(
              'Texto de Título RPG',
              style: RPGTextStyle.title,
            ),
            const SizedBox(height: 8),
            
            const RPGText(
              'Texto do corpo da aplicação',
              style: RPGTextStyle.body,
            ),
            const SizedBox(height: 16),
            
            // RPGButton
            RPGButton(
              text: 'Botão Primário',
              onPressed: () {},
            ),
            const SizedBox(height: 8),
            
            RPGButton(
              text: 'Botão Secundário',
              type: RPGButtonType.secondary,
              onPressed: () {},
            ),
            const SizedBox(height: 8),
            
            RPGButton(
              text: 'Botão Outlined',
              type: RPGButtonType.outlined,
              onPressed: () {},
            ),
            const SizedBox(height: 16),
            
            // RPGTextField
            const RPGTextField(
              labelText: 'Campo de Texto',
              prefixIcon: Icons.email,
            ),
            const SizedBox(height: 16),
            
            // RPGDropdown
            RPGDropdown<String>(
              labelText: 'Seleção',
              items: const ['Opção 1', 'Opção 2', 'Opção 3'],
              itemLabel: (item) => item,
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            
            // RPGCard
            const RPGCard(
              child: Column(
                children: [
                  RPGText(
                    'Conteúdo do Card',
                    style: RPGTextStyle.subtitle,
                  ),
                  SizedBox(height: 8),
                  RPGText(
                    'Este é um exemplo de card RPG',
                    style: RPGTextStyle.body,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // EXEMPLOS DE MOLÉCULAS
            _buildSectionTitle('🧪 MOLÉCULAS'),
            
            // RPGFormField
            RPGFormField(
              label: 'Campo de Formulário',
              prefixIcon: Icons.person,
              validator: (value) => 
                value?.isEmpty == true ? 'Campo obrigatório' : null,
            ),
            const SizedBox(height: 16),
            
            // RPGActionButton
            RPGActionButton(
              text: 'Botão de Ação',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Botão pressionado!')),
                );
              },
              icon: Icons.send,
            ),
            const SizedBox(height: 16),
            
            // RPGAttributeSlider
            RPGAttributeSlider(
              attribute: 'Força',
              value: 12,
              onChanged: (value) {},
            ),
            const SizedBox(height: 24),
            
            // EXPLICAÇÃO DOS ORGANISMOS
            _buildSectionTitle('🦠 ORGANISMOS'),
            
            const RPGCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RPGText(
                    'Organismos Disponíveis:',
                    style: RPGTextStyle.subtitle,
                  ),
                  SizedBox(height: 8),
                  RPGText(
                    '• LoginFormOrganism - Formulário de login completo',
                    style: RPGTextStyle.body,
                  ),
                  RPGText(
                    '• RegisterFormOrganism - Formulário de cadastro',
                    style: RPGTextStyle.body,
                  ),
                  RPGText(
                    '• CharacterCreationFormOrganism - Criação de personagem',
                    style: RPGTextStyle.body,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // EXPLICAÇÃO DOS TEMPLATES
            _buildSectionTitle('📄 TEMPLATES'),
            
            const RPGCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RPGText(
                    'Templates Disponíveis:',
                    style: RPGTextStyle.subtitle,
                  ),
                  SizedBox(height: 8),
                  RPGText(
                    '• AuthTemplate - Para telas de autenticação',
                    style: RPGTextStyle.body,
                  ),
                  RPGText(
                    '• AppTemplate - Para telas internas (como esta)',
                    style: RPGTextStyle.body,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
  
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: RPGText(
        title,
        style: RPGTextStyle.subtitle,
        color: Colors.amber,
      ),
    );
  }
}

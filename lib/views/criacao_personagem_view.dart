import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/personagem_viewmodel.dart';
import '../ui/screens/templates/app_template.dart';
import '../ui/atoms/rpg_text.dart';
import '../ui/atoms/rpg_text_field.dart';

/// View para criação de personagem usando arquitetura MVVM
class CriacaoPersonagemView extends StatelessWidget {
  const CriacaoPersonagemView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<PersonagemViewModel>(
      builder: (context, personagemViewModel, child) {
        return AppTemplate(
          title: 'Criar Personagem',
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Seção Informações Básicas
                _buildSectionCard(
                  title: 'Informações Básicas',
                  icon: Icons.person,
                  children: [
                    RPGTextField(
                      controller: personagemViewModel.nomeController,
                      hintText: 'Nome do personagem',
                      prefixIcon: Icons.badge,
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            label: 'Classe',
                            value: personagemViewModel.classeSelecionada,
                            items: personagemViewModel.classesDisponiveis,
                            onChanged: personagemViewModel.setClasse,
                            icon: Icons.shield,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdown(
                            label: 'Raça',
                            value: personagemViewModel.racaSelecionada,
                            items: personagemViewModel.racasDisponiveis,
                            onChanged: personagemViewModel.setRaca,
                            icon: Icons.groups,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    _buildNumberField(
                      label: 'Nível',
                      value: personagemViewModel.nivel,
                      min: 1,
                      max: 20,
                      onChanged: personagemViewModel.setNivel,
                      icon: Icons.trending_up,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Seção Atributos
                _buildSectionCard(
                  title: 'Atributos',
                  icon: Icons.fitness_center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const RPGText('Atributos do Personagem', style: RPGTextStyle.body),
                        ElevatedButton.icon(
                          onPressed: personagemViewModel.rolarAtributos,
                          icon: const Icon(Icons.casino, size: 16),
                          label: const Text('Rolar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber,
                            foregroundColor: Colors.black,
                            minimumSize: const Size(0, 36),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    _buildAttributeRow([
                      _buildAttributeField('Força', personagemViewModel.forca, 'forca', personagemViewModel),
                      _buildAttributeField('Destreza', personagemViewModel.destreza, 'destreza', personagemViewModel),
                      _buildAttributeField('Constituição', personagemViewModel.constituicao, 'constituicao', personagemViewModel),
                    ]),
                    const SizedBox(height: 12),
                    _buildAttributeRow([
                      _buildAttributeField('Inteligência', personagemViewModel.inteligencia, 'inteligencia', personagemViewModel),
                      _buildAttributeField('Sabedoria', personagemViewModel.sabedoria, 'sabedoria', personagemViewModel),
                      _buildAttributeField('Carisma', personagemViewModel.carisma, 'carisma', personagemViewModel),
                    ]),
                  ],
                ),

                const SizedBox(height: 16),

                // Seção História
                _buildSectionCard(
                  title: 'História (Opcional)',
                  icon: Icons.auto_stories,
                  children: [
                    RPGTextField(
                      controller: personagemViewModel.historiaController,
                      hintText: 'Escreva a história do seu personagem...',
                      maxLines: 4,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Preview dos Status Calculados
                _buildSectionCard(
                  title: 'Status Calculados',
                  icon: Icons.calculate,
                  children: [
                    _buildStatusPreview(personagemViewModel),
                  ],
                ),

                const SizedBox(height: 24),

                // Botões de Ação
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: personagemViewModel.limparFormulario,
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: Colors.grey),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Limpar'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: personagemViewModel.isLoading
                            ? null
                            : () => _criarPersonagem(context, personagemViewModel),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: personagemViewModel.isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.black,
                                ),
                              )
                            : const Text(
                                'Criar Personagem',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.amber, size: 20),
                const SizedBox(width: 8),
                RPGText(
                  title,
                  style: RPGTextStyle.subtitle,
                  color: Colors.amber,
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          items: items
              .map((item) => DropdownMenuItem(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          dropdownColor: Colors.grey[800],
        ),
      ],
    );
  }

  Widget _buildNumberField({
    required String label,
    required int value,
    required int min,
    required int max,
    required Function(int) onChanged,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: Colors.grey),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              onPressed: value > min ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove),
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: value > min ? Colors.white : Colors.grey,
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  value.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            IconButton(
              onPressed: value < max ? () => onChanged(value + 1) : null,
              icon: const Icon(Icons.add),
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey[800],
                foregroundColor: value < max ? Colors.white : Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAttributeRow(List<Widget> children) {
    return Row(
      children: children.expand((child) => [
        Expanded(child: child),
        if (child != children.last) const SizedBox(width: 12),
      ]).toList(),
    );
  }

  Widget _buildAttributeField(String nome, int valor, String atributo, PersonagemViewModel viewModel) {
    final modificador = ((valor - 10) / 2).floor();
    final modificadorText = modificador >= 0 ? '+$modificador' : '$modificador';

    return Column(
      children: [
        Text(
          nome,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.amber),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                valor.toString(),
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                modificadorText,
                style: TextStyle(fontSize: 10, color: Colors.grey[400]),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: IconButton(
                onPressed: valor > 8 ? () => viewModel.setAtributo(atributo, valor - 1) : null,
                icon: const Icon(Icons.remove, size: 12),
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  foregroundColor: valor > 8 ? Colors.white : Colors.grey,
                ),
              ),
            ),
            const SizedBox(width: 4),
            SizedBox(
              width: 24,
              height: 24,
              child: IconButton(
                onPressed: valor < 18 ? () => viewModel.setAtributo(atributo, valor + 1) : null,
                icon: const Icon(Icons.add, size: 12),
                padding: EdgeInsets.zero,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.grey[700],
                  foregroundColor: valor < 18 ? Colors.white : Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusPreview(PersonagemViewModel viewModel) {
    // Calcula valores baseados nos atributos atuais
    final modificadorCon = ((viewModel.constituicao - 10) / 2).floor();
    final modificadorDex = ((viewModel.destreza - 10) / 2).floor();
    final pontosVida = (viewModel.nivel * 8) + (viewModel.nivel * modificadorCon);
    final classeArmadura = 10 + modificadorDex;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[800]?.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatPreview('Pontos de Vida', pontosVida.toString(), Icons.favorite),
              _buildStatPreview('Classe Armadura', classeArmadura.toString(), Icons.shield),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Estes valores são calculados automaticamente baseados nos atributos e nível',
            style: TextStyle(fontSize: 11, color: Colors.grey[400]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStatPreview(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.amber, size: 20),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber),
        ),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }

  Future<void> _criarPersonagem(BuildContext context, PersonagemViewModel viewModel) async {
    final sucesso = await viewModel.criarPersonagem();
    
    if (context.mounted) {
      if (sucesso) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Personagem criado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Retorna true indicando sucesso
      } else if (viewModel.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(viewModel.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
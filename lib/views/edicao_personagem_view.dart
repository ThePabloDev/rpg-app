import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/personagem_viewmodel.dart';

/// View para edição de personagem usando arquitetura MVVM
class EdicaoPersonagemView extends StatefulWidget {
  final Personagem personagem;

  const EdicaoPersonagemView({
    super.key,
    required this.personagem,
  });

  @override
  State<EdicaoPersonagemView> createState() => _EdicaoPersonagemViewState();
}

class _EdicaoPersonagemViewState extends State<EdicaoPersonagemView> {
  @override
  void initState() {
    super.initState();
    // Carregar dados do personagem nos controladores
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final viewModel = context.read<PersonagemViewModel>();
      viewModel.carregarPersonagemParaEdicao(widget.personagem);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PersonagemViewModel>(
      builder: (context, personagemViewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF1A0E2E),
          appBar: AppBar(
            title: const Text(
              'Editar Personagem',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            backgroundColor: const Color(0xFF1A0E2E),
            foregroundColor: Colors.white,
          ),
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
                    TextFormField(
                      controller: personagemViewModel.nomeController,
                      decoration: const InputDecoration(
                        hintText: 'Nome do personagem',
                        prefixIcon: Icon(Icons.badge),
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: _buildDropdown(
                            'Classe',
                            personagemViewModel.classeSelecionada,
                            personagemViewModel.classes,
                            (value) => personagemViewModel.selecionarClasse(value!),
                            Icons.shield,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildDropdown(
                            'Raça',
                            personagemViewModel.racaSelecionada,
                            personagemViewModel.racas,
                            (value) => personagemViewModel.selecionarRaca(value!),
                            Icons.face,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    _buildDropdown(
                      'Nível',
                      personagemViewModel.nivel.toString(),
                      List.generate(20, (index) => (index + 1).toString()),
                      (value) => personagemViewModel.selecionarNivel(int.parse(value!)),
                      Icons.star,
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
                      children: [
                        Expanded(child: _buildAtributoField('Força', personagemViewModel.forca, (value) => personagemViewModel.atualizarForca(value))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildAtributoField('Destreza', personagemViewModel.destreza, (value) => personagemViewModel.atualizarDestreza(value))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildAtributoField('Constituição', personagemViewModel.constituicao, (value) => personagemViewModel.atualizarConstituicao(value))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildAtributoField('Inteligência', personagemViewModel.inteligencia, (value) => personagemViewModel.atualizarInteligencia(value))),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildAtributoField('Sabedoria', personagemViewModel.sabedoria, (value) => personagemViewModel.atualizarSabedoria(value))),
                        const SizedBox(width: 12),
                        Expanded(child: _buildAtributoField('Carisma', personagemViewModel.carisma, (value) => personagemViewModel.atualizarCarisma(value))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: personagemViewModel.rolarAtributos,
                        icon: const Icon(Icons.casino),
                        label: const Text('Rolar Atributos'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple.shade600,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Seção História
                _buildSectionCard(
                  title: 'História do Personagem',
                  icon: Icons.book,
                  children: [
                    TextFormField(
                      controller: personagemViewModel.historiaController,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: 'Descreva a história e personalidade do seu personagem...',
                        border: OutlineInputBorder(),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Botão Salvar Alterações
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: personagemViewModel.isLoading 
                      ? null 
                      : () => _salvarAlteracoes(context, personagemViewModel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: personagemViewModel.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Salvar Alterações',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),

                // Botão Cancelar
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
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
      elevation: 4,
      color: const Color(0xFF2D1B69),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    void Function(String?) onChanged,
    IconData icon,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          initialValue: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            prefixIcon: Icon(icon),
            border: const OutlineInputBorder(),
          ),
          dropdownColor: const Color(0xFF2D1B69),
          style: const TextStyle(color: Colors.white),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildAtributoField(String label, int value, void Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A0E2E),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.purple.shade600),
          ),
          child: Row(
            children: [
              IconButton(
                onPressed: value > 8 ? () => onChanged(value - 1) : null,
                icon: const Icon(Icons.remove, size: 16),
                color: Colors.white,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
              Expanded(
                child: Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
              IconButton(
                onPressed: value < 20 ? () => onChanged(value + 1) : null,
                icon: const Icon(Icons.add, size: 16),
                color: Colors.white,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _salvarAlteracoes(BuildContext context, PersonagemViewModel viewModel) async {
    final success = await viewModel.atualizarPersonagem(widget.personagem.id);
    
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Personagem atualizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true); // Retorna true para indicar que houve alteração
    } else if (context.mounted && viewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(viewModel.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
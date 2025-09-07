import 'package:flutter/material.dart';
import '../molecules/rpg_form_field.dart';
import '../molecules/rpg_action_button.dart';
import '../molecules/rpg_section_header.dart';
import '../molecules/rpg_compact_card.dart';
import '../molecules/rpg_compact_attribute_slider.dart';
import '../molecules/rpg_compact_dropdown.dart';
import '../atoms/rpg_text.dart';

class CharacterCreationFormOrganism extends StatefulWidget {
  final VoidCallback onCreateCharacter;

  const CharacterCreationFormOrganism({
    super.key,
    required this.onCreateCharacter,
  });

  @override
  State<CharacterCreationFormOrganism> createState() => _CharacterCreationFormOrganismState();
}

class _CharacterCreationFormOrganismState extends State<CharacterCreationFormOrganism> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  String? _raca;
  String? _classe;
  String? _antecedente;
  String? _alinhamento;
  int _nivel = 1;
  final Map<String, int> _atributos = {
    'Força': 10,
    'Destreza': 10,
    'Constituição': 10,
    'Inteligência': 10,
    'Sabedoria': 10,
    'Carisma': 10,
  };

  final List<String> racas = [
    'Humano', 'Elfo', 'Anão', 'Halfling', 'Draconato', 'Gnomo', 'Meio-Elfo', 'Meio-Orc', 'Tiefling'
  ];
  final List<String> classes = [
    'Bárbaro', 'Bardo', 'Bruxo', 'Clérigo', 'Druida', 'Feiticeiro', 'Guerreiro', 'Ladino', 'Mago', 'Monge', 'Paladino', 'Patrulheiro'
  ];
  final List<String> antecedentes = [
    'Acólito', 'Artesão de Guilda', 'Criminoso', 'Eremita', 'Forasteiro', 'Herói do Povo', 'Marinheiro', 'Nobre', 'Órfão', 'Sábio', 'Soldado'
  ];
  final List<String> alinhamentos = [
    'Leal e Bom', 'Neutro e Bom', 'Caótico e Bom', 'Leal e Neutro', 'Neutro', 'Caótico e Neutro', 'Leal e Mau', 'Neutro e Mau', 'Caótico e Mau'
  ];

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  void _handleCreateCharacter() {
    if (_formKey.currentState!.validate()) {
      widget.onCreateCharacter();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero section com nome
            RPGCompactCard(
              child: Column(
                children: [
                  const RPGSectionHeader(
                    title: 'Identidade do Herói',
                    icon: Icons.person,
                  ),
                  RPGFormField(
                    label: 'Nome do Personagem',
                    controller: _nomeController,
                    prefixIcon: Icons.badge,
                    validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
                  ),
                ],
              ),
            ),
            
            // Características básicas em grid compacto
            RPGCompactCard(
              child: Column(
                children: [
                  const RPGSectionHeader(
                    title: 'Características',
                    icon: Icons.auto_awesome,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RPGCompactDropdown<String>(
                          label: 'Raça',
                          value: _raca,
                          items: racas,
                          itemLabel: (item) => item,
                          onChanged: (value) => setState(() => _raca = value),
                          validator: (value) => value == null ? 'Selecione a raça' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RPGCompactDropdown<String>(
                          label: 'Classe',
                          value: _classe,
                          items: classes,
                          itemLabel: (item) => item,
                          onChanged: (value) => setState(() => _classe = value),
                          validator: (value) => value == null ? 'Selecione a classe' : null,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RPGCompactDropdown<String>(
                          label: 'Antecedente',
                          value: _antecedente,
                          items: antecedentes,
                          itemLabel: (item) => item,
                          onChanged: (value) => setState(() => _antecedente = value),
                          validator: (value) => value == null ? 'Selecione o antecedente' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: RPGCompactDropdown<String>(
                          label: 'Alinhamento',
                          value: _alinhamento,
                          items: alinhamentos,
                          itemLabel: (item) => item,
                          onChanged: (value) => setState(() => _alinhamento = value),
                          validator: (value) => value == null ? 'Selecione o alinhamento' : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Nível com visual mais elegante
            RPGCompactCard(
              child: Column(
                children: [
                  const RPGSectionHeader(
                    title: 'Nível',
                    icon: Icons.star,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.amber.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const RPGText(
                          'Nível do Personagem',
                          style: RPGTextStyle.body,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.amber.withValues(alpha: 0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: RPGText(
                            _nivel.toString(),
                            style: RPGTextStyle.subtitle,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.amber,
                      inactiveTrackColor: Colors.amber.withValues(alpha: 0.3),
                      thumbColor: Colors.amber,
                      overlayColor: Colors.amber.withValues(alpha: 0.2),
                      trackHeight: 6,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
                    ),
                    child: Slider(
                      value: _nivel.toDouble(),
                      min: 1,
                      max: 20,
                      divisions: 19,
                      onChanged: (value) {
                        setState(() {
                          _nivel = value.round();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            
            // Atributos com visual mais limpo
            RPGCompactCard(
              child: Column(
                children: [
                  const RPGSectionHeader(
                    title: 'Atributos',
                    icon: Icons.fitness_center,
                  ),
                  ..._atributos.entries.map((entry) => RPGCompactAttributeSlider(
                    attribute: entry.key,
                    value: entry.value,
                    onChanged: (value) {
                      setState(() {
                        _atributos[entry.key] = value;
                      });
                    },
                  )),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            
            // Botão de criação mais estiloso
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.withValues(alpha: 0.1),
                    Colors.amber.withValues(alpha: 0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: RPGActionButton(
                text: 'CRIAR PERSONAGEM',
                onPressed: _handleCreateCharacter,
                icon: Icons.auto_awesome,
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaCriacaoPersonagem extends StatefulWidget {
  const TelaCriacaoPersonagem({super.key});

  @override
  State<TelaCriacaoPersonagem> createState() => _TelaCriacaoPersonagemState();
}

class _TelaCriacaoPersonagemState extends State<TelaCriacaoPersonagem> {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Criar Personagem', style: GoogleFonts.cinzel()),
        backgroundColor: Colors.black.withOpacity(0.85),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome do Personagem'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o nome' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _raca,
                decoration: const InputDecoration(labelText: 'Raça'),
                items: racas.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (v) => setState(() => _raca = v),
                validator: (value) => value == null ? 'Selecione a raça' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _classe,
                decoration: const InputDecoration(labelText: 'Classe'),
                items: classes.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                onChanged: (v) => setState(() => _classe = v),
                validator: (value) => value == null ? 'Selecione a classe' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _antecedente,
                decoration: const InputDecoration(labelText: 'Antecedente'),
                items: antecedentes.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                onChanged: (v) => setState(() => _antecedente = v),
                validator: (value) => value == null ? 'Selecione o antecedente' : null,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _alinhamento,
                decoration: const InputDecoration(labelText: 'Alinhamento'),
                items: alinhamentos.map((a) => DropdownMenuItem(value: a, child: Text(a))).toList(),
                onChanged: (v) => setState(() => _alinhamento = v),
                validator: (value) => value == null ? 'Selecione o alinhamento' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Nível:'),
                  Expanded(
                    child: Slider(
                      value: _nivel.toDouble(),
                      min: 1,
                      max: 20,
                      divisions: 19,
                      label: _nivel.toString(),
                      onChanged: (v) => setState(() => _nivel = v.round()),
                    ),
                  ),
                  Text('$_nivel'),
                ],
              ),
              const SizedBox(height: 16),
              Text('Atributos', style: GoogleFonts.cinzel(fontWeight: FontWeight.bold)),
              ..._atributos.keys.map((atrib) => Row(
                children: [
                  Expanded(child: Text(atrib)),
                  IconButton(
                    icon: const Icon(Icons.remove),
                    onPressed: () {
                      setState(() {
                        if (_atributos[atrib]! > 1) _atributos[atrib] = _atributos[atrib]! - 1;
                      });
                    },
                  ),
                  Text(_atributos[atrib]!.toString()),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      setState(() {
                        if (_atributos[atrib]! < 20) _atributos[atrib] = _atributos[atrib]! + 1;
                      });
                    },
                  ),
                ],
              )),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Aqui você pode salvar o personagem ou navegar para outra tela
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Personagem criado com sucesso!')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                child: const Text('Salvar Personagem', style: TextStyle(color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

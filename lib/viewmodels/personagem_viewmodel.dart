import 'package:flutter/material.dart';
import '../core/base_viewmodel.dart';

/// Modelo de dados para um personagem
class Personagem {
  final String id;
  final String nome;
  final String classe;
  final String raca;
  final int nivel;
  final int forca;
  final int destreza;
  final int constituicao;
  final int inteligencia;
  final int sabedoria;
  final int carisma;
  final String? imagemUrl;
  final String? historia;
  final DateTime criadoEm;
  final DateTime atualizadoEm;

  Personagem({
    required this.id,
    required this.nome,
    required this.classe,
    required this.raca,
    required this.nivel,
    required this.forca,
    required this.destreza,
    required this.constituicao,
    required this.inteligencia,
    required this.sabedoria,
    required this.carisma,
    this.imagemUrl,
    this.historia,
    required this.criadoEm,
    required this.atualizadoEm,
  });

  /// Calcula o modificador de um atributo
  int calcularModificador(int atributo) {
    return ((atributo - 10) / 2).floor();
  }

  /// Modificadores calculados
  int get modificadorForca => calcularModificador(forca);
  int get modificadorDestreza => calcularModificador(destreza);
  int get modificadorConstituicao => calcularModificador(constituicao);
  int get modificadorInteligencia => calcularModificador(inteligencia);
  int get modificadorSabedoria => calcularModificador(sabedoria);
  int get modificadorCarisma => calcularModificador(carisma);

  /// Pontos de vida calculados
  int get pontosVida => (nivel * 8) + (nivel * modificadorConstituicao);

  /// Classe de armadura base
  int get classeArmadura => 10 + modificadorDestreza;

  /// Cria uma cópia do personagem com os campos alterados
  Personagem copyWith({
    String? nome,
    String? classe,
    String? raca,
    int? nivel,
    int? forca,
    int? destreza,
    int? constituicao,
    int? inteligencia,
    int? sabedoria,
    int? carisma,
    String? imagemUrl,
    String? historia,
  }) {
    return Personagem(
      id: id,
      nome: nome ?? this.nome,
      classe: classe ?? this.classe,
      raca: raca ?? this.raca,
      nivel: nivel ?? this.nivel,
      forca: forca ?? this.forca,
      destreza: destreza ?? this.destreza,
      constituicao: constituicao ?? this.constituicao,
      inteligencia: inteligencia ?? this.inteligencia,
      sabedoria: sabedoria ?? this.sabedoria,
      carisma: carisma ?? this.carisma,
      imagemUrl: imagemUrl ?? this.imagemUrl,
      historia: historia ?? this.historia,
      criadoEm: criadoEm,
      atualizadoEm: DateTime.now(),
    );
  }

  /// Converte para Map (para serialização)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'classe': classe,
      'raca': raca,
      'nivel': nivel,
      'forca': forca,
      'destreza': destreza,
      'constituicao': constituicao,
      'inteligencia': inteligencia,
      'sabedoria': sabedoria,
      'carisma': carisma,
      'imagemUrl': imagemUrl,
      'historia': historia,
      'criadoEm': criadoEm.toIso8601String(),
      'atualizadoEm': atualizadoEm.toIso8601String(),
    };
  }

  /// Cria a partir de um Map (para desserialização)
  factory Personagem.fromMap(Map<String, dynamic> map) {
    return Personagem(
      id: map['id'],
      nome: map['nome'],
      classe: map['classe'],
      raca: map['raca'],
      nivel: map['nivel'],
      forca: map['forca'],
      destreza: map['destreza'],
      constituicao: map['constituicao'],
      inteligencia: map['inteligencia'],
      sabedoria: map['sabedoria'],
      carisma: map['carisma'],
      imagemUrl: map['imagemUrl'],
      historia: map['historia'],
      criadoEm: DateTime.parse(map['criadoEm']),
      atualizadoEm: DateTime.parse(map['atualizadoEm']),
    );
  }
}

/// ViewModel responsável pelo gerenciamento de estado dos personagens
class PersonagemViewModel extends BaseViewModel {
  // Controllers para formulário de criação
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController historiaController = TextEditingController();

  // Estado dos personagens
  List<Personagem> _personagens = [];
  List<Personagem> _personagensFiltrados = [];
  Personagem? _personagemSelecionado;

  // Estado do formulário
  String _classeSelecionada = 'Guerreiro';
  String _racaSelecionada = 'Humano';
  int _nivel = 1;
  int _forca = 10;
  int _destreza = 10;
  int _constituicao = 10;
  int _inteligencia = 10;
  int _sabedoria = 10;
  int _carisma = 10;

  // Estado de filtros e busca
  String _filtroClasse = '';
  String _filtroRaca = '';
  String _termoBusca = '';

  /// Getters para os personagens
  List<Personagem> get personagens => List.unmodifiable(_personagens);
  List<Personagem> get personagensFiltrados => List.unmodifiable(_personagensFiltrados);
  Personagem? get personagemSelecionado => _personagemSelecionado;

  /// Getters para o formulário
  String get classeSelecionada => _classeSelecionada;
  String get racaSelecionada => _racaSelecionada;
  int get nivel => _nivel;
  int get forca => _forca;
  int get destreza => _destreza;
  int get constituicao => _constituicao;
  int get inteligencia => _inteligencia;
  int get sabedoria => _sabedoria;
  int get carisma => _carisma;

  /// Getters para filtros
  String get filtroClasse => _filtroClasse;
  String get filtroRaca => _filtroRaca;
  String get termoBusca => _termoBusca;

  /// Classes disponíveis
  List<String> get classesDisponiveis => [
        'Guerreiro',
        'Mago',
        'Ladino',
        'Clérigo',
        'Ranger',
        'Paladino',
        'Bárbaro',
        'Bardo',
        'Bruxo',
        'Feiticeiro',
        'Druida',
        'Monge',
      ];

  /// Raças disponíveis
  List<String> get racasDisponiveis => [
        'Humano',
        'Elfo',
        'Anão',
        'Halfling',
        'Draconato',
        'Gnomo',
        'Meio-Elfo',
        'Meio-Orc',
        'Tiefling',
      ];

  /// Define a classe selecionada
  void setClasse(String classe) {
    _classeSelecionada = classe;
    notifyListeners();
  }

  /// Define a raça selecionada
  void setRaca(String raca) {
    _racaSelecionada = raca;
    notifyListeners();
  }

  /// Define o nível
  void setNivel(int novoNivel) {
    _nivel = novoNivel.clamp(1, 20);
    notifyListeners();
  }

  /// Define um atributo
  void setAtributo(String atributo, int valor) {
    valor = valor.clamp(8, 18);
    switch (atributo) {
      case 'forca':
        _forca = valor;
        break;
      case 'destreza':
        _destreza = valor;
        break;
      case 'constituicao':
        _constituicao = valor;
        break;
      case 'inteligencia':
        _inteligencia = valor;
        break;
      case 'sabedoria':
        _sabedoria = valor;
        break;
      case 'carisma':
        _carisma = valor;
        break;
    }
    notifyListeners();
  }

  /// Rola atributos aleatórios
  void rolarAtributos() {
    _forca = _rolarAtributo();
    _destreza = _rolarAtributo();
    _constituicao = _rolarAtributo();
    _inteligencia = _rolarAtributo();
    _sabedoria = _rolarAtributo();
    _carisma = _rolarAtributo();
    notifyListeners();
  }

  int _rolarAtributo() {
    // Rola 4d6 e descarta o menor
    final List<int> rolagens = List.generate(4, (_) => 1 + (DateTime.now().microsecondsSinceEpoch % 6));
    rolagens.sort();
    return rolagens.skip(1).reduce((a, b) => a + b);
  }

  /// Limpa o formulário
  void limparFormulario() {
    nomeController.clear();
    historiaController.clear();
    _classeSelecionada = 'Guerreiro';
    _racaSelecionada = 'Humano';
    _nivel = 1;
    _forca = 10;
    _destreza = 10;
    _constituicao = 10;
    _inteligencia = 10;
    _sabedoria = 10;
    _carisma = 10;
    notifyListeners();
  }

  /// Cria um novo personagem
  Future<bool> criarPersonagem() async {
    if (nomeController.text.trim().isEmpty) {
      setError('Nome do personagem é obrigatório');
      return false;
    }

    final resultado = await executeWithLoadingAndError<bool>(
      () async {
        await Future.delayed(Duration(seconds: 1)); // Simula criação

        final novoPersonagem = Personagem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nome: nomeController.text.trim(),
          classe: _classeSelecionada,
          raca: _racaSelecionada,
          nivel: _nivel,
          forca: _forca,
          destreza: _destreza,
          constituicao: _constituicao,
          inteligencia: _inteligencia,
          sabedoria: _sabedoria,
          carisma: _carisma,
          historia: historiaController.text.trim().isNotEmpty ? historiaController.text.trim() : null,
          criadoEm: DateTime.now(),
          atualizadoEm: DateTime.now(),
        );

        _personagens.add(novoPersonagem);
        _aplicarFiltros();
        limparFormulario();

        return true;
      },
      errorPrefix: 'Erro ao criar personagem',
    );

    return resultado ?? false;
  }

  /// Carrega lista de personagens
  Future<void> carregarPersonagens() async {
    await executeWithLoadingAndError(
      () async {
        await Future.delayed(Duration(seconds: 1)); // Simula carregamento

        // Personagens de exemplo
        _personagens = [
          Personagem(
            id: '1',
            nome: 'Aragorn',
            classe: 'Ranger',
            raca: 'Humano',
            nivel: 5,
            forca: 16,
            destreza: 14,
            constituicao: 15,
            inteligencia: 12,
            sabedoria: 15,
            carisma: 13,
            historia: 'Um ranger experiente das terras selvagens.',
            criadoEm: DateTime.now().subtract(Duration(days: 10)),
            atualizadoEm: DateTime.now().subtract(Duration(days: 1)),
          ),
          Personagem(
            id: '2',
            nome: 'Gandalf',
            classe: 'Mago',
            raca: 'Humano',
            nivel: 10,
            forca: 10,
            destreza: 11,
            constituicao: 14,
            inteligencia: 18,
            sabedoria: 16,
            carisma: 15,
            historia: 'Um poderoso mago das terras médias.',
            criadoEm: DateTime.now().subtract(Duration(days: 20)),
            atualizadoEm: DateTime.now().subtract(Duration(days: 2)),
          ),
        ];

        _aplicarFiltros();
      },
      errorPrefix: 'Erro ao carregar personagens',
    );
  }

  /// Define filtro de classe
  void setFiltroClasse(String classe) {
    _filtroClasse = classe;
    _aplicarFiltros();
  }

  /// Define filtro de raça
  void setFiltroRaca(String raca) {
    _filtroRaca = raca;
    _aplicarFiltros();
  }

  /// Define termo de busca
  void setTermoBusca(String termo) {
    _termoBusca = termo;
    _aplicarFiltros();
  }

  /// Limpa todos os filtros
  void limparFiltros() {
    _filtroClasse = '';
    _filtroRaca = '';
    _termoBusca = '';
    _aplicarFiltros();
  }

  /// Aplica filtros à lista
  void _aplicarFiltros() {
    _personagensFiltrados = _personagens.where((personagem) {
      final matchBusca = _termoBusca.isEmpty ||
          personagem.nome.toLowerCase().contains(_termoBusca.toLowerCase()) ||
          personagem.classe.toLowerCase().contains(_termoBusca.toLowerCase()) ||
          personagem.raca.toLowerCase().contains(_termoBusca.toLowerCase());

      final matchClasse = _filtroClasse.isEmpty || personagem.classe == _filtroClasse;

      final matchRaca = _filtroRaca.isEmpty || personagem.raca == _filtroRaca;

      return matchBusca && matchClasse && matchRaca;
    }).toList();

    // Ordena por nome
    _personagensFiltrados.sort((a, b) => a.nome.compareTo(b.nome));

    notifyListeners();
  }

  /// Seleciona um personagem
  void selecionarPersonagem(Personagem personagem) {
    _personagemSelecionado = personagem;
    notifyListeners();
  }

  /// Remove um personagem
  Future<bool> removerPersonagem(String id) async {
    final resultado = await executeWithLoadingAndError<bool>(
      () async {
        await Future.delayed(Duration(milliseconds: 500));

        _personagens.removeWhere((p) => p.id == id);
        _aplicarFiltros();

        if (_personagemSelecionado?.id == id) {
          _personagemSelecionado = null;
        }

        return true;
      },
      errorPrefix: 'Erro ao remover personagem',
    );

    return resultado ?? false;
  }

  /// Edita um personagem
  Future<bool> editarPersonagem(String id, Personagem personagemEditado) async {
    final resultado = await executeWithLoadingAndError<bool>(
      () async {
        await Future.delayed(Duration(milliseconds: 500));

        final index = _personagens.indexWhere((p) => p.id == id);
        if (index != -1) {
          _personagens[index] = personagemEditado;
          _aplicarFiltros();

          if (_personagemSelecionado?.id == id) {
            _personagemSelecionado = personagemEditado;
          }

          return true;
        }

        throw Exception('Personagem não encontrado');
      },
      errorPrefix: 'Erro ao editar personagem',
    );

    return resultado ?? false;
  }

  @override
  void dispose() {
    nomeController.dispose();
    historiaController.dispose();
    super.dispose();
  }
}
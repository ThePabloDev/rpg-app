import 'dart:math';
import 'package:flutter/material.dart';
import '../core/base_viewmodel.dart';
import '../services/personagem_service.dart';

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

  /// Pontos de mana calculados (baseado em Inteligência para magos)
  int get pontosMana {
    // Classes que usam mana e seus modificadores
    switch (classe.toLowerCase()) {
      case 'mago':
      case 'feiticeiro':
        return (nivel * 6) + (nivel * modificadorInteligencia);
      case 'clerigo':
      case 'druida':
        return (nivel * 4) + (nivel * modificadorSabedoria);
      case 'bardo':
      case 'warlock':
        return (nivel * 4) + (nivel * modificadorCarisma);
      case 'ranger':
      case 'paladino':
        return nivel >= 2 ? ((nivel - 1) * 3) + (modificadorSabedoria > 0 ? modificadorSabedoria * 2 : 0) : 0;
      default:
        return 0; // Guerreiro, Bárbaro, etc. não têm mana
    }
  }

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

  /// Getters para compatibilidade com a tela de edição
  List<String> get classes => classesDisponiveis;
  List<String> get racas => racasDisponiveis;

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

  /// Métodos para compatibilidade com a tela de edição
  void selecionarClasse(String classe) => setClasse(classe);
  void selecionarRaca(String raca) => setRaca(raca);
  void selecionarNivel(int nivel) => setNivel(nivel);

  /// Métodos para atualizar atributos individuais
  void atualizarForca(int valor) => setAtributo('forca', valor);
  void atualizarDestreza(int valor) => setAtributo('destreza', valor);
  void atualizarConstituicao(int valor) => setAtributo('constituicao', valor);
  void atualizarInteligencia(int valor) => setAtributo('inteligencia', valor);
  void atualizarSabedoria(int valor) => setAtributo('sabedoria', valor);
  void atualizarCarisma(int valor) => setAtributo('carisma', valor);

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
    // Rola 4d6 e descarta o menor (método padrão D&D 5e)
    final random = Random();
    final List<int> rolagens = List.generate(4, (_) => 1 + random.nextInt(6));
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

  /// Carrega um personagem para edição
  void carregarPersonagemParaEdicao(Personagem personagem) {
    nomeController.text = personagem.nome;
    historiaController.text = personagem.historia ?? '';
    _classeSelecionada = personagem.classe;
    _racaSelecionada = personagem.raca;
    _nivel = personagem.nivel;
    _forca = personagem.forca;
    _destreza = personagem.destreza;
    _constituicao = personagem.constituicao;
    _inteligencia = personagem.inteligencia;
    _sabedoria = personagem.sabedoria;
    _carisma = personagem.carisma;
    notifyListeners();
  }

  /// Atualiza um personagem existente
  Future<bool> atualizarPersonagem(String id) async {
    if (nomeController.text.trim().isEmpty) {
      setError('Nome do personagem é obrigatório');
      return false;
    }

    final personagemAtualizado = Personagem(
      id: id,
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
      criadoEm: DateTime.now(), // Precisaríamos salvar a data original
      atualizadoEm: DateTime.now(),
    );

    return await editarPersonagem(id, personagemAtualizado);
  }

  /// Cria um novo personagem
  Future<bool> criarPersonagem() async {
    if (nomeController.text.trim().isEmpty) {
      setError('Nome do personagem é obrigatório');
      return false;
    }

    final resultado = await executeWithLoadingAndError<bool>(
      () async {
        final novoPersonagem = Personagem(
          id: PersonagemService.generateId(),
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

        final result = await PersonagemService.criarPersonagem(novoPersonagem);
        
        if (result.success && result.personagem != null) {
          _personagens.add(result.personagem!);
          _aplicarFiltros();
          limparFormulario();
          return true;
        } else {
          throw Exception(result.error ?? 'Erro ao criar personagem');
        }
      },
      errorPrefix: 'Erro ao criar personagem',
    );

    return resultado ?? false;
  }

  /// Carrega lista de personagens
  Future<void> carregarPersonagens() async {
    await executeWithLoadingAndError(
      () async {
        final result = await PersonagemService.getPersonagens();
        
        if (result.success && result.personagens != null) {
          _personagens = result.personagens!;
          _aplicarFiltros();
        } else {
          throw Exception(result.error ?? 'Erro ao carregar personagens');
        }
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
        final result = await PersonagemService.excluirPersonagem(id);
        
        if (result.success) {
          _personagens.removeWhere((p) => p.id == id);
          _aplicarFiltros();

          if (_personagemSelecionado?.id == id) {
            _personagemSelecionado = null;
          }

          return true;
        } else {
          throw Exception(result.error ?? 'Erro ao remover personagem');
        }
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
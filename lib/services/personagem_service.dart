import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../viewmodels/personagem_viewmodel.dart';
import 'auth_service.dart';

/// Resultado de operações de personagem
class PersonagemResult {
  final bool success;
  final String? error;
  final Personagem? personagem;
  final List<Personagem>? personagens;

  PersonagemResult({
    required this.success,
    this.error,
    this.personagem,
    this.personagens,
  });

  factory PersonagemResult.success({Personagem? personagem, List<Personagem>? personagens}) {
    return PersonagemResult(success: true, personagem: personagem, personagens: personagens);
  }

  factory PersonagemResult.error(String error) {
    return PersonagemResult(success: false, error: error);
  }
}

/// Serviço para gerenciar personagens no Supabase
class PersonagemService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  static const String _tableName = 'personagens';

  /// Busca todos os personagens do usuário atual
  static Future<PersonagemResult> getPersonagens() async {
    try {
      if (!AuthService.isLoggedIn) {
        return PersonagemResult.error('Usuário não logado');
      }

      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('user_id', AuthService.currentUser!.id)
          .order('created_at', ascending: false);

      final personagens = (response as List)
          .map((json) => _personagemFromMap(json))
          .toList();

      return PersonagemResult.success(personagens: personagens);
    } on PostgrestException catch (e) {
      return PersonagemResult.error('Erro no banco: ${e.message}');
    } catch (e) {
      return PersonagemResult.error('Erro de conexão: $e');
    }
  }

  /// Busca um personagem específico por ID
  static Future<PersonagemResult> getPersonagem(String id) async {
    try {
      if (!AuthService.isLoggedIn) {
        return PersonagemResult.error('Usuário não logado');
      }

      final response = await _supabase
          .from(_tableName)
          .select()
          .eq('id', id)
          .eq('user_id', AuthService.currentUser!.id)
          .single();

      final personagem = _personagemFromMap(response);
      return PersonagemResult.success(personagem: personagem);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        return PersonagemResult.error('Personagem não encontrado');
      }
      return PersonagemResult.error('Erro no banco: ${e.message}');
    } catch (e) {
      return PersonagemResult.error('Erro de conexão: $e');
    }
  }

  /// Cria um novo personagem
  static Future<PersonagemResult> criarPersonagem(Personagem personagem) async {
    try {
      if (!AuthService.isLoggedIn) {
        return PersonagemResult.error('Usuário não logado');
      }

      // Calcula pontos de vida baseado na classe e constituição
      final pontosVida = _calcularPontosVida(personagem.classe, personagem.nivel, personagem.constituicao);
      
      // Calcula classe de armadura baseada na destreza (sem armadura)
      final classeArmadura = 10 + personagem.calcularModificador(personagem.destreza);

      final data = {
        'user_id': AuthService.currentUser!.id,
        'nome': personagem.nome.trim(),
        'classe': personagem.classe,
        'raca': personagem.raca,
        'nivel': personagem.nivel,
        'forca': personagem.forca,
        'destreza': personagem.destreza,
        'constituicao': personagem.constituicao,
        'inteligencia': personagem.inteligencia,
        'sabedoria': personagem.sabedoria,
        'carisma': personagem.carisma,
        'historia': personagem.historia?.trim(),
        'imagem_url': personagem.imagemUrl,
        'pontos_vida': pontosVida,
        'classe_armadura': classeArmadura,
        'velocidade': _getVelocidadeRaca(personagem.raca),
      };

      final response = await _supabase
          .from(_tableName)
          .insert(data)
          .select()
          .single();

      final novoPersonagem = _personagemFromMap(response);
      return PersonagemResult.success(personagem: novoPersonagem);
    } on PostgrestException catch (e) {
      return PersonagemResult.error('Erro no banco: ${e.message}');
    } catch (e) {
      return PersonagemResult.error('Erro ao criar personagem: $e');
    }
  }

  /// Atualiza um personagem existente
  static Future<PersonagemResult> atualizarPersonagem(Personagem personagem) async {
    try {
      if (!AuthService.isLoggedIn) {
        return PersonagemResult.error('Usuário não logado');
      }

      // Recalcula stats baseados nos novos atributos
      final pontosVida = _calcularPontosVida(personagem.classe, personagem.nivel, personagem.constituicao);
      final classeArmadura = 10 + personagem.calcularModificador(personagem.destreza);

      final data = {
        'nome': personagem.nome.trim(),
        'classe': personagem.classe,
        'raca': personagem.raca,
        'nivel': personagem.nivel,
        'forca': personagem.forca,
        'destreza': personagem.destreza,
        'constituicao': personagem.constituicao,
        'inteligencia': personagem.inteligencia,
        'sabedoria': personagem.sabedoria,
        'carisma': personagem.carisma,
        'historia': personagem.historia?.trim(),
        'imagem_url': personagem.imagemUrl,
        'pontos_vida': pontosVida,
        'classe_armadura': classeArmadura,
        'velocidade': _getVelocidadeRaca(personagem.raca),
      };

      final response = await _supabase
          .from(_tableName)
          .update(data)
          .eq('id', personagem.id)
          .eq('user_id', AuthService.currentUser!.id)
          .select()
          .single();

      final personagemAtualizado = _personagemFromMap(response);
      return PersonagemResult.success(personagem: personagemAtualizado);
    } on PostgrestException catch (e) {
      if (e.code == 'PGRST116') {
        return PersonagemResult.error('Personagem não encontrado ou não autorizado');
      }
      return PersonagemResult.error('Erro no banco: ${e.message}');
    } catch (e) {
      return PersonagemResult.error('Erro ao atualizar personagem: $e');
    }
  }

  /// Exclui um personagem
  static Future<PersonagemResult> excluirPersonagem(String id) async {
    try {
      if (!AuthService.isLoggedIn) {
        return PersonagemResult.error('Usuário não logado');
      }

      await _supabase
          .from(_tableName)
          .delete()
          .eq('id', id)
          .eq('user_id', AuthService.currentUser!.id);

      return PersonagemResult.success();
    } on PostgrestException catch (e) {
      return PersonagemResult.error('Erro no banco: ${e.message}');
    } catch (e) {
      return PersonagemResult.error('Erro ao excluir personagem: $e');
    }
  }

  /// Stream em tempo real dos personagens do usuário
  static Stream<List<Personagem>> personagensStream() {
    if (!AuthService.isLoggedIn) {
      return Stream.value([]);
    }

    return _supabase
        .from(_tableName)
        .stream(primaryKey: ['id'])
        .eq('user_id', AuthService.currentUser!.id)
        .order('created_at', ascending: false)
        .map((data) => data.map((json) => _personagemFromMap(json)).toList());
  }

  /// Converte Map do Supabase para Personagem
  static Personagem _personagemFromMap(Map<String, dynamic> map) {
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
      historia: map['historia'],
      imagemUrl: map['imagem_url'],
      criadoEm: DateTime.parse(map['created_at']),
      atualizadoEm: DateTime.parse(map['updated_at']),
    );
  }

  /// Calcula pontos de vida baseado na classe, nível e constituição
  static int _calcularPontosVida(String classe, int nivel, int constituicao) {
    // Dados de vida por classe (D&D 5e)
    final dadosVida = {
      'Bárbaro': 12,
      'Guerreiro': 10, 'Paladino': 10, 'Ranger': 10,
      'Bardo': 8, 'Clérigo': 8, 'Druida': 8, 'Ladino': 8, 'Warlock': 8,
      'Feiticeiro': 6, 'Mago': 6,
    };

    final dv = dadosVida[classe] ?? 8; // Default d8
    final modificadorCon = ((constituicao - 10) / 2).floor();
    
    // Nível 1: máximo do dado + mod CON
    // Níveis seguintes: média do dado + mod CON
    final vidaNivel1 = dv + modificadorCon;
    final vidaNiveisRestantes = (nivel - 1) * (((dv / 2) + 1).floor() + modificadorCon);
    
    return vidaNivel1 + vidaNiveisRestantes;
  }

  /// Retorna velocidade baseada na raça
  static int _getVelocidadeRaca(String raca) {
    final velocidades = {
      'Humano': 30, 'Elfo': 30, 'Anão': 25, 'Halfling': 25,
      'Draconato': 30, 'Gnomo': 25, 'Meio-Elfo': 30, 'Meio-Orc': 30,
      'Tiefling': 30,
    };
    return velocidades[raca] ?? 30;
  }

  /// Gera um ID único para personagem
  static String generateId() {
    return const Uuid().v4();
  }
}
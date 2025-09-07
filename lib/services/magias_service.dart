import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/magia.dart';

class MagiasService {
  static const String baseUrl = 'https://www.dnd5eapi.co/api';
  static List<Magia>? _cachedMagias;
  static List<Map<String, dynamic>>? _allSpellsIndex; // Index de todas as magias
  
  Future<List<Magia>> fetchMagias({String language = 'en', int limit = 100}) async {
    // Retorna cache se já existir e tiver magias suficientes
    if (_cachedMagias != null && _cachedMagias!.length >= limit) {
      return _cachedMagias!.take(limit).toList();
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/spells'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(Duration(seconds: 30));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> results = data['results'];
        
        // Salvar index para buscas futuras
        _allSpellsIndex = results.cast<Map<String, dynamic>>();
        
        // Carregar mais magias baseado no limite
        List<Magia> magias = _cachedMagias ?? [];
        int maxMagias = limit.clamp(20, 150); // Entre 20 e 150 magias
        
        // Se já temos magias em cache, continuar de onde paramos
        int startIndex = magias.length;
        
        for (int i = startIndex; i < results.length && magias.length < maxMagias; i++) {
          var spellSummary = results[i];
          
          try {
            final detailResponse = await http.get(
              Uri.parse('https://www.dnd5eapi.co${spellSummary['url']}'),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            ).timeout(Duration(seconds: 10));
            
            if (detailResponse.statusCode == 200) {
              final spellData = jsonDecode(detailResponse.body);
              magias.add(Magia.fromJson(spellData));
            }
          } catch (e) {
            // Ignora magias com erro e continua
            continue;
          }
          
          // Pequena pausa para evitar sobrecarga da API
          await Future.delayed(Duration(milliseconds: 50));
        }
        
        _cachedMagias = magias;
        return magias;
      } else {
        throw Exception('Erro HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<Magia?> fetchMagiaByName(String name, {String language = 'en'}) async {
    try {
      // Converter nome para o formato da API (lowercase com hífens)
      final formattedName = name.toLowerCase()
          .replaceAll(' ', '-')
          .replaceAll(RegExp(r'[^a-z0-9\-]'), '');
      
      final response = await http.get(
        Uri.parse('$baseUrl/spells/$formattedName'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return Magia.fromJson(data);
      } else if (response.statusCode == 404) {
        return null; // Magia não encontrada
      } else {
        throw Exception('Erro ao buscar magia: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  Future<List<Magia>> searchMagias(String query, {String language = 'en'}) async {
    // Primeiro busca nas magias já carregadas
    final cachedResults = await _searchInCached(query);
    
    if (cachedResults.isNotEmpty || query.isEmpty) {
      return cachedResults;
    }
    
    // Se não encontrou nas cached, tenta buscar por nome específico na API
    final specificSpell = await fetchMagiaByName(query, language: language);
    if (specificSpell != null) {
      return [specificSpell];
    }
    
    // Se ainda não encontrou, carrega mais magias e busca novamente
    if (_cachedMagias == null || _cachedMagias!.length < 100) {
      await fetchMagias(limit: 100);
      return await _searchInCached(query);
    }
    
    return [];
  }
  
  Future<List<Magia>> _searchInCached(String query) async {
    if (_cachedMagias == null) {
      await fetchMagias();
    }
    
    final lowerQuery = query.toLowerCase();
    return _cachedMagias!.where((magia) => 
      magia.name.toLowerCase().contains(lowerQuery) ||
      magia.school.toLowerCase().contains(lowerQuery) ||
      magia.description.toLowerCase().contains(lowerQuery) ||
      magia.level.toString().contains(lowerQuery) ||
      (magia.classes?.any((className) => className.toLowerCase().contains(lowerQuery)) ?? false)
    ).toList();
  }
  
  // Filtros específicos
  Future<List<Magia>> filterByLevel(int level) async {
    if (_cachedMagias == null) await fetchMagias();
    return _cachedMagias!.where((magia) => magia.level == level.toString()).toList();
  }
  
  Future<List<Magia>> filterBySchool(String school) async {
    if (_cachedMagias == null) await fetchMagias();
    return _cachedMagias!.where((magia) => 
      magia.school.toLowerCase() == school.toLowerCase()).toList();
  }
  
  Future<List<Magia>> filterByClass(String className) async {
    if (_cachedMagias == null) await fetchMagias();
    return _cachedMagias!.where((magia) => 
      magia.classes?.any((c) => c.toLowerCase() == className.toLowerCase()) ?? false).toList();
  }
  
  // Busca avançada com múltiplos filtros
  Future<List<Magia>> advancedSearch({
    String? query,
    int? level,
    String? school,
    String? className,
    bool? ritual,
    bool? concentration,
  }) async {
    if (_cachedMagias == null) await fetchMagias(limit: 150);
    
    List<Magia> results = List.from(_cachedMagias!);
    
    if (query != null && query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      results = results.where((magia) => 
        magia.name.toLowerCase().contains(lowerQuery) ||
        magia.description.toLowerCase().contains(lowerQuery)).toList();
    }
    
    if (level != null) {
      results = results.where((magia) => magia.level == level.toString()).toList();
    }
    
    if (school != null) {
      results = results.where((magia) => 
        magia.school.toLowerCase() == school.toLowerCase()).toList();
    }
    
    if (className != null) {
      results = results.where((magia) => 
        magia.classes?.any((c) => c.toLowerCase() == className.toLowerCase()) ?? false).toList();
    }
    
    if (ritual != null) {
      results = results.where((magia) => 
        (magia.ritual?.toLowerCase() == 'true') == ritual).toList();
    }
    
    if (concentration != null) {
      results = results.where((magia) => 
        (magia.concentration?.toLowerCase() == 'true') == concentration).toList();
    }
    
    return results;
  }
  
  // Método para carregar mais magias incrementalmente
  Future<List<Magia>> loadMoreSpells({int additionalCount = 50}) async {
    final currentCount = _cachedMagias?.length ?? 0;
    final newLimit = currentCount + additionalCount;
    return await fetchMagias(limit: newLimit.clamp(50, 319));
  }
  
  // Obter listas de opções para filtros
  Future<List<String>> getAvailableSchools() async {
    if (_cachedMagias == null) await fetchMagias();
    return _cachedMagias!.map((m) => m.school).toSet().toList()..sort();
  }
  
  Future<List<String>> getAvailableClasses() async {
    if (_cachedMagias == null) await fetchMagias();
    final allClasses = <String>{};
    for (var magia in _cachedMagias!) {
      if (magia.classes != null) {
        allClasses.addAll(magia.classes!);
      }
    }
    return allClasses.toList()..sort();
  }
  
  Future<List<int>> getAvailableLevels() async {
    if (_cachedMagias == null) await fetchMagias();
    return _cachedMagias!
        .map((m) => int.tryParse(m.level) ?? 0)
        .toSet()
        .toList()..sort();
  }

  // Método para limpar o cache
  static void clearCache() {
    _cachedMagias = null;
    _allSpellsIndex = null;
  }
  
  // Obter estatísticas do cache
  Map<String, dynamic> getCacheStats() {
    return {
      'cached_spells': _cachedMagias?.length ?? 0,
      'total_available': _allSpellsIndex?.length ?? 319,
      'cache_percentage': _cachedMagias != null && _allSpellsIndex != null
          ? ((_cachedMagias!.length / _allSpellsIndex!.length) * 100).round()
          : 0,
    };
  }

  // Método para buscar todas as magias sem limite (pode ser lento)
  Future<List<Magia>> fetchAllMagias({String language = 'en'}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/spells'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> results = data['results'];
        
        // Buscar detalhes de cada magia
        List<Magia> magias = [];
        for (int i = 0; i < results.length; i++) {
          var spellSummary = results[i];
          
          try {
            final detailResponse = await http.get(
              Uri.parse('https://www.dnd5eapi.co${spellSummary['url']}'),
              headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
              },
            );
            
            if (detailResponse.statusCode == 200) {
              final spellData = jsonDecode(detailResponse.body);
              magias.add(Magia.fromJson(spellData));
            }
          } catch (e) {
            // Ignora magias com erro e continua
            continue;
          }
          
          // Progresso silencioso para não poluir os logs
          if ((i + 1) % 50 == 0) {
            // print('Carregadas ${i + 1}/${results.length} magias...');
          }
        }
        
        _cachedMagias = magias;
        return magias;
      } else {
        throw Exception('Erro ao buscar magias: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }
}

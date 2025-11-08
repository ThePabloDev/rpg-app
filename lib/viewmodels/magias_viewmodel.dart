import '../core/base_viewmodel.dart';
import '../models/magia.dart';
import '../services/magias_service.dart';

/// ViewModel responsável pelo gerenciamento de estado das magias
class MagiasViewModel extends BaseViewModel {
  final MagiasService _magiasService = MagiasService();

  List<Magia> _magias = [];
  List<Magia> _filteredMagias = [];
  Map<String, dynamic> _activeFilters = {};
  bool _showFilters = false;
  bool _isLoadingMore = false;

  /// Lista completa de magias carregadas
  List<Magia> get magias => List.unmodifiable(_magias);

  /// Lista de magias filtradas para exibição
  List<Magia> get filteredMagias => List.unmodifiable(_filteredMagias);

  /// Filtros ativos aplicados à busca
  Map<String, dynamic> get activeFilters => Map.unmodifiable(_activeFilters);

  /// Indica se os filtros estão sendo exibidos
  bool get showFilters => _showFilters;

  /// Indica se está carregando mais magias (carregamento incremental)
  bool get isLoadingMore => _isLoadingMore;

  /// Indica se tem mais magias para carregar
  bool get canLoadMore => _magias.length >= 100;

  /// Carrega a lista inicial de magias
  Future<void> loadMagias({int limit = 100}) async {
    await executeWithLoadingAndError(
      () async {
        final magias = await _magiasService.fetchMagias(limit: limit);
        _magias = magias;
        _filteredMagias = magias;
      },
      errorPrefix: 'Erro ao carregar magias',
    );
  }

  /// Carrega mais magias (carregamento incremental)
  Future<void> loadMoreMagias() async {
    if (_isLoadingMore || !canLoadMore) return;

    try {
      _isLoadingMore = true;
      notifyListeners();

      final currentCount = _magias.length;
      final newLimit = currentCount + 50;
      
      final magias = await _magiasService.fetchMagias(limit: newLimit);
      _magias = magias;
      
      // Aplica filtros se existirem
      if (_activeFilters.isNotEmpty) {
        await _applyCurrentFilters();
      } else {
        _filteredMagias = magias;
      }
      
    } catch (e) {
      setError('Erro ao carregar mais magias: $e');
    } finally {
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Busca magias por termo
  Future<void> searchMagias(String query) async {
    if (query.trim().isEmpty) {
      _filteredMagias = _magias;
      notifyListeners();
      return;
    }

    await executeWithLoadingAndError(
      () async {
        final results = await _magiasService.searchMagias(query);
        _filteredMagias = results;
      },
      errorPrefix: 'Erro ao buscar magias',
      showLoading: false, // Não mostra loading para busca rápida
    );
  }

  /// Aplica filtros avançados
  Future<void> applyFilters(Map<String, dynamic> filters) async {
    _activeFilters = Map.from(filters);
    await _applyCurrentFilters();
  }

  /// Aplica os filtros atualmente ativos
  Future<void> _applyCurrentFilters() async {
    await executeWithLoadingAndError(
      () async {
        if (_activeFilters.isEmpty) {
          _filteredMagias = _magias;
        } else {
          // Por enquanto, vamos fazer filtragem local
          _filteredMagias = _filterMagiasLocally(_magias, _activeFilters);
        }
      },
      errorPrefix: 'Erro ao aplicar filtros',
      showLoading: false,
    );
  }

  /// Filtra magias localmente baseado nos filtros
  List<Magia> _filterMagiasLocally(List<Magia> magias, Map<String, dynamic> filters) {
    return magias.where((magia) {
      // Filtro por nível
      if (filters.containsKey('level') && filters['level'] != null) {
        int filterLevel = filters['level'] as int;
        int magiaLevel = int.tryParse(magia.level) ?? 0;
        if (magiaLevel != filterLevel) return false;
      }

      // Filtro por escola
      if (filters.containsKey('school') && filters['school'] != null) {
        String filterSchool = filters['school'] as String;
        if (!magia.school.toLowerCase().contains(filterSchool.toLowerCase())) {
          return false;
        }
      }

      // Filtro por ritual
      if (filters.containsKey('ritual') && filters['ritual'] == true) {
        if (magia.ritual?.toLowerCase() != 'yes') return false;
      }

      // Filtro por concentração
      if (filters.containsKey('concentration') && filters['concentration'] == true) {
        if (magia.concentration?.toLowerCase() != 'yes') return false;
      }

      return true;
    }).toList();
  }

  /// Limpa todos os filtros
  void clearFilters() {
    _activeFilters.clear();
    _filteredMagias = _magias;
    notifyListeners();
  }

  /// Alterna a visibilidade dos filtros
  void toggleFilters() {
    _showFilters = !_showFilters;
    notifyListeners();
  }

  /// Obtém uma magia específica por nome
  Magia? getMagiaByName(String name) {
    try {
      return _magias.firstWhere((magia) => magia.name.toLowerCase() == name.toLowerCase());
    } catch (e) {
      return null;
    }
  }

  /// Conta o número de filtros ativos
  int get activeFiltersCount {
    return _activeFilters.values.where((value) {
      if (value is bool) return value == true;
      if (value is String) return value.isNotEmpty;
      return value != null;
    }).length;
  }

  /// Recarrega as magias (pull-to-refresh)
  Future<void> refreshMagias() async {
    // Força recarregamento - vamos implementar cache clearing no service depois
    await loadMagias();
  }
}
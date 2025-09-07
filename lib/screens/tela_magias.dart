import 'package:flutter/material.dart';
import '../ui/screens/templates/app_template.dart';
import '../ui/atoms/rpg_text.dart';
import '../ui/atoms/rpg_text_field.dart';
import '../ui/molecules/magia_card.dart';
import '../ui/molecules/magia_filters_widget.dart';
import '../ui/organisms/magia_detail_organism.dart';
import '../services/magias_service.dart';
import '../models/magia.dart';

class TelaMagias extends StatefulWidget {
  const TelaMagias({super.key});

  @override
  State<TelaMagias> createState() => _TelaMagiasState();
}

class _TelaMagiasState extends State<TelaMagias> {
  final MagiasService _magiasService = MagiasService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Magia> _magias = [];
  List<Magia> _filteredMagias = [];
  bool _isLoading = true;
  bool _isLoadingMore = false;
  String? _error;
  bool _showFilters = false;
  Map<String, dynamic> _activeFilters = {};
  
  @override
  void initState() {
    super.initState();
    _loadMagias();
    _searchController.addListener(_performSearch);
  }
  
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  
  Future<void> _loadMagias({int limit = 100}) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    
    try {
      final magias = await _magiasService.fetchMagias(limit: limit);
      setState(() {
        _magias = magias;
        _filteredMagias = magias;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }
  
  Future<void> _loadMoreMagias() async {
    if (_isLoadingMore) return;
    
    setState(() {
      _isLoadingMore = true;
    });
    
    try {
      final moreMagias = await _magiasService.loadMoreSpells();
      setState(() {
        _magias = moreMagias;
        _applyFiltersAndSearch();
        _isLoadingMore = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMore = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao carregar mais magias: $e')),
        );
      }
    }
  }
  
  Future<void> _performSearch() async {
    final query = _searchController.text.trim();
    
    if (query.isEmpty) {
      setState(() {
        _filteredMagias = _magias;
      });
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      final results = await _magiasService.searchMagias(query);
      setState(() {
        _filteredMagias = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future<void> _applyFilters(Map<String, dynamic> filters) async {
    setState(() {
      _activeFilters = filters;
      _isLoading = true;
    });
    
    try {
      List<Magia> results;
      if (filters.isEmpty) {
        results = _magias;
      } else {
        results = await _magiasService.advancedSearch(
          query: _searchController.text.isNotEmpty ? _searchController.text : null,
          level: filters['level'],
          school: filters['school'],
          className: filters['className'],
          ritual: filters['ritual'],
          concentration: filters['concentration'],
        );
      }
      
      setState(() {
        _filteredMagias = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  void _applyFiltersAndSearch() {
    if (_activeFilters.isNotEmpty) {
      _applyFilters(_activeFilters);
    } else {
      _performSearch();
    }
  }
  
  void _showMagiaDetail(Magia magia) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            MagiaDetailCard(magia: magia),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final cacheStats = _magiasService.getCacheStats();
    
    return AppTemplate(
      title: 'Magias D&D',
      body: Column(
        children: [
          // Barra de pesquisa
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                RPGTextField(
                  controller: _searchController,
                  hintText: 'Pesquisar magias...',
                  prefixIcon: Icons.search,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_filteredMagias.length} magias encontradas',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(
                            _showFilters ? Icons.filter_list_off : Icons.filter_list,
                            color: _activeFilters.isNotEmpty ? Colors.blue : null,
                          ),
                          onPressed: () {
                            setState(() {
                              _showFilters = !_showFilters;
                            });
                          },
                          tooltip: 'Filtros',
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () => _loadMagias(limit: 150),
                          tooltip: 'Recarregar',
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Filtros (se visível)
          if (_showFilters)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: MagiaFiltersWidget(
                onFiltersChanged: _applyFilters,
              ),
            ),
          
          // Status do cache
          if (cacheStats['cached_spells'] > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.storage, size: 16, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      '${cacheStats['cached_spells']} de ${cacheStats['total_available']} magias carregadas (${cacheStats['cache_percentage']}%)',
                      style: const TextStyle(color: Colors.blue, fontSize: 12),
                    ),
                    const Spacer(),
                    if (cacheStats['cached_spells'] < cacheStats['total_available'])
                      TextButton(
                        onPressed: _isLoadingMore ? null : _loadMoreMagias,
                        child: _isLoadingMore 
                            ? const SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Carregar +50'),
                      ),
                  ],
                ),
              ),
            ),
          
          // Lista de magias
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.amber),
            SizedBox(height: 16),
            RPGText('Carregando magias...', style: RPGTextStyle.body),
          ],
        ),
      );
    }
    
    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, color: Colors.red, size: 48),
            const SizedBox(height: 16),
            RPGText(
              'Erro ao carregar magias',
              style: RPGTextStyle.subtitle,
              color: Colors.red,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: RPGText(
                _error!,
                style: RPGTextStyle.caption,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadMagias,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber,
                foregroundColor: Colors.black,
              ),
              child: const Text('Tentar novamente'),
            ),
          ],
        ),
      );
    }
    
    if (_filteredMagias.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, color: Colors.amber, size: 48),
            SizedBox(height: 16),
            RPGText('Nenhuma magia encontrada', style: RPGTextStyle.subtitle),
            SizedBox(height: 8),
            RPGText(
              'Tente usar outros termos de pesquisa',
              style: RPGTextStyle.caption,
            ),
          ],
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _loadMagias,
      color: Colors.amber,
      backgroundColor: Colors.grey[900],
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filteredMagias.length,
        itemBuilder: (context, index) {
          final magia = _filteredMagias[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: MagiaCard(
              magia: magia,
              onTap: () => _showMagiaDetail(magia),
            ),
          );
        },
      ),
    );
  }
}

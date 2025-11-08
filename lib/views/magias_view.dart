import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/magias_viewmodel.dart';
import '../ui/molecules/magia_filters_widget.dart';
import '../models/magia.dart';

/// View da tela de magias seguindo padrão MVVM
class MagiasView extends StatefulWidget {
  const MagiasView({super.key});

  @override
  State<MagiasView> createState() => _MagiasViewState();
}

class _MagiasViewState extends State<MagiasView> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    
    // Carrega magias quando a tela é iniciada
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MagiasViewModel>().loadMagias();
    });

    // Adiciona listener para scroll infinito
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      // Carrega mais quando chega perto do fim
      context.read<MagiasViewModel>().loadMoreMagias();
    }
  }

  void _onSearchChanged(String query) {
    // Debounce search
    Future.delayed(const Duration(milliseconds: 300), () {
      if (_searchController.text == query) {
        context.read<MagiasViewModel>().searchMagias(query);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grimório de Magias'),
        centerTitle: true,
        backgroundColor: Colors.purple.shade900,
        actions: [
          Consumer<MagiasViewModel>(
            builder: (context, viewModel, _) {
              return IconButton(
                icon: Icon(
                  viewModel.showFilters ? Icons.filter_list_off : Icons.filter_list,
                  color: viewModel.activeFiltersCount > 0 ? Colors.amber : null,
                ),
                onPressed: () => viewModel.toggleFilters(),
              );
            },
          ),
        ],
      ),
      body: Consumer<MagiasViewModel>(
        builder: (context, viewModel, _) {
          return Column(
            children: [
              // Campo de busca
              _buildSearchField(),
              
              // Filtros (se visíveis)
              if (viewModel.showFilters) _buildFiltersSection(viewModel),
              
              // Badge de filtros ativos
              if (viewModel.activeFiltersCount > 0) _buildActiveFiltersBadge(viewModel),
              
              // Lista de magias
              Expanded(child: _buildMagiasList(viewModel)),
            ],
          );
        },
      ),
      floatingActionButton: _buildLoadMoreButton(),
    );
  }

  Widget _buildSearchField() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        decoration: InputDecoration(
          hintText: 'Buscar magias...',
          prefixIcon: const Icon(Icons.search, color: Colors.purple),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.purple.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.purple.shade500, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersSection(MagiasViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MagiaFiltersWidget(
        onFiltersChanged: (filters) => viewModel.applyFilters(filters),
      ),
    );
  }

  Widget _buildActiveFiltersBadge(MagiasViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${viewModel.activeFiltersCount} filtros ativos',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => viewModel.clearFilters(),
            child: const Text('Limpar'),
          ),
        ],
      ),
    );
  }

  Widget _buildMagiasList(MagiasViewModel viewModel) {
    if (viewModel.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.purple),
            SizedBox(height: 16),
            Text('Carregando magias...'),
          ],
        ),
      );
    }

    if (viewModel.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 48, color: Colors.red.shade300),
            const SizedBox(height: 16),
            Text(
              viewModel.errorMessage ?? 'Erro desconhecido',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red.shade300),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => viewModel.loadMagias(),
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      );
    }

    if (viewModel.filteredMagias.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text('Nenhuma magia encontrada'),
            SizedBox(height: 8),
            Text(
              'Tente ajustar os filtros ou termos de busca',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => viewModel.refreshMagias(),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: viewModel.filteredMagias.length + 
                   (viewModel.isLoadingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == viewModel.filteredMagias.length) {
            // Loading indicator para carregamento incremental
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(color: Colors.purple),
              ),
            );
          }

          final magia = viewModel.filteredMagias[index];
          return _buildMagiaCard(magia);
        },
      ),
    );
  }

  Widget _buildMagiaCard(Magia magia) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      elevation: 2,
      child: ExpansionTile(
        title: Text(
          magia.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.purple,
          ),
        ),
        subtitle: Text(
          '${magia.school} • Nível ${magia.level}',
          style: TextStyle(color: Colors.grey.shade400),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMagiaDetail('Tempo de Conjuração', magia.castingTime),
                _buildMagiaDetail('Alcance', magia.range),
                _buildMagiaDetail('Componentes', magia.components),
                _buildMagiaDetail('Duração', magia.duration),
                const SizedBox(height: 8),
                Text(
                  'Descrição:',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade300,
                  ),
                ),
                const SizedBox(height: 4),
                Text(magia.description),
                if (magia.higherLevel != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Em Níveis Superiores:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade300,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(magia.higherLevel!),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMagiaDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildLoadMoreButton() {
    return Consumer<MagiasViewModel>(
      builder: (context, viewModel, _) {
        if (!viewModel.canLoadMore || viewModel.isLoadingMore) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton.extended(
          onPressed: () => viewModel.loadMoreMagias(),
          icon: const Icon(Icons.add),
          label: const Text('Carregar +50'),
          backgroundColor: Colors.purple.shade700,
        );
      },
    );
  }
}
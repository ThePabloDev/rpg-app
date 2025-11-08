import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/personagem_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';

class ListaPersonagensView extends StatefulWidget {
  const ListaPersonagensView({super.key});

  @override
  State<ListaPersonagensView> createState() => _ListaPersonagensViewState();
}

class _ListaPersonagensViewState extends State<ListaPersonagensView> {
  final TextEditingController _searchController = TextEditingController();
  String _filtroClasse = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PersonagemViewModel>().carregarPersonagens();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A0E2E),
      appBar: AppBar(
        title: const Text(
          'Meus Personagens',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF2D1B69),
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/criacao_personagem');
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onSelected: (value) async {
              switch (value) {
                case 'logout':
                  final authViewModel = context.read<AuthViewModel>();
                  await authViewModel.logout();
                  if (mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context, 
                      '/login', 
                      (route) => false
                    );
                  }
                  break;
                case 'settings':
                  Navigator.pushNamed(context, '/configuracoes');
                  break;
                case 'magias':
                  Navigator.pushNamed(context, '/magias');
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'magias',
                child: ListTile(
                  leading: Icon(Icons.auto_fix_high),
                  title: Text('Magias'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('Configurações'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: ListTile(
                  leading: Icon(Icons.logout),
                  title: Text('Sair'),
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
      body: Consumer<PersonagemViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF9C27B0)),
              ),
            );
          }

          if (viewModel.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Erro ao carregar personagens',
                    style: TextStyle(
                      color: Colors.red.shade300,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    viewModel.errorMessage ?? 'Erro desconhecido',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 14,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => viewModel.carregarPersonagens(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF9C27B0),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }

          final personagens = viewModel.personagensFiltrados;

          return Column(
            children: [
              // Barra de pesquisa e filtros
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D1B69),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Barra de pesquisa
                    TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Pesquisar por nome...',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: Colors.grey.shade400),
                                onPressed: () {
                                  _searchController.clear();
                                  viewModel.limparFiltros();
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: const Color(0xFF1A0E2E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                      onChanged: (value) {
                        viewModel.setTermoBusca(value);
                      },
                    ),
                    const SizedBox(height: 12),
                    // Filtros rápidos
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _buildFilterChip(
                            'Todas as Classes',
                            _filtroClasse.isEmpty,
                            () {
                              setState(() {
                                _filtroClasse = '';
                              });
                              viewModel.setFiltroClasse('');
                            },
                          ),
                          const SizedBox(width: 8),
                          ...[
                            'Guerreiro', 'Mago', 'Ladino', 'Clérigo', 
                            'Bárbaro', 'Bardo', 'Druida', 'Feiticeiro', 
                            'Patrulheiro', 'Paladino', 'Bruxo', 'Monge'
                          ].map((classe) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _buildFilterChip(
                              classe,
                              _filtroClasse == classe,
                              () {
                                setState(() {
                                  _filtroClasse = _filtroClasse == classe ? '' : classe;
                                });
                                viewModel.setFiltroClasse(_filtroClasse);
                              },
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Lista de personagens
              Expanded(
                child: personagens.isEmpty
                    ? _buildEmptyState()
                    : _buildPersonagensList(personagens, viewModel),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/criacao_personagem');
        },
        backgroundColor: const Color(0xFF9C27B0),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Novo Personagem'),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onPressed) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade300,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
      selected: isSelected,
      selectedColor: const Color(0xFF9C27B0),
      backgroundColor: const Color(0xFF1A0E2E),
      onSelected: (_) => onPressed(),
      side: BorderSide(
        color: isSelected ? const Color(0xFF9C27B0) : Colors.grey.shade600,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 24),
          Text(
            'Nenhum personagem encontrado',
            style: TextStyle(
              color: Colors.grey.shade300,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Crie seu primeiro personagem para começar sua aventura!',
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, '/criacao_personagem');
            },
            icon: const Icon(Icons.add),
            label: const Text('Criar Personagem'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9C27B0),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonagensList(List<Personagem> personagens, PersonagemViewModel viewModel) {
    return RefreshIndicator(
      color: const Color(0xFF9C27B0),
      backgroundColor: const Color(0xFF2D1B69),
      onRefresh: () => viewModel.carregarPersonagens(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: personagens.length,
        itemBuilder: (context, index) {
          final personagem = personagens[index];
          return _buildPersonagemCard(personagem, viewModel);
        },
      ),
    );
  }

  Widget _buildPersonagemCard(Personagem personagem, PersonagemViewModel viewModel) {
    final nome = personagem.nome;
    final classe = personagem.classe;
    final raca = personagem.raca;
    final nivel = personagem.nivel;
    final vida = 0; // TODO: Implementar vida no modelo
    final vidaMaxima = 0; // TODO: Implementar vida máxima no modelo
    final classeArmadura = 10; // TODO: Implementar classe de armadura no modelo
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      color: const Color(0xFF2D1B69),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.purple.shade700.withValues(alpha: 0.3)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          viewModel.selecionarPersonagem(personagem);
          _showPersonagemDetails(personagem);
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar do personagem
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF9C27B0),
                          Colors.purple.shade300,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: Center(
                      child: Text(
                        nome.isNotEmpty ? nome[0].toUpperCase() : '?',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Informações básicas
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nome,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.shield,
                              size: 16,
                              color: Colors.grey.shade400,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$classe $raca',
                              style: TextStyle(
                                color: Colors.grey.shade300,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber.shade400,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Nível $nivel',
                              style: TextStyle(
                                color: Colors.amber.shade400,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Menu de ações
                  PopupMenuButton<String>(
                    icon: Icon(Icons.more_vert, color: Colors.grey.shade400),
                    onSelected: (value) async {
                      switch (value) {
                        case 'edit':
                          // TODO: Implementar edição quando necessário
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Edição será implementada em breve'),
                              backgroundColor: Color(0xFF9C27B0),
                            ),
                          );
                          break;
                        case 'duplicate':
                          // TODO: Implementar duplicação quando necessário
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Duplicação será implementada em breve'),
                              backgroundColor: Color(0xFF9C27B0),
                            ),
                          );
                          break;
                        case 'delete':
                          _confirmDelete(personagem, viewModel);
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem<String>(
                        value: 'edit',
                        child: ListTile(
                          leading: Icon(Icons.edit),
                          title: Text('Editar'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuItem<String>(
                        value: 'duplicate',
                        child: ListTile(
                          leading: Icon(Icons.copy),
                          title: Text('Duplicar'),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      const PopupMenuDivider(),
                      const PopupMenuItem<String>(
                        value: 'delete',
                        child: ListTile(
                          leading: Icon(Icons.delete, color: Colors.red),
                          title: Text('Excluir', style: TextStyle(color: Colors.red)),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Estatísticas básicas
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF1A0E2E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Vida', '$vida/$vidaMaxima', Icons.favorite),
                    _buildStatItem('CA', '$classeArmadura', Icons.shield),
                    _buildStatItem('Nível', '$nivel', Icons.star),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 20,
          color: const Color(0xFF9C27B0),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade400,
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  void _showPersonagemDetails(Personagem personagem) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: const BoxDecoration(
            color: Color(0xFF2D1B69),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF9C27B0),
                            Colors.purple.shade300,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Center(
                        child: Text(
                          personagem.nome.isNotEmpty ? personagem.nome[0].toUpperCase() : '?',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            personagem.nome,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${personagem.classe} ${personagem.raca} - Nível ${personagem.nivel}',
                            style: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
              // Detalhes do personagem
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailSection('Atributos', _buildAttributesGrid(personagem)),
                      const SizedBox(height: 16),
                      _buildDetailSection('Status', _buildStatusGrid(personagem)),
                      const SizedBox(height: 16),
                      _buildDetailSection('Informações', _buildInfoSection(personagem)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailSection(String title, Widget content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        content,
      ],
    );
  }

  Widget _buildAttributesGrid(Personagem personagem) {
    final attributes = [
      {'name': 'FOR', 'value': personagem.forca},
      {'name': 'DES', 'value': personagem.destreza},
      {'name': 'CON', 'value': personagem.constituicao},
      {'name': 'INT', 'value': personagem.inteligencia},
      {'name': 'SAB', 'value': personagem.sabedoria},
      {'name': 'CAR', 'value': personagem.carisma},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: attributes.length,
      itemBuilder: (context, index) {
        final attr = attributes[index];
        final value = attr['value'] as int;
        final modifier = ((value - 10) / 2).floor();
        
        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A0E2E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.purple.shade700.withValues(alpha: 0.3)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                attr['name'] as String,
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '$value',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${modifier >= 0 ? '+' : ''}$modifier',
                style: TextStyle(
                  color: modifier >= 0 ? Colors.green.shade300 : Colors.red.shade300,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatusGrid(Personagem personagem) {
    // Por enquanto usando valores padrão já que essas propriedades não existem no modelo atual
    final vida = 0;
    final vidaMaxima = 0; 
    final mana = 0;
    final manaMaxima = 0;
    
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatusBar(
                'Vida', 
                vida, 
                vidaMaxima, 
                Colors.red.shade400,
                Icons.favorite,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatusBar(
                'Mana', 
                mana, 
                manaMaxima, 
                Colors.blue.shade400,
                Icons.auto_fix_high,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildSimpleStatus(
                'CA', 
                '10', // TODO: Implementar cálculo de classe de armadura
                Icons.shield,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSimpleStatus(
                'Iniciativa', 
                '+${personagem.modificadorDestreza}', // Usando modificador de destreza
                Icons.flash_on,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSimpleStatus(
                'Velocidade', 
                '30m', // TODO: Implementar velocidade baseada na raça
                Icons.directions_run,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatusBar(String label, int current, int max, Color color, IconData icon) {
    final percentage = max > 0 ? current / max : 0.0;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0E2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade700.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 4),
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey.shade300,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Text(
                '$current/$max',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage,
            backgroundColor: Colors.grey.shade700,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildSimpleStatus(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0E2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade700.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 20, color: const Color(0xFF9C27B0)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection(Personagem personagem) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A0E2E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple.shade700.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Por enquanto apenas exibindo informações básicas do modelo atual
          _buildInfoRow('Classe', personagem.classe),
          const SizedBox(height: 8),
          _buildInfoRow('Raça', personagem.raca),
          const SizedBox(height: 8),
          _buildInfoRow('Nível', personagem.nivel.toString()),
          if (personagem.historia != null && personagem.historia!.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildInfoRow('História', personagem.historia!),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade400,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  void _confirmDelete(dynamic personagem, PersonagemViewModel viewModel) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D1B69),
        title: const Text(
          'Confirmar Exclusão',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Tem certeza que deseja excluir o personagem "${personagem.nome}"?\n\nEsta ação não pode ser desfeita.',
          style: TextStyle(color: Colors.grey.shade300),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancelar',
              style: TextStyle(color: Colors.grey.shade400),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await viewModel.removerPersonagem(personagem.id);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('${personagem.nome} foi excluído com sucesso'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Erro ao excluir personagem: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
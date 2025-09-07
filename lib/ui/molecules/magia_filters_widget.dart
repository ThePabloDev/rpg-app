import 'package:flutter/material.dart';
import '../../services/magias_service.dart';

class MagiaFiltersWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onFiltersChanged;
  
  const MagiaFiltersWidget({
    super.key,
    required this.onFiltersChanged,
  });

  @override
  State<MagiaFiltersWidget> createState() => _MagiaFiltersWidgetState();
}

class _MagiaFiltersWidgetState extends State<MagiaFiltersWidget> {
  final MagiasService _service = MagiasService();
  
  String? _selectedSchool;
  String? _selectedClass;
  int? _selectedLevel;
  bool? _isRitual;
  bool? _requiresConcentration;
  
  List<String> _availableSchools = [];
  List<String> _availableClasses = [];
  List<int> _availableLevels = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFilterOptions();
  }

  Future<void> _loadFilterOptions() async {
    try {
      final schools = await _service.getAvailableSchools();
      final classes = await _service.getAvailableClasses();
      final levels = await _service.getAvailableLevels();
      
      setState(() {
        _availableSchools = schools;
        _availableClasses = classes;
        _availableLevels = levels;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    final filters = <String, dynamic>{};
    
    if (_selectedSchool != null) filters['school'] = _selectedSchool;
    if (_selectedClass != null) filters['className'] = _selectedClass;
    if (_selectedLevel != null) filters['level'] = _selectedLevel;
    if (_isRitual != null) filters['ritual'] = _isRitual;
    if (_requiresConcentration != null) filters['concentration'] = _requiresConcentration;
    
    widget.onFiltersChanged(filters);
  }

  void _clearFilters() {
    setState(() {
      _selectedSchool = null;
      _selectedClass = null;
      _selectedLevel = null;
      _isRitual = null;
      _requiresConcentration = null;
    });
    widget.onFiltersChanged({});
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Filtros',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: _clearFilters,
                child: const Text('Limpar'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Nível
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  initialValue: _selectedLevel,
                  decoration: const InputDecoration(
                    labelText: 'Nível',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<int>(
                      value: null,
                      child: Text('Todos os níveis'),
                    ),
                    ..._availableLevels.map((level) => DropdownMenuItem<int>(
                      value: level,
                      child: Text('Nível $level'),
                    )),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedLevel = value;
                    });
                    _applyFilters();
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Escola
          DropdownButtonFormField<String>(
            initialValue: _selectedSchool,
            decoration: const InputDecoration(
              labelText: 'Escola de Magia',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('Todas as escolas'),
              ),
              ..._availableSchools.map((school) => DropdownMenuItem<String>(
                value: school,
                child: Text(school),
              )),
            ],
            onChanged: (value) {
              setState(() {
                _selectedSchool = value;
              });
              _applyFilters();
            },
          ),
          const SizedBox(height: 12),
          
          // Classe
          DropdownButtonFormField<String>(
            initialValue: _selectedClass,
            decoration: const InputDecoration(
              labelText: 'Classe',
              border: OutlineInputBorder(),
            ),
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('Todas as classes'),
              ),
              ..._availableClasses.map((className) => DropdownMenuItem<String>(
                value: className,
                child: Text(className),
              )),
            ],
            onChanged: (value) {
              setState(() {
                _selectedClass = value;
              });
              _applyFilters();
            },
          ),
          const SizedBox(height: 12),
          
          // Switches para Ritual e Concentração
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Checkbox(
                      value: _isRitual,
                      tristate: true,
                      onChanged: (value) {
                        setState(() {
                          _isRitual = value;
                        });
                        _applyFilters();
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text('Ritual'),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Checkbox(
                      value: _requiresConcentration,
                      tristate: true,
                      onChanged: (value) {
                        setState(() {
                          _requiresConcentration = value;
                        });
                        _applyFilters();
                      },
                    ),
                    const SizedBox(width: 8),
                    const Text('Concentração'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

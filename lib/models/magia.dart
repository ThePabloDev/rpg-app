class Magia {
  final String name;
  final String level;
  final String school;
  final String castingTime;
  final String range;
  final String components;
  final String duration;
  final String description;
  final String? higherLevel;
  final String? ritual;
  final String? concentration;
  final String? material;
  final List<String>? classes;

  Magia({
    required this.name,
    required this.level,
    required this.school,
    required this.castingTime,
    required this.range,
    required this.components,
    required this.duration,
    required this.description,
    this.higherLevel,
    this.ritual,
    this.concentration,
    this.material,
    this.classes,
  });

  factory Magia.fromJson(Map<String, dynamic> json) {
    // Converter descrição da API (array) para string
    String description = '';
    if (json['desc'] != null && json['desc'] is List) {
      description = (json['desc'] as List).join('\n\n');
    }

    // Converter higher level da API (array) para string
    String? higherLevel;
    if (json['higher_level'] != null && json['higher_level'] is List) {
      higherLevel = (json['higher_level'] as List).join('\n');
    }

    // Extrair nome da escola de magia
    String school = '';
    if (json['school'] != null && json['school']['name'] != null) {
      school = json['school']['name'];
    }

    // Converter componentes da API (array) para string
    String components = '';
    if (json['components'] != null && json['components'] is List) {
      components = (json['components'] as List).join(', ');
    }

    // Extrair classes que podem usar a magia
    List<String>? classes;
    if (json['classes'] != null && json['classes'] is List) {
      classes = (json['classes'] as List)
          .map((c) => c['name']?.toString() ?? '')
          .where((name) => name.isNotEmpty)
          .toList();
    }

    return Magia(
      name: json['name'] ?? '',
      level: json['level']?.toString() ?? '',
      school: school,
      castingTime: json['casting_time'] ?? '',
      range: json['range'] ?? '',
      components: components,
      duration: json['duration'] ?? '',
      description: description,
      higherLevel: higherLevel,
      ritual: json['ritual']?.toString(),
      concentration: json['concentration']?.toString(),
      material: json['material'],
      classes: classes,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'level': level,
      'school': school,
      'casting_time': castingTime,
      'range': range,
      'components': components,
      'duration': duration,
      'description': description,
      'higher_level': higherLevel,
      'ritual': ritual,
      'concentration': concentration,
      'material': material,
      'classes': classes,
    };
  }
}

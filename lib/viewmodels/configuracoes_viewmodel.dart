import 'package:flutter/material.dart';
import '../core/base_viewmodel.dart';

/// ViewModel responsável pelo gerenciamento de estado das configurações
class ConfiguracoesViewModel extends BaseViewModel {
  // Configurações de tema
  bool _isDarkMode = true;
  bool _useSystemTheme = false;
  
  // Configurações de notificações
  bool _enableNotifications = true;
  bool _enableSoundEffects = true;
  bool _enableVibration = true;
  
  // Configurações de jogo
  bool _showTutorial = true;
  bool _autoSaveEnabled = true;
  String _language = 'pt_BR';
  
  // Configurações avançadas
  bool _enableDebugMode = false;
  bool _enableBetaFeatures = false;
  double _animationSpeed = 1.0;
  
  /// Getters para tema
  bool get isDarkMode => _isDarkMode;
  bool get useSystemTheme => _useSystemTheme;
  
  /// Getters para notificações
  bool get enableNotifications => _enableNotifications;
  bool get enableSoundEffects => _enableSoundEffects;
  bool get enableVibration => _enableVibration;
  
  /// Getters para jogo
  bool get showTutorial => _showTutorial;
  bool get autoSaveEnabled => _autoSaveEnabled;
  String get language => _language;
  
  /// Getters para configurações avançadas
  bool get enableDebugMode => _enableDebugMode;
  bool get enableBetaFeatures => _enableBetaFeatures;
  double get animationSpeed => _animationSpeed;

  /// Alterna modo escuro
  Future<void> toggleDarkMode(bool value) async {
    await executeWithLoadingAndError(
      () async {
        await Future.delayed(Duration(milliseconds: 200)); // Simula salvamento
        _isDarkMode = value;
        // Aqui futuramente salvaria no SharedPreferences ou Firebase
      },
      showLoading: false,
    );
  }

  /// Alterna uso do tema do sistema
  Future<void> toggleSystemTheme(bool value) async {
    await executeWithLoadingAndError(
      () async {
        await Future.delayed(Duration(milliseconds: 200));
        _useSystemTheme = value;
        if (value) {
          // Se usar tema do sistema, detecta o tema atual
          final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
          _isDarkMode = brightness == Brightness.dark;
        }
      },
      showLoading: false,
    );
  }

  /// Alterna notificações
  Future<void> toggleNotifications(bool value) async {
    await executeWithLoadingAndError(
      () async {
        await Future.delayed(Duration(milliseconds: 200));
        _enableNotifications = value;
      },
      showLoading: false,
    );
  }

  /// Alterna efeitos sonoros
  Future<void> toggleSoundEffects(bool value) async {
    await executeWithLoadingAndError(
      () async {
        await Future.delayed(Duration(milliseconds: 200));
        _enableSoundEffects = value;
      },
      showLoading: false,
    );
  }

  /// Alterna vibração
  Future<void> toggleVibration(bool value) async {
    await executeWithLoadingAndError(
      () async {
        await Future.delayed(Duration(milliseconds: 200));
        _enableVibration = value;
      },
      showLoading: false,
    );
  }

  /// Alterna tutorial
  Future<void> toggleTutorial(bool value) async {
    await executeWithLoadingAndError(
      () async {
        await Future.delayed(Duration(milliseconds: 200));
        _showTutorial = value;
      },
      showLoading: false,
    );
  }

  /// Alterna auto save
  Future<void> toggleAutoSave(bool value) async {
    await executeWithLoadingAndError(
      () async {
        await Future.delayed(Duration(milliseconds: 200));
        _autoSaveEnabled = value;
      },
      showLoading: false,
    );
  }

  /// Altera idioma
  Future<void> setLanguage(String newLanguage) async {
    await executeWithLoadingAndError(
      () async {
        await Future.delayed(Duration(milliseconds: 500));
        _language = newLanguage;
      },
    );
  }

  /// Alterna modo debug
  Future<void> toggleDebugMode(bool value) async {
    await executeWithLoadingAndError(
      () async {
        await Future.delayed(Duration(milliseconds: 200));
        _enableDebugMode = value;
      },
      showLoading: false,
    );
  }

  /// Alterna recursos beta
  Future<void> toggleBetaFeatures(bool value) async {
    await executeWithLoadingAndError(
      () async {
        await Future.delayed(Duration(milliseconds: 200));
        _enableBetaFeatures = value;
      },
      showLoading: false,
    );
  }

  /// Define velocidade de animação
  Future<void> setAnimationSpeed(double speed) async {
    await executeWithLoadingAndError(
      () async {
        await Future.delayed(Duration(milliseconds: 200));
        _animationSpeed = speed;
      },
      showLoading: false,
    );
  }

  /// Carrega configurações salvas
  Future<void> loadSettings() async {
    await executeWithLoadingAndError(
      () async {
        // Simula carregamento de configurações
        await Future.delayed(Duration(seconds: 1));
        
        // Aqui futuramente carregaria do SharedPreferences ou Firebase
        // Por enquanto mantém os valores padrão
      },
      errorPrefix: 'Erro ao carregar configurações',
    );
  }

  /// Reseta todas as configurações para padrão
  Future<void> resetToDefaults() async {
    await executeWithLoadingAndError(
      () async {
        await Future.delayed(Duration(milliseconds: 500));
        
        // Restaura valores padrão
        _isDarkMode = true;
        _useSystemTheme = false;
        _enableNotifications = true;
        _enableSoundEffects = true;
        _enableVibration = true;
        _showTutorial = true;
        _autoSaveEnabled = true;
        _language = 'pt_BR';
        _enableDebugMode = false;
        _enableBetaFeatures = false;
        _animationSpeed = 1.0;
      },
      errorPrefix: 'Erro ao resetar configurações',
    );
  }

  /// Exporta configurações como JSON (para backup)
  Map<String, dynamic> exportSettings() {
    return {
      'theme': {
        'isDarkMode': _isDarkMode,
        'useSystemTheme': _useSystemTheme,
      },
      'notifications': {
        'enableNotifications': _enableNotifications,
        'enableSoundEffects': _enableSoundEffects,
        'enableVibration': _enableVibration,
      },
      'game': {
        'showTutorial': _showTutorial,
        'autoSaveEnabled': _autoSaveEnabled,
        'language': _language,
      },
      'advanced': {
        'enableDebugMode': _enableDebugMode,
        'enableBetaFeatures': _enableBetaFeatures,
        'animationSpeed': _animationSpeed,
      },
      'exportDate': DateTime.now().toIso8601String(),
    };
  }

  /// Importa configurações de JSON (para restore)
  Future<void> importSettings(Map<String, dynamic> settings) async {
    await executeWithLoadingAndError(
      () async {
        await Future.delayed(Duration(milliseconds: 500));
        
        // Importa configurações de tema
        final theme = settings['theme'] as Map<String, dynamic>?;
        if (theme != null) {
          _isDarkMode = theme['isDarkMode'] ?? _isDarkMode;
          _useSystemTheme = theme['useSystemTheme'] ?? _useSystemTheme;
        }
        
        // Importa configurações de notificações
        final notifications = settings['notifications'] as Map<String, dynamic>?;
        if (notifications != null) {
          _enableNotifications = notifications['enableNotifications'] ?? _enableNotifications;
          _enableSoundEffects = notifications['enableSoundEffects'] ?? _enableSoundEffects;
          _enableVibration = notifications['enableVibration'] ?? _enableVibration;
        }
        
        // Importa configurações de jogo
        final game = settings['game'] as Map<String, dynamic>?;
        if (game != null) {
          _showTutorial = game['showTutorial'] ?? _showTutorial;
          _autoSaveEnabled = game['autoSaveEnabled'] ?? _autoSaveEnabled;
          _language = game['language'] ?? _language;
        }
        
        // Importa configurações avançadas
        final advanced = settings['advanced'] as Map<String, dynamic>?;
        if (advanced != null) {
          _enableDebugMode = advanced['enableDebugMode'] ?? _enableDebugMode;
          _enableBetaFeatures = advanced['enableBetaFeatures'] ?? _enableBetaFeatures;
          _animationSpeed = (advanced['animationSpeed'] as num?)?.toDouble() ?? _animationSpeed;
        }
      },
      errorPrefix: 'Erro ao importar configurações',
    );
  }

  /// Lista de idiomas disponíveis
  List<Map<String, String>> get availableLanguages => [
    {'code': 'pt_BR', 'name': 'Português (Brasil)'},
    {'code': 'en_US', 'name': 'English (US)'},
    {'code': 'es_ES', 'name': 'Español'},
    {'code': 'fr_FR', 'name': 'Français'},
  ];

  /// Obtém o nome do idioma atual
  String get currentLanguageName {
    final current = availableLanguages.firstWhere(
      (lang) => lang['code'] == _language,
      orElse: () => {'code': 'pt_BR', 'name': 'Português (Brasil)'},
    );
    return current['name'] ?? 'Português (Brasil)';
  }
}
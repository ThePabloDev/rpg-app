import 'package:flutter/foundation.dart';

/// Base ViewModel class que todos os ViewModels devem estender
/// Fornece funcionalidades comuns como gerenciamento de estado de loading e erro
abstract class BaseViewModel extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  bool _disposed = false;

  /// Indica se o ViewModel está em estado de carregamento
  bool get isLoading => _isLoading;

  /// Mensagem de erro atual, se houver
  String? get errorMessage => _errorMessage;

  /// Indica se há um erro ativo
  bool get hasError => _errorMessage != null;

  /// Define o estado de loading
  void setLoading(bool loading) {
    if (_disposed) return;
    _isLoading = loading;
    notifyListeners();
  }

  /// Define uma mensagem de erro
  void setError(String? error) {
    if (_disposed) return;
    _errorMessage = error;
    notifyListeners();
  }

  /// Limpa o erro atual
  void clearError() {
    if (_disposed) return;
    _errorMessage = null;
    notifyListeners();
  }

  /// Executa uma operação async com tratamento automático de loading e erro
  Future<T?> executeWithLoadingAndError<T>(
    Future<T> Function() operation, {
    bool showLoading = true,
    String? errorPrefix,
  }) async {
    try {
      if (showLoading) setLoading(true);
      clearError();

      final result = await operation();
      
      if (showLoading) setLoading(false);
      return result;
    } catch (e) {
      if (showLoading) setLoading(false);
      
      String errorMsg = errorPrefix != null 
        ? '$errorPrefix: ${e.toString()}'
        : e.toString();
      
      setError(errorMsg);
      return null;
    }
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }
}
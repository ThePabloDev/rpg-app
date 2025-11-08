import 'package:flutter/material.dart';
import '../core/base_viewmodel.dart';

/// ViewModel responsável pelo gerenciamento de estado de autenticação
class AuthViewModel extends BaseViewModel {
  // Controllers para formulários
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Estado da UI
  bool _showPassword = false;
  bool _rememberMe = false;
  String? _emailError;
  String? _passwordError;
  String? _nameError;
  String? _confirmPasswordError;

  // Estado de autenticação
  bool _isLoggedIn = false;
  String? _userEmail;
  String? _userName;

  AuthViewModel() {
    // Valores de teste para facilitar desenvolvimento
    emailController.text = 'test@example.com';
    passwordController.text = '123456';
  }

  /// Getters para UI
  bool get showPassword => _showPassword;
  bool get rememberMe => _rememberMe;
  String? get emailError => _emailError;
  String? get passwordError => _passwordError;
  String? get nameError => _nameError;
  String? get confirmPasswordError => _confirmPasswordError;

  /// Indica se o usuário está logado
  bool get isLoggedIn => _isLoggedIn;
  bool get isAuthenticated => _isLoggedIn; // Alias para compatibilidade

  /// Email do usuário atual
  String? get userEmail => _userEmail;

  /// Nome do usuário atual
  String? get userName => _userName;

  /// Toggle visibilidade da senha
  void togglePasswordVisibility() {
    _showPassword = !_showPassword;
    notifyListeners();
  }

  /// Define se deve lembrar o usuário
  void setRememberMe(bool? value) {
    _rememberMe = value ?? false;
    notifyListeners();
  }

  /// Limpa os erros de validação
  void clearErrors() {
    _emailError = null;
    _passwordError = null;
    _nameError = null;
    _confirmPasswordError = null;
    notifyListeners();
  }

  /// Valida os campos de cadastro
  bool _validateRegisterFields() {
    clearErrors();
    bool isValid = true;

    // Validação do nome
    final nameValidation = validateName(nameController.text);
    if (nameValidation != null) {
      _nameError = nameValidation;
      isValid = false;
    }

    // Validação do email
    final emailValidation = validateEmail(emailController.text);
    if (emailValidation != null) {
      _emailError = emailValidation;
      isValid = false;
    }

    // Validação da senha
    final passwordValidation = validatePassword(passwordController.text);
    if (passwordValidation != null) {
      _passwordError = passwordValidation;
      isValid = false;
    }

    // Validação da confirmação de senha
    final confirmValidation = validateConfirmPassword(
      confirmPasswordController.text, 
      passwordController.text
    );
    if (confirmValidation != null) {
      _confirmPasswordError = confirmValidation;
      isValid = false;
    }

    if (!isValid) {
      notifyListeners();
    }

    return isValid;
  }

  /// Valida os campos de login
  bool _validateLoginFields() {
    clearErrors();
    bool isValid = true;

    // Validação do email
    final emailValidation = validateEmail(emailController.text);
    if (emailValidation != null) {
      _emailError = emailValidation;
      isValid = false;
    }

    // Validação da senha
    final passwordValidation = validatePassword(passwordController.text);
    if (passwordValidation != null) {
      _passwordError = passwordValidation;
      isValid = false;
    }

    if (!isValid) {
      notifyListeners();
    }

    return isValid;
  }

  /// Realiza login do usuário (sem parâmetros - usa controllers)
  Future<bool> login() async {
    if (!_validateLoginFields()) {
      return false;
    }

    final result = await executeWithLoadingAndError<bool>(
      () async {
        // Simula chamada de API de login
        await Future.delayed(Duration(seconds: 2));
        
        // Validação simples para demo
        final email = emailController.text;
        final password = passwordController.text;
        
        if (email.isNotEmpty && email.contains('@') && password.length >= 6) {
          _userEmail = email;
          _userName = _extractNameFromEmail(email);
          _isLoggedIn = true;
          return true;
        } else {
          throw Exception('Email ou senha inválidos');
        }
      },
      errorPrefix: 'Erro ao fazer login',
    );

    return result ?? false;
  }

  /// Realiza login offline
  void loginOffline() {
    _userEmail = 'usuario@offline.com';
    _userName = 'USUÁRIO OFFLINE';
    _isLoggedIn = true;
    notifyListeners();
  }

  /// Realiza cadastro do usuário
  Future<bool> register(String name, String email, String password, String confirmPassword) async {
    // Atualizar controllers com os valores fornecidos
    nameController.text = name;
    emailController.text = email;
    passwordController.text = password;
    confirmPasswordController.text = confirmPassword;
    
    if (!_validateRegisterFields()) {
      return false;
    }

    final result = await executeWithLoadingAndError<bool>(
      () async {
        // Validações
        if (name.trim().length < 2) {
          throw Exception('Nome deve ter pelo menos 2 caracteres');
        }
        
        if (!email.contains('@')) {
          throw Exception('Email inválido');
        }
        
        if (password.length < 6) {
          throw Exception('Senha deve ter pelo menos 6 caracteres');
        }
        
        if (password != confirmPassword) {
          throw Exception('Senhas não coincidem');
        }

        // Simula chamada de API de cadastro
        await Future.delayed(Duration(seconds: 2));
        
        _userName = name;
        _userEmail = email;
        _isLoggedIn = true;
        
        return true;
      },
      errorPrefix: 'Erro ao cadastrar',
    );

    return result ?? false;
  }

  /// Realiza logout do usuário
  Future<void> logout() async {
    await executeWithLoadingAndError(
      () async {
        // Simula chamada de API de logout
        await Future.delayed(Duration(milliseconds: 500));
        
        _isLoggedIn = false;
        _userEmail = null;
        _userName = null;
      },
      errorPrefix: 'Erro ao fazer logout',
      showLoading: false,
    );
  }

  /// Verifica se o usuário está autenticado (verificação de sessão)
  Future<void> checkAuthStatus() async {
    await executeWithLoadingAndError(
      () async {
        // Simula verificação de token/sessão
        await Future.delayed(Duration(seconds: 1));
        
        // Por enquanto, vamos manter o usuário deslogado
        // Futuramente isso verificará SharedPreferences ou Firebase Auth
        _isLoggedIn = false;
      },
      showLoading: false,
    );
  }

  /// Extrai o nome do usuário baseado no email
  String _extractNameFromEmail(String email) {
    final localPart = email.split('@')[0];
    return localPart.replaceAll('.', ' ').toUpperCase();
  }

  /// Valida email
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email é obrigatório';
    }
    if (!value.contains('@')) {
      return 'Email inválido';
    }
    return null;
  }

  /// Valida senha
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Senha é obrigatória';
    }
    if (value.length < 6) {
      return 'Senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  /// Valida nome
  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome é obrigatório';
    }
    if (value.trim().length < 2) {
      return 'Nome deve ter pelo menos 2 caracteres';
    }
    return null;
  }

  /// Valida confirmação de senha
  String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return 'Confirmação de senha é obrigatória';
    }
    if (value != password) {
      return 'Senhas não coincidem';
    }
    return null;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
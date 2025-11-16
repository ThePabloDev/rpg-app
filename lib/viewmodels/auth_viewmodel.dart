import 'package:flutter/material.dart';
import '../core/base_viewmodel.dart';
import '../services/auth_service.dart';

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
    // Verifica automaticamente se há usuário logado
    checkAuthStatus();
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
        final authResult = await AuthService.signIn(
          emailController.text,
          passwordController.text,
        );
        
        if (authResult.success && authResult.user != null) {
          _isLoggedIn = true;
          _userEmail = authResult.user!.email;
          _userName = authResult.user!.nome ?? 'Usuário';
          return true;
        } else {
          throw Exception(authResult.error ?? 'Erro no login');
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
        final authResult = await AuthService.signUp(
          email: email,
          password: password,
          nome: name,
        );
        
        if (authResult.success && authResult.user != null) {
          _isLoggedIn = true;
          _userEmail = authResult.user!.email;
          _userName = authResult.user!.nome ?? name;
          return true;
        } else {
          throw Exception(authResult.error ?? 'Erro no cadastro');
        }
      },
      errorPrefix: 'Erro ao cadastrar',
    );

    return result ?? false;
  }

  /// Realiza logout do usuário
  Future<bool> logout() async {
    final result = await executeWithLoadingAndError<bool>(
      () async {
        final authResult = await AuthService.signOut();
        
        if (authResult.success) {
          _isLoggedIn = false;
          _userEmail = null;
          _userName = null;
          clearAllFields();
          return true;
        } else {
          throw Exception(authResult.error ?? 'Erro no logout');
        }
      },
      errorPrefix: 'Erro ao fazer logout',
    );

    return result ?? false;
  }

  /// Verifica se o usuário está autenticado (verificação de sessão)
  Future<void> checkAuthStatus() async {
    await executeWithLoadingAndError(
      () async {
        // Verificação real do Supabase Auth
        final currentUser = AuthService.currentUser;
        
        if (currentUser != null) {
          _isLoggedIn = true;
          _userEmail = currentUser.email;
          _userName = currentUser.nome ?? 'Usuário';
        } else {
          _isLoggedIn = false;
          _userEmail = null;
          _userName = null;
        }
      },
      showLoading: false,
    );
  }

  /// Limpa todos os campos dos formulários
  void clearAllFields() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    confirmPasswordController.clear();
    clearErrors();
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

  /// Método de debug para verificar estado atual
  Map<String, dynamic> getDebugInfo() {
    return {
      'viewModelLoggedIn': _isLoggedIn,
      'viewModelEmail': _userEmail,
      'viewModelName': _userName,
      'authServiceInfo': AuthService.getDebugInfo(),
    };
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
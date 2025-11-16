import 'package:supabase_flutter/supabase_flutter.dart';

/// Modelo de usuário
class AppUser {
  final String id;
  final String email;
  final String? nome;
  final DateTime? createdAt;

  AppUser({
    required this.id,
    required this.email,
    this.nome,
    this.createdAt,
  });

  factory AppUser.fromSupabase(User user) {
    return AppUser(
      id: user.id,
      email: user.email ?? '',
      nome: user.userMetadata?['nome'],
      createdAt: DateTime.parse(user.createdAt),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'nome': nome,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}

/// Resultado de operações de autenticação
class AuthResult {
  final bool success;
  final String? error;
  final AppUser? user;

  AuthResult({
    required this.success,
    this.error,
    this.user,
  });

  factory AuthResult.success(AppUser user) {
    return AuthResult(success: true, user: user);
  }

  factory AuthResult.error(String error) {
    return AuthResult(success: false, error: error);
  }
}

/// Serviço de autenticação usando Supabase
class AuthService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Usuário atual logado
  static AppUser? get currentUser {
    final user = _supabase.auth.currentUser;
    return user != null ? AppUser.fromSupabase(user) : null;
  }

  /// Verifica se há usuário logado
  static bool get isLoggedIn => _supabase.auth.currentUser != null;

  /// Stream do estado de autenticação
  static Stream<AppUser?> get authStateChanges {
    return _supabase.auth.onAuthStateChange.map((data) {
      final user = data.session?.user;
      return user != null ? AppUser.fromSupabase(user) : null;
    });
  }

  /// Método de debug para verificar estado atual
  static Map<String, dynamic> getDebugInfo() {
    final user = _supabase.auth.currentUser;
    final session = _supabase.auth.currentSession;
    
    return {
      'hasUser': user != null,
      'userEmail': user?.email,
      'userId': user?.id,
      'hasSession': session != null,
      'sessionValid': session != null && !session.isExpired,
      'expiresAt': session?.expiresAt,
      'userMetadata': user?.userMetadata,
    };
  }

  /// Realiza login com email e senha
  static Future<AuthResult> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );

      if (response.user != null) {
        return AuthResult.success(AppUser.fromSupabase(response.user!));
      } else {
        return AuthResult.error('Erro desconhecido no login');
      }
    } on AuthException catch (e) {
      return AuthResult.error(_getAuthErrorMessage(e.message));
    } catch (e) {
      return AuthResult.error('Erro de conexão. Verifique sua internet.');
    }
  }

  /// Realiza cadastro com email, senha e nome
  static Future<AuthResult> signUp({
    required String email,
    required String password,
    required String nome,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email.trim(),
        password: password,
        data: {
          'nome': nome.trim(),
        },
      );

      if (response.user != null) {
        return AuthResult.success(AppUser.fromSupabase(response.user!));
      } else {
        return AuthResult.error('Erro desconhecido no cadastro');
      }
    } on AuthException catch (e) {
      // Se o usuário já existe, tenta fazer login automaticamente
      if (e.message.toLowerCase().contains('user already registered') ||
          e.message.toLowerCase().contains('already registered')) {
        return await signIn(email, password);
      }
      return AuthResult.error(_getAuthErrorMessage(e.message));
    } catch (e) {
      return AuthResult.error('Erro de conexão. Verifique sua internet.');
    }
  }

  /// Realiza logout
  static Future<AuthResult> signOut() async {
    try {
      await _supabase.auth.signOut();
      return AuthResult(success: true);
    } catch (e) {
      return AuthResult.error('Erro ao fazer logout');
    }
  }

  /// Envia email de recuperação de senha
  static Future<AuthResult> resetPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email.trim());
      return AuthResult(success: true);
    } on AuthException catch (e) {
      return AuthResult.error(_getAuthErrorMessage(e.message));
    } catch (e) {
      return AuthResult.error('Erro de conexão. Verifique sua internet.');
    }
  }

  /// Atualiza dados do usuário
  static Future<AuthResult> updateUser({
    String? nome,
    String? email,
    String? password,
  }) async {
    try {
      final attributes = UserAttributes();
      
      if (email != null) attributes.email = email.trim();
      if (password != null) attributes.password = password;
      
      Map<String, dynamic>? data;
      if (nome != null) {
        data = {'nome': nome.trim()};
        attributes.data = data;
      }

      final response = await _supabase.auth.updateUser(attributes);

      if (response.user != null) {
        return AuthResult.success(AppUser.fromSupabase(response.user!));
      } else {
        return AuthResult.error('Erro ao atualizar dados');
      }
    } on AuthException catch (e) {
      return AuthResult.error(_getAuthErrorMessage(e.message));
    } catch (e) {
      return AuthResult.error('Erro de conexão. Verifique sua internet.');
    }
  }

  /// Converte mensagens de erro do Supabase para português
  static String _getAuthErrorMessage(String error) {
    final errorLower = error.toLowerCase();
    
    if (errorLower.contains('invalid login credentials') || 
        errorLower.contains('invalid email or password')) {
      return 'Email ou senha incorretos';
    }
    if (errorLower.contains('email not confirmed')) {
      return 'Email não confirmado. Verifique sua caixa de entrada';
    }
    if (errorLower.contains('user already registered') || 
        errorLower.contains('already registered')) {
      return 'Este email já está cadastrado';
    }
    if (errorLower.contains('password should be at least 6 characters')) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    if (errorLower.contains('signup is disabled')) {
      return 'Cadastro desabilitado. Entre em contato com o suporte';
    }
    if (errorLower.contains('email address is invalid')) {
      return 'Endereço de email inválido';
    }
    if (errorLower.contains('password is too weak')) {
      return 'Senha muito fraca. Use letras, números e símbolos';
    }
    if (errorLower.contains('email rate limit exceeded')) {
      return 'Muitas tentativas. Aguarde alguns minutos';
    }
    if (errorLower.contains('invalid refresh token') || 
        errorLower.contains('refresh token not found')) {
      return 'Sessão expirada. Faça login novamente';
    }
    
    // Retorna o erro original se não conseguiu mapear
    return error.isNotEmpty ? error : 'Erro desconhecido';
  }

  /// Valida formato de email
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// Valida força da senha
  static bool isValidPassword(String password) {
    // Pelo menos 6 caracteres, uma letra e um número
    return password.length >= 6 &&
        RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(password);
  }

  /// Retorna score da força da senha (0-4)
  static int getPasswordStrength(String password) {
    int score = 0;
    
    if (password.length >= 6) score++;
    if (password.length >= 8) score++;
    if (RegExp(r'[a-z]').hasMatch(password) && RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;
    
    return score > 4 ? 4 : score;
  }
}
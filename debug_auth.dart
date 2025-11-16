import 'package:flutter/material.dart';
import 'package:rpg_app/services/auth_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:rpg_app/config/supabase_config.dart';

/// Script de debug para testar autenticação
/// Execute: flutter run debug_auth.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🔍 Iniciando debug de autenticação...\n');
  
  try {
    // Inicializa Supabase
    print('📡 Inicializando Supabase...');
    await Supabase.initialize(
      url: SupabaseConfig.url,
      anonKey: SupabaseConfig.anonKey,
      debug: true,
    );
    print('✅ Supabase inicializado com sucesso\n');

    // Verifica estado inicial
    print('🔍 Estado inicial:');
    final debugInfo = AuthService.getDebugInfo();
    debugInfo.forEach((key, value) {
      print('  $key: $value');
    });
    print('');

    // Teste de login com credenciais existentes
    print('🔑 Testando login...');
    const testEmail = 'teste@email.com';
    const testPassword = '123456';
    
    final loginResult = await AuthService.signIn(testEmail, testPassword);
    
    if (loginResult.success) {
      print('✅ Login realizado com sucesso!');
      print('   Email: ${loginResult.user?.email}');
      print('   Nome: ${loginResult.user?.nome}');
    } else {
      print('❌ Falha no login: ${loginResult.error}');
      
      // Se falhou, tenta cadastro
      print('\n📝 Testando cadastro...');
      final signupResult = await AuthService.signUp(
        email: testEmail,
        password: testPassword,
        nome: 'Usuário Teste',
      );
      
      if (signupResult.success) {
        print('✅ Cadastro realizado com sucesso!');
        print('   Email: ${signupResult.user?.email}');
        print('   Nome: ${signupResult.user?.nome}');
      } else {
        print('❌ Falha no cadastro: ${signupResult.error}');
      }
    }

    // Verifica estado final
    print('\n🔍 Estado final:');
    final finalDebugInfo = AuthService.getDebugInfo();
    finalDebugInfo.forEach((key, value) {
      print('  $key: $value');
    });

  } catch (e) {
    print('💥 Erro durante debug: $e');
  }
}
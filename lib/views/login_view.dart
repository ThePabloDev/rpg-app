import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../ui/screens/templates/app_template.dart';
import '../ui/atoms/rpg_text.dart';
import '../ui/atoms/rpg_text_field.dart';

/// View para login usando arquitetura MVVM
class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        // Se autenticado, navegar automaticamente
        if (authViewModel.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/inicial');
          });
        }

        return AppTemplate(
            title: 'Login',
            appBar: null, // Remove app bar para tela de login
            body: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo ou título do app
                    const Icon(
                      Icons.castle,
                      size: 80,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 16),
                    const RPGText(
                      'RPG Character Manager',
                      style: RPGTextStyle.title,
                      color: Colors.amber,
                    ),
                    const SizedBox(height: 8),
                    const RPGText(
                      'Gerencie seus personagens e magias',
                      style: RPGTextStyle.subtitle,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 32),

                    // Formulário de login
                    Card(
                      elevation: 8,
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            const RPGText(
                              'Entrar na sua conta',
                              style: RPGTextStyle.subtitle,
                            ),
                            const SizedBox(height: 24),

                            // Campo de email
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RPGTextField(
                                  controller: authViewModel.emailController,
                                  hintText: 'Email',
                                  prefixIcon: Icons.email,
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                if (authViewModel.emailError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      authViewModel.emailError!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Campo de senha
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RPGTextField(
                                  controller: authViewModel.passwordController,
                                  hintText: 'Senha',
                                  prefixIcon: Icons.lock,
                                  obscureText: !authViewModel.showPassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      authViewModel.showPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: authViewModel.togglePasswordVisibility,
                                  ),
                                ),
                                if (authViewModel.passwordError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      authViewModel.passwordError!,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Lembrar-me
                            Row(
                              children: [
                                Checkbox(
                                  value: authViewModel.rememberMe,
                                  onChanged: authViewModel.setRememberMe,
                                  activeColor: Colors.amber,
                                ),
                                const Text('Lembrar-me'),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    // TODO: Implementar recuperação de senha
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Função em desenvolvimento'),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Esqueci minha senha',
                                    style: TextStyle(color: Colors.amber),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            // Botão de login
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: authViewModel.isLoading
                                    ? null
                                    : () => _handleLogin(context, authViewModel),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  foregroundColor: Colors.black,
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: authViewModel.isLoading
                                    ? const SizedBox(
                                        height: 20,
                                        width: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.black,
                                        ),
                                      )
                                    : const Text(
                                        'Entrar',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Link para cadastro
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Não tem uma conta? '),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/cadastro');
                                  },
                                  child: const Text(
                                    'Cadastre-se',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Botão de acesso offline
                    TextButton.icon(
                      onPressed: () {
                        authViewModel.loginOffline();
                        Navigator.pushReplacementNamed(context, '/inicial');
                      },
                      icon: const Icon(Icons.offline_bolt, color: Colors.grey),
                      label: const Text(
                        'Continuar offline',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
    );
  }

  Future<void> _handleLogin(BuildContext context, AuthViewModel authViewModel) async {
    final success = await authViewModel.login();
    if (context.mounted) {
      if (success) {
        Navigator.pushReplacementNamed(context, '/inicial');
      } else if (authViewModel.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(authViewModel.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
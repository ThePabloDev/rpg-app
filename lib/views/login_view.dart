import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

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

        return Scaffold(
          backgroundColor: const Color(0xFF0A0A0A),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF1A0E2E),
                  const Color(0xFF0A0A0A),
                ],
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo melhorado
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.amber.withValues(alpha: 0.3),
                            Colors.transparent,
                          ],
                        ),
                      ),
                      child: const Icon(
                        Icons.casino,
                        size: 100,
                        color: Colors.amber,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Título do app
                    ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: [Colors.amber, Colors.orange],
                      ).createShader(bounds),
                      child: const Text(
                        'Ficha do Zé',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Seu companheiro de RPG',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade400,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 48),

                    // Card de Login Estilizado
                    Container(
                      constraints: const BoxConstraints(maxWidth: 400),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            const Color(0xFF2A1A3E),
                            const Color(0xFF1A0E2E),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.amber.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32),
                        child: Column(
                          children: [
                            // Título da seção
                            const Text(
                              'Entrar',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber,
                              ),
                            ),
                            const SizedBox(height: 32),

                            // Campo de email
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xFF1A0E2E),
                                    border: Border.all(
                                      color: Colors.amber.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: authViewModel.emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'Email',
                                      hintStyle: TextStyle(color: Colors.grey.shade400),
                                      prefixIcon: const Icon(Icons.email, color: Colors.amber),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                if (authViewModel.emailError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8, left: 16),
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
                            const SizedBox(height: 20),

                            // Campo de senha
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    color: const Color(0xFF1A0E2E),
                                    border: Border.all(
                                      color: Colors.amber.withValues(alpha: 0.3),
                                    ),
                                  ),
                                  child: TextFormField(
                                    controller: authViewModel.passwordController,
                                    obscureText: !authViewModel.showPassword,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'Senha',
                                      hintStyle: TextStyle(color: Colors.grey.shade400),
                                      prefixIcon: const Icon(Icons.lock, color: Colors.amber),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          authViewModel.showPassword
                                              ? Icons.visibility_off
                                              : Icons.visibility,
                                          color: Colors.amber,
                                        ),
                                        onPressed: authViewModel.togglePasswordVisibility,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16,
                                        vertical: 16,
                                      ),
                                    ),
                                  ),
                                ),
                                if (authViewModel.passwordError != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8, left: 16),
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
                            const SizedBox(height: 16),

                            // Lembrar-me
                            Row(
                              children: [
                                Checkbox(
                                  value: authViewModel.rememberMe,
                                  onChanged: authViewModel.setRememberMe,
                                  activeColor: Colors.amber,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                Text(
                                  'Lembrar-me',
                                  style: TextStyle(color: Colors.grey.shade300),
                                ),
                                const Spacer(),
                                TextButton(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Em breve...'),
                                        backgroundColor: Colors.amber,
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'Esqueci minha senha',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 32),

                            // Botão de login estilizado
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: const LinearGradient(
                                  colors: [Colors.amber, Colors.orange],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.amber.withValues(alpha: 0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ElevatedButton(
                                onPressed: authViewModel.isLoading
                                    ? null
                                    : () => _handleLogin(context, authViewModel),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(vertical: 18),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: authViewModel.isLoading
                                    ? const SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                        ),
                                      )
                                    : const Text(
                                        'ENTRAR',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Link para cadastro estilizado
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Novo por aqui? ',
                                  style: TextStyle(color: Colors.grey.shade400),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/cadastro');
                                  },
                                  child: const Text(
                                    'Criar conta',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Acesso offline discreto
                    TextButton.icon(
                      onPressed: () {
                        authViewModel.loginOffline();
                        Navigator.pushReplacementNamed(context, '/inicial');
                      },
                      icon: Icon(
                        Icons.offline_bolt,
                        color: Colors.grey.shade600,
                        size: 18,
                      ),
                      label: Text(
                        'Modo offline',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../ui/screens/templates/app_template.dart';
import '../ui/atoms/rpg_text.dart';
import '../ui/atoms/rpg_text_field.dart';

/// View para cadastro usando arquitetura MVVM
class CadastroView extends StatelessWidget {
  const CadastroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return AppTemplate(
          title: 'Cadastro',
          body: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo ou título do app
                  const Icon(
                    Icons.person_add,
                    size: 80,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 16),
                  const RPGText(
                    'Criar Nova Conta',
                    style: RPGTextStyle.title,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 8),
                  const RPGText(
                    'Preencha os dados para criar sua conta',
                    style: RPGTextStyle.subtitle,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 32),

                  // Formulário de cadastro
                  Card(
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const RPGText(
                            'Dados da Conta',
                            style: RPGTextStyle.subtitle,
                          ),
                          const SizedBox(height: 24),

                          // Campo de nome
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RPGTextField(
                                controller: authViewModel.nameController,
                                hintText: 'Nome completo',
                                prefixIcon: Icons.person,
                                keyboardType: TextInputType.name,
                              ),
                              if (authViewModel.nameError != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    authViewModel.nameError!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 16),

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
                                hintText: 'Senha (mínimo 6 caracteres)',
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
                          const SizedBox(height: 16),

                          // Campo de confirmação de senha
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RPGTextField(
                                controller: authViewModel.confirmPasswordController,
                                hintText: 'Confirmar senha',
                                prefixIcon: Icons.lock_outline,
                                obscureText: !authViewModel.showPassword,
                              ),
                              if (authViewModel.confirmPasswordError != null)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Text(
                                    authViewModel.confirmPasswordError!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 24),

                          // Botão de cadastro
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: authViewModel.isLoading
                                  ? null
                                  : () => _handleRegister(context, authViewModel),
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
                                      'Criar Conta',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Link para login
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Já tem uma conta? '),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  'Fazer Login',
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

                  // Termos de uso
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      'Ao criar uma conta, você concorda com nossos Termos de Uso e Política de Privacidade',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
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

  Future<void> _handleRegister(BuildContext context, AuthViewModel authViewModel) async {
    // Limpar campos de login para não interferir na validação
    final email = authViewModel.emailController.text;
    final password = authViewModel.passwordController.text;
    final name = authViewModel.nameController.text;
    final confirmPassword = authViewModel.confirmPasswordController.text;

    final success = await authViewModel.register(name, email, password, confirmPassword);
    
    if (context.mounted) {
      if (success) {
        // Limpar campos após cadastro bem sucedido
        authViewModel.nameController.clear();
        authViewModel.emailController.clear();
        authViewModel.passwordController.clear();
        authViewModel.confirmPasswordController.clear();
        
        // Mostrar sucesso e voltar para login
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Conta criada com sucesso! Você será redirecionado para a tela inicial.'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Aguardar um pouco e navegar para tela inicial
        await Future.delayed(const Duration(seconds: 1));
        if (context.mounted) {
          Navigator.pushReplacementNamed(context, '/inicial');
        }
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
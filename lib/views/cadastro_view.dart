import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class CadastroView extends StatelessWidget {
  const CadastroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, child) {
        return Scaffold(
          backgroundColor: const Color(0xFF0A0A0A),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.amber),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFF0A0A0A),
                  const Color(0xFF1A1A1A),
                  const Color(0xFF2A1A3E),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          
                          // Header
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.amber.withValues(alpha: 0.1),
                                  Colors.amber.withValues(alpha: 0.05),
                                ],
                              ),
                              border: Border.all(
                                color: Colors.amber.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.amber.shade400,
                                        Colors.amber.shade600,
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.amber.withValues(alpha: 0.3),
                                        blurRadius: 15,
                                        offset: const Offset(0, 5),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.person_add,
                                    size: 40,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Ficha do Zé',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Crie sua conta para começar',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Card de Cadastro
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
                                    'Dados da Conta',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  const SizedBox(height: 32),

                                  // Campo de nome
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
                                          controller: authViewModel.nameController,
                                          keyboardType: TextInputType.name,
                                          style: const TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                            hintText: 'Nome completo',
                                            hintStyle: TextStyle(color: Colors.grey.shade400),
                                            prefixIcon: const Icon(Icons.person, color: Colors.amber),
                                            border: InputBorder.none,
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (authViewModel.nameError != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8, left: 16),
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
                                  const SizedBox(height: 20),

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
                                            hintText: 'Senha (mínimo 6 caracteres)',
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
                                  const SizedBox(height: 20),

                                  // Campo de confirmação de senha
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
                                          controller: authViewModel.confirmPasswordController,
                                          obscureText: !authViewModel.showPassword,
                                          style: const TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                            hintText: 'Confirmar senha',
                                            hintStyle: TextStyle(color: Colors.grey.shade400),
                                            prefixIcon: const Icon(Icons.lock_outline, color: Colors.amber),
                                            border: InputBorder.none,
                                            contentPadding: const EdgeInsets.symmetric(
                                              horizontal: 16,
                                              vertical: 16,
                                            ),
                                          ),
                                        ),
                                      ),
                                      if (authViewModel.confirmPasswordError != null)
                                        Padding(
                                          padding: const EdgeInsets.only(top: 8, left: 16),
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
                                  const SizedBox(height: 32),

                                  // Botão de cadastro
                                  Container(
                                    width: double.infinity,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: LinearGradient(
                                        colors: [
                                          Colors.amber.shade400,
                                          Colors.amber.shade600,
                                        ],
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.amber.withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: authViewModel.isLoading
                                            ? null
                                            : () => _handleRegister(context, authViewModel),
                                        child: Container(
                                          alignment: Alignment.center,
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
                                                    color: Colors.black,
                                                  ),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Link para login
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Já tem uma conta? ',
                                        style: TextStyle(color: Colors.grey),
                                      ),
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
    
    if (success && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } else if (context.mounted && authViewModel.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(authViewModel.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
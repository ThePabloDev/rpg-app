import 'package:flutter/material.dart';
import '../atoms/app_colors.dart';
import '../atoms/text_atom.dart';
import '../atoms/icon_atom.dart';
import 'package:google_fonts/google_fonts.dart';

class AuthFormCard extends StatefulWidget {
  const AuthFormCard({Key? key}) : super(key: key);

  @override
  _AuthFormCardState createState() => _AuthFormCardState();
}

class _AuthFormCardState extends State<AuthFormCard> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  double _cardScale = 1.0;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Aventureiro criado com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context, true);
    } else {
      // microfeedback: vibrate-like visual by quick scale
      setState(() {
        _cardScale = 0.98;
      });
      Future.delayed(const Duration(milliseconds: 120), () {
        setState(() {
          _cardScale = 1.0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      label: 'Formulário de cadastro de aventureiro',
      child: AnimatedScale(
        scale: _cardScale,
        duration: const Duration(milliseconds: 160),
        curve: Curves.easeOut,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary, width: 2),
            boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: Offset(0,4))],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextAtom(
                  'Criar Aventureiro',
                  style: GoogleFonts.cinzel(
                    textStyle: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Nome
                TextFormField(
                  controller: _nomeController,
                  style: const TextStyle(color: AppColors.textHigh),
                  decoration: InputDecoration(
                    labelText: 'Nome do Aventureiro',
                    labelStyle: const TextStyle(color: AppColors.primary),
                    prefixIcon: const IconAtom(icon: Icons.person, semanticsLabel: 'Ícone pessoa', color: AppColors.primary, size: 20),
                    filled: true,
                    fillColor: AppColors.background.withOpacity(0.06),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu nome';
                    }
                    if (value.length < 2) {
                      return 'Nome deve ter pelo menos 2 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                // Email
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: AppColors.textHigh),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: AppColors.primary),
                    prefixIcon: const IconAtom(icon: Icons.email, semanticsLabel: 'Ícone email', color: AppColors.primary, size: 20),
                    filled: true,
                    fillColor: AppColors.background.withOpacity(0.06),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu email';
                    }
                    if (!value.contains('@')) {
                      return 'Por favor, insira um email válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                // Senha
                TextFormField(
                  controller: _senhaController,
                  obscureText: _obscurePassword,
                  style: const TextStyle(color: AppColors.textHigh),
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    labelStyle: const TextStyle(color: AppColors.primary),
                    prefixIcon: const IconAtom(icon: Icons.lock, semanticsLabel: 'Ícone senha', color: AppColors.primary, size: 20),
                    suffixIcon: IconButton(
                      tooltip: _obscurePassword ? 'Mostrar senha' : 'Ocultar senha',
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off, color: AppColors.primary),
                    ),
                    filled: true,
                    fillColor: AppColors.background.withOpacity(0.06),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha';
                    }
                    if (value.length < 6) {
                      return 'A senha deve ter pelo menos 6 caracteres';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12),
                // Confirmar senha
                TextFormField(
                  controller: _confirmarSenhaController,
                  obscureText: _obscureConfirmPassword,
                  style: const TextStyle(color: AppColors.textHigh),
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    labelStyle: const TextStyle(color: AppColors.primary),
                    prefixIcon: const IconAtom(icon: Icons.lock_outline, semanticsLabel: 'Ícone confirmar senha', color: AppColors.primary, size: 20),
                    suffixIcon: IconButton(
                      tooltip: _obscureConfirmPassword ? 'Mostrar senha' : 'Ocultar senha',
                      onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                      icon: Icon(_obscureConfirmPassword ? Icons.visibility : Icons.visibility_off, color: AppColors.primary),
                    ),
                    filled: true,
                    fillColor: AppColors.background.withOpacity(0.06),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirme sua senha';
                    }
                    if (value != _senhaController.text) {
                      return 'As senhas não coincidem';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                // Botão com microinteração de toque
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _onSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                    ),
                    child: const Text('CRIAR AVENTUREIRO', style: TextStyle(color: AppColors.surface, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Já tem uma conta? Faça login', style: TextStyle(color: AppColors.primary)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

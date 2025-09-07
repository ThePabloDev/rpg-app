import 'package:flutter/material.dart';
import '../molecules/rpg_form_field.dart';
import '../molecules/rpg_action_button.dart';
import '../molecules/rpg_login_form.dart';
import '../atoms/rpg_button.dart';

class RegisterFormOrganism extends StatefulWidget {
  final VoidCallback onRegister;
  final VoidCallback onNavigateToLogin;

  const RegisterFormOrganism({
    super.key,
    required this.onRegister,
    required this.onNavigateToLogin,
  });

  @override
  State<RegisterFormOrganism> createState() => _RegisterFormOrganismState();
}

class _RegisterFormOrganismState extends State<RegisterFormOrganism> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      widget.onRegister();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RPGLoginForm(
      formKey: _formKey,
      title: "Criar Conta",
      fields: [
        RPGFormField(
          label: 'Email',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          prefixIcon: Icons.email,
          semanticLabel: 'Campo de email',
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
        RPGFormField(
          label: 'Senha',
          controller: _senhaController,
          obscureText: true,
          prefixIcon: Icons.lock,
          semanticLabel: 'Campo de senha',
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
        RPGFormField(
          label: 'Confirmar Senha',
          controller: _confirmarSenhaController,
          obscureText: true,
          prefixIcon: Icons.lock_outline,
          semanticLabel: 'Campo de confirmar senha',
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
      ],
      actions: [
        RPGActionButton(
          text: 'CADASTRAR',
          onPressed: _handleRegister,
          semanticLabel: 'Botão cadastrar',
        ),
        const SizedBox(height: 10),
        RPGActionButton(
          text: 'Já tem conta? Faça login',
          onPressed: widget.onNavigateToLogin,
          type: RPGButtonType.text,
          width: null,
        ),
      ],
    );
  }
}

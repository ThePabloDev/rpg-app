import 'package:flutter/material.dart';
import '../molecules/rpg_form_field.dart';
import '../molecules/rpg_action_button.dart';
import '../molecules/rpg_login_form.dart';
import '../atoms/rpg_button.dart';

class LoginFormOrganism extends StatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback onNavigateToRegister;

  const LoginFormOrganism({
    super.key,
    required this.onLogin,
    required this.onNavigateToRegister,
  });

  @override
  State<LoginFormOrganism> createState() => _LoginFormOrganismState();
}

class _LoginFormOrganismState extends State<LoginFormOrganism> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      widget.onLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RPGLoginForm(
      formKey: _formKey,
      title: "Entrar na Aventura",
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
      ],
      actions: [
        RPGActionButton(
          text: 'ENTRAR',
          onPressed: _handleLogin,
          semanticLabel: 'Botão entrar',
        ),
        const SizedBox(height: 10),
        RPGActionButton(
          text: 'Não tem uma conta? Cadastre-se',
          onPressed: widget.onNavigateToRegister,
          type: RPGButtonType.text,
          width: null,
        ),
      ],
    );
  }
}

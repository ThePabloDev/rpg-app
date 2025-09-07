import 'package:flutter/material.dart';
import '../ui/screens/templates/auth_template.dart';
import '../ui/organisms/login_form_organism.dart';
import 'tela_cadastro.dart';
import 'tela_inicial.dart';

class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      child: LoginFormOrganism(
        onLogin: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const TelaInicial(),
            ),
            (route) => false,
          );
        },
        onNavigateToRegister: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TelaCadastro()),
          );
          if (result == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cadastro realizado! Faça login.'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../ui/screens/templates/auth_template.dart';
import '../ui/organisms/register_form_organism.dart';

class TelaCadastro extends StatelessWidget {
  const TelaCadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return AuthTemplate(
      child: RegisterFormOrganism(
        onRegister: () {
          Navigator.pop(context, true);
        },
        onNavigateToLogin: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

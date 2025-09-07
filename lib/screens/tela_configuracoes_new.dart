import 'package:flutter/material.dart';
import '../ui/screens/templates/app_template.dart';
import '../ui/molecules/rpg_action_button.dart';
import '../ui/atoms/rpg_button.dart';
import 'tela_login.dart';

class TelaConfiguracoes extends StatelessWidget {
  const TelaConfiguracoes({super.key});

  @override
  Widget build(BuildContext context) {
    return AppTemplate(
      title: 'Configurações',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Spacer(),
            RPGActionButton(
              text: 'SAIR',
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const TelaLogin()),
                  (route) => false,
                );
              },
              type: RPGButtonType.outlined,
              icon: Icons.exit_to_app,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

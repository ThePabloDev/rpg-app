import 'package:flutter/material.dart';
import '../views/criacao_personagem_view.dart';

/// Wrapper para manter compatibilidade com navegação antiga
/// Redireciona para a nova CriacaoPersonagemView com arquitetura MVVM
class TelaCriacaoPersonagem extends StatelessWidget {
  const TelaCriacaoPersonagem({super.key});

  @override
  Widget build(BuildContext context) {
    return const CriacaoPersonagemView();
  }
}

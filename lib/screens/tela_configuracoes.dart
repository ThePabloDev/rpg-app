import 'package:flutter/material.dart';
import '../views/configuracoes_view.dart';

/// Wrapper para manter compatibilidade - redireciona para a nova ConfiguracoesView (MVVM)
class TelaConfiguracoes extends StatelessWidget {
  const TelaConfiguracoes({super.key});

  @override
  Widget build(BuildContext context) {
    return const ConfiguracoesView();
  }
}

import 'package:flutter/material.dart';
import '../views/lista_personagens_view.dart';

/// Wrapper para manter compatibilidade com navegação antiga
/// Redireciona para a nova ListaPersonagensView com arquitetura MVVM
class TelaListaPersonagens extends StatelessWidget {
  const TelaListaPersonagens({super.key});

  @override
  Widget build(BuildContext context) {
    return const ListaPersonagensView();
  }
}

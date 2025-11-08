import 'package:flutter/material.dart';
import '../views/cadastro_view.dart';

/// Wrapper para manter compatibilidade - redireciona para a nova CadastroView (MVVM)
class TelaCadastro extends StatelessWidget {
  const TelaCadastro({super.key});

  @override
  Widget build(BuildContext context) {
    return const CadastroView();
  }
}

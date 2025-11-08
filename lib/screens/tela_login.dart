import 'package:flutter/material.dart';
import '../views/login_view.dart';

/// Wrapper para manter compatibilidade - redireciona para a nova LoginView (MVVM)
class TelaLogin extends StatelessWidget {
  const TelaLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginView();
  }
}
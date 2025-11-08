import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'splash_screen.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/magias_viewmodel.dart';
import 'viewmodels/configuracoes_viewmodel.dart';
import 'viewmodels/personagem_viewmodel.dart';
import 'screens/tela_login.dart';
import 'screens/tela_cadastro.dart';
import 'screens/tela_inicial.dart';
import 'screens/tela_criacao_personagem.dart';
import 'screens/tela_lista_personagens.dart';
// New MVVM views
import 'views/login_view.dart';
import 'views/cadastro_view.dart';
import 'views/magias_view.dart';
import 'views/configuracoes_view.dart';
import 'views/criacao_personagem_view.dart';
import 'views/lista_personagens_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => MagiasViewModel()),
        ChangeNotifierProvider(create: (_) => ConfiguracoesViewModel()),
        ChangeNotifierProvider(create: (_) => PersonagemViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'RPG D&D 5E',
        theme: ThemeData.dark(),
        home: const SplashScreen(),
        routes: {
          '/login': (context) => const TelaLogin(),
          '/cadastro': (context) => const TelaCadastro(),
          '/inicial': (context) => const TelaInicial(),
          '/tela_criacao_personagem': (context) => const TelaCriacaoPersonagem(),
          '/tela_lista_personagens': (context) => const TelaListaPersonagens(),
          // New MVVM routes (keep old screens for compatibility)
          '/mvvm/login': (context) => const LoginView(),
          '/mvvm/cadastro': (context) => const CadastroView(),
          '/magias': (context) => const MagiasView(),
          '/configuracoes': (context) => const ConfiguracoesView(),
          '/criacao_personagem': (context) => const CriacaoPersonagemView(),
          '/lista_personagens': (context) => const ListaPersonagensView(),
        },
      ),
    );
  }
}

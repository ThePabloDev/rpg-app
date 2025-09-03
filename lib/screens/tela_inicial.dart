import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tela_criacao_personagem.dart';
import 'tela_lista_personagens.dart';
import 'tela_configuracoes.dart';


class TelaInicial extends StatefulWidget {
  const TelaInicial({super.key});

  @override
  State<TelaInicial> createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {
  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[
    TelaListaPersonagens(),
    TelaCriacaoPersonagem(),
    TelaConfiguracoes(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black.withOpacity(0.95),
        selectedItemColor: Colors.amber,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Personagens',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline),
            label: 'Criar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Configurações',
          ),
        ],
      ),
    );
  }
}
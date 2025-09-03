import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaListaPersonagens extends StatelessWidget {
  const TelaListaPersonagens({super.key});

  @override
  Widget build(BuildContext context) {
    // Em breve: lista real de personagens
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Personagens', style: GoogleFonts.cinzel()),
        backgroundColor: Colors.black.withOpacity(0.85),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Nenhum personagem criado ainda.', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

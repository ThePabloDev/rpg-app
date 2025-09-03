import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TelaConfiguracoes extends StatelessWidget {
  const TelaConfiguracoes({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações', style: GoogleFonts.cinzel()),
        backgroundColor: Colors.black.withOpacity(0.85),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('', style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

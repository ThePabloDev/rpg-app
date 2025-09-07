import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../atoms/rpg_background.dart';

class AppTemplate extends StatelessWidget {
  final String title;
  final Widget body;
  final Color? backgroundColor;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;

  const AppTemplate({
    super.key,
    required this.title,
    required this.body,
    this.backgroundColor,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar ?? AppBar(
        title: Text(title, style: GoogleFonts.cinzel()),
        backgroundColor: Colors.black.withValues(alpha: 0.85),
        centerTitle: true,
        foregroundColor: Colors.amber,
      ),
      body: RPGBackground(
        backgroundColor: backgroundColor ?? Colors.black,
        backgroundImage: null,
        overlayOpacity: 0.1,
        child: body,
      ),
      bottomNavigationBar: bottomNavigationBar,
      floatingActionButton: floatingActionButton,
    );
  }
}

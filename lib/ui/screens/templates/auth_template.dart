import 'package:flutter/material.dart';
import '../../atoms/rpg_background.dart';

class AuthTemplate extends StatelessWidget {
  final Widget child;
  final String? backgroundImage;

  const AuthTemplate({
    super.key,
    required this.child,
    this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: RPGBackground(
          backgroundImage: backgroundImage,
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

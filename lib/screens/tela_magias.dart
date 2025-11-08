import 'package:flutter/material.dart';
import '../views/magias_view.dart';

/// Wrapper para manter compatibilidade - redireciona para a nova MagiasView (MVVM)
class TelaMagias extends StatelessWidget {
  const TelaMagias({super.key});

  @override
  Widget build(BuildContext context) {
    return const MagiasView();
  }
}

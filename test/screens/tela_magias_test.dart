import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rpg_app/screens/tela_magias.dart';

void main() {
  group('TelaMagias - Testes de Widget', () {
    testWidgets('TW-03: Deve exibir loading ao carregar magias inicialmente', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: TelaMagias(),
        ),
      );
      
      // Assert - Verifica se mostra loading inicialmente
      expect(find.byType(CircularProgressIndicator), findsAtLeast(1));
    });

    testWidgets('TW-04: Deve exibir botão de filtros na tela de magias', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: TelaMagias(),
        ),
      );
      
      // Act - Espera carregamento inicial
      await tester.pump(Duration(seconds: 1));
      
      // Assert - Verifica se há elementos de filtro disponíveis
      expect(find.byIcon(Icons.filter_list), findsAtLeast(1));
    });
  });
}
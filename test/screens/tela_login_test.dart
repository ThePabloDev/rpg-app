import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rpg_app/screens/tela_login.dart';

void main() {
  group('TelaLogin - Testes de Widget', () {
    testWidgets('TW-01: Deve exibir elementos da tela de login corretamente', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: TelaLogin(),
        ),
      );
      
      // Assert
      expect(find.text('Entrar na Aventura'), findsOneWidget);
      expect(find.byType(TextFormField), findsAtLeast(2)); // Email e senha
      expect(find.text('ENTRAR'), findsOneWidget); // Botão de login
      expect(find.text('Não tem uma conta? Cadastre-se'), findsOneWidget);
    });

    testWidgets('TW-02: Deve navegar para tela de cadastro ao tocar em cadastrar', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: TelaLogin(),
        ),
      );
      
      // Act
      await tester.tap(find.text('Não tem uma conta? Cadastre-se'));
      await tester.pumpAndSettle(); // Espera a navegação completar
      
      // Assert
      // Verifica se navega para uma nova tela (mudança de contexto)
      expect(find.text('Entrar na Aventura'), findsNothing);
    });
  });
}
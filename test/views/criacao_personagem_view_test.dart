import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:rpg_app/viewmodels/personagem_viewmodel.dart';
import 'package:rpg_app/views/criacao_personagem_view.dart';

void main() {
  group('CriacaoPersonagemView - Testes MVVM', () {
    testWidgets('TW-05: Deve exibir formulário de criação de personagem', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => PersonagemViewModel(),
            child: const CriacaoPersonagemView(),
          ),
        ),
      );
      
      // Assert - Verifica se os elementos principais estão presentes
      expect(find.text('Criar Personagem'), findsAtLeast(1)); // Pode estar no AppBar e botão
      expect(find.text('Informações Básicas'), findsOneWidget);
      expect(find.text('Atributos'), findsOneWidget);
      expect(find.byType(TextFormField), findsAtLeast(1)); // Nome do personagem
      expect(find.byType(DropdownButtonFormField<String>), findsAtLeast(2)); // Classe e Raça
    });

    testWidgets('TW-06: Deve exibir sliders para atributos', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => PersonagemViewModel(),
            child: const CriacaoPersonagemView(),
          ),
        ),
      );
      
      // Assert - Verifica se os atributos estão presentes
      expect(find.text('Força'), findsOneWidget);
      expect(find.text('Destreza'), findsOneWidget);
      expect(find.text('Constituição'), findsOneWidget);
      expect(find.text('Inteligência'), findsOneWidget);
      expect(find.text('Sabedoria'), findsOneWidget);
      expect(find.text('Carisma'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsAtLeast(6)); // Botões + para aumentar atributos
      expect(find.byIcon(Icons.remove), findsAtLeast(6)); // Botões - para diminuir atributos
    });

    testWidgets('TW-07: Deve exibir botões de ação', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => PersonagemViewModel(),
            child: const CriacaoPersonagemView(),
          ),
        ),
      );
      
      // Assert - Verifica se os botões estão presentes
      expect(find.text('Limpar'), findsOneWidget);
      expect(find.text('Criar Personagem'), findsAtLeast(1)); // Pode estar no título e botão
      expect(find.text('Rolar'), findsOneWidget); // Botão de rolar atributos
    });

    testWidgets('TW-08: Deve interagir com campo de nome', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: ChangeNotifierProvider(
            create: (_) => PersonagemViewModel(),
            child: const CriacaoPersonagemView(),
          ),
        ),
      );
      
      // Act - Encontra o campo de nome e digita
      final nomeField = find.byType(TextFormField).first;
      await tester.tap(nomeField);
      await tester.enterText(nomeField, 'Gandalf');
      await tester.pump();
      
      // Assert - Verifica se o texto foi inserido
      expect(find.text('Gandalf'), findsOneWidget);
    });
  });
}
// This is a basic Flutter widget test for RPG App.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:rpg_app/screens/tela_login.dart';

void main() {
  testWidgets('RPG App components smoke test', (WidgetTester tester) async {
    // Build a simple component and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: TelaLogin(),
      ),
    );

    // Verify that a basic component loads properly
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('Entrar na Aventura'), findsOneWidget);
  });
}

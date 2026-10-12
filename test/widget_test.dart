// Teste basico da navegacao por abas.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_2/main.dart';

void main() {
  testWidgets('Navega entre as tres abas', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // A aba Inicio comeca selecionada.
    expect(find.text('Bem-vindo ao nosso aplicativo!'), findsOneWidget);

    // Vai para Noticias.
    await tester.tap(find.byIcon(Icons.article));
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsWidgets);

    // Vai para Perfil.
    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();
    expect(find.text('Pedro Henrique'), findsOneWidget);
  });
}

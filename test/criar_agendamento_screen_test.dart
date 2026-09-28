import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_final/app/theme.dart';
import 'package:projeto_final/features/home/screens/criar_agendamento_screen.dart';

void main() {
  Widget app() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const CriarAgendamentoScreen(),
    );
  }

  void telaDeCelular(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  testWidgets('agendar com o formulário vazio mostra os erros', (tester) async {
    telaDeCelular(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Agendar'));
    await tester.pumpAndSettle();

    expect(find.text('Selecione a especialidade'), findsOneWidget);
    expect(find.text('Selecione o profissional'), findsWidgets);
    expect(find.text('Selecione a data'), findsOneWidget);
    expect(find.text('Selecione o horário'), findsOneWidget);
  });

  testWidgets('a lista de profissionais depende da especialidade',
      (tester) async {
    telaDeCelular(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Selecione a especialidade médica'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Oftalmologia').last);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Selecione o profissional'));
    await tester.pumpAndSettle();

    expect(find.text('Dr. Tom Holland'), findsWidgets);
    expect(find.text('Dr. Carlos Lima'), findsNothing);
  });
}

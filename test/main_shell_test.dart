import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_final/app/theme.dart';
import 'package:projeto_final/core/models/perfil.dart';
import 'package:projeto_final/core/models/usuario.dart';
import 'package:projeto_final/features/shell/screens/main_shell_screen.dart';
import 'package:projeto_final/services/perfil_service.dart';

/// A aba Perfil busca os dados na API; nos testes usamos dados fixos.
class _PerfilServiceFake extends PerfilService {
  @override
  Future<Perfil> buscarPerfil() async => const Perfil(
        usuario: Usuario(
          idUsuario: 1,
          nome: 'Kauan Santos',
          email: 'kauansnts@email.com',
          papel: PapelUsuario.paciente,
        ),
        telefone: '(12)99775-6565',
      );
}

void main() {
  final perfilOriginal = PerfilService.instance;

  setUp(() => PerfilService.instance = _PerfilServiceFake());
  tearDown(() => PerfilService.instance = perfilOriginal);

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
      home: const MainShellScreen(),
    );
  }

  void telaDeCelular(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  testWidgets('abre na Home e só ela aparece', (tester) async {
    telaDeCelular(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    expect(find.text('Meus agendamentos'), findsOneWidget);
    expect(find.text('Últimas consultas'), findsNothing);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('trocar de aba mostra a tela certa e esconde o botão "+"',
      (tester) async {
    telaDeCelular(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.history_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Últimas consultas'), findsOneWidget);
    expect(find.text('Meus agendamentos'), findsNothing);
    expect(find.byType(FloatingActionButton), findsNothing);
  });

  testWidgets('as abas preservam o estado e tocar na aba atual não recarrega',
      (tester) async {
    telaDeCelular(tester);
    await tester.pumpWidget(app());
    await tester.pumpAndSettle();

    // Perfil: entra em modo de edição do telefone (vira ícone de "check").
    await tester.tap(find.byIcon(Icons.account_circle_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.edit).first);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check), findsOneWidget);

    // Tocar de novo na aba atual não reconstrói a tela: continua editando.
    await tester.tap(find.byIcon(Icons.account_circle_outlined));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check), findsOneWidget);

    // Ir para a Home e voltar também preserva o estado.
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.account_circle_outlined));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check), findsOneWidget);
  });
}

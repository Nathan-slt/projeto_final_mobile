import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_final/app/routes.dart';
import 'package:projeto_final/core/models/agendamento_detalhado.dart';
import 'package:projeto_final/features/auth/screens/cadastro_screen.dart';
import 'package:projeto_final/features/auth/screens/login_screen.dart';
import 'package:projeto_final/features/home/screens/criar_agendamento_screen.dart';
import 'package:projeto_final/features/shell/screens/main_shell_screen.dart';
import 'package:projeto_final/services/agendamento_service.dart';
import 'package:projeto_final/services/auth_service.dart';

class _AuthServiceFake extends AuthService {
  _AuthServiceFake(this.autenticado);

  final bool autenticado;

  @override
  bool get estaAutenticado => autenticado;
}

class _AgendamentoServiceFake extends AgendamentoService {
  @override
  Future<List<AgendamentoDetalhado>> listarMeus() async => [];
}

Widget _app(String destino) {
  return MaterialApp(
    locale: const Locale('pt', 'BR'),
    supportedLocales: const [Locale('pt', 'BR')],
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    onGenerateRoute: AppRoutes.onGenerateRoute,
    home: Scaffold(
      body: Builder(
        builder: (context) => Center(
          child: ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, destino),
            child: const Text('Abrir tela'),
          ),
        ),
      ),
    ),
  );
}

void main() {
  final authOriginal = AuthService.instance;
  final agendamentoOriginal = AgendamentoService.instance;

  setUp(() {
    AuthService.instance = _AuthServiceFake(false);
    AgendamentoService.instance = _AgendamentoServiceFake();
  });

  tearDown(() {
    AuthService.instance = authOriginal;
    AgendamentoService.instance = agendamentoOriginal;
  });

  testWidgets('sem login, acessar Home abre o login', (tester) async {
    await tester.pumpWidget(_app(AppRoutes.home));
    await tester.tap(find.text('Abrir tela'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(MainShellScreen), findsNothing);
  });

  testWidgets('sem login, acessar agendamento abre o login', (tester) async {
    await tester.pumpWidget(_app(AppRoutes.agendamento));
    await tester.tap(find.text('Abrir tela'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.byType(CriarAgendamentoScreen), findsNothing);
  });

  testWidgets('com sessão válida, a Home pode ser acessada', (tester) async {
    AuthService.instance = _AuthServiceFake(true);
    await tester.pumpWidget(_app(AppRoutes.home));
    await tester.tap(find.text('Abrir tela'));
    await tester.pumpAndSettle();

    expect(find.byType(MainShellScreen), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('cadastro continua acessível sem login', (tester) async {
    await tester.pumpWidget(_app(AppRoutes.cadastro));
    await tester.tap(find.text('Abrir tela'));
    await tester.pumpAndSettle();

    expect(find.byType(CadastroScreen), findsOneWidget);
  });
}
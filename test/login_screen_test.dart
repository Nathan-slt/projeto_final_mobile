import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_final/app/theme.dart';
import 'package:projeto_final/core/auth/sessao.dart';
import 'package:projeto_final/core/network/api_exception.dart';
import 'package:projeto_final/features/auth/screens/login_screen.dart';
import 'package:projeto_final/services/auth_service.dart';

class _AuthFalha extends AuthService {
  @override
  Future<Sessao> login({required String email, required String senha}) async {
    throw const ApiException('Email ou senha inválidos.', statusCode: 401);
  }
}

void main() {
  final authOriginal = AuthService.instance;
  tearDown(() => AuthService.instance = authOriginal);

  Widget app() {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }

  void telaDeCelular(WidgetTester tester) {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
  }

  testWidgets('entrar com o formulário vazio mostra os erros', (tester) async {
    telaDeCelular(tester);
    await tester.pumpWidget(app());

    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('Informe seu e-mail'), findsOneWidget);
    expect(find.text('Informe sua senha'), findsOneWidget);
  });

  testWidgets('e-mail sem formato válido é recusado', (tester) async {
    telaDeCelular(tester);
    await tester.pumpWidget(app());

    await tester.enterText(find.byType(TextFormField).first, 'sem-arroba');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('E-mail inválido'), findsOneWidget);
  });

  testWidgets('credenciais recusadas mostram a mensagem da API',
      (tester) async {
    AuthService.instance = _AuthFalha();
    telaDeCelular(tester);
    await tester.pumpWidget(app());

    await tester.enterText(find.byType(TextFormField).at(0), 'a@b.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'senha-errada');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('Email ou senha inválidos.'), findsOneWidget);
    // O botão volta ao normal (não fica travado em "carregando").
    expect(find.text('Entrar'), findsOneWidget);
  });
}

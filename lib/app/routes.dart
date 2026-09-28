import 'package:flutter/material.dart';
import 'package:projeto_final/features/auth/screens/cadastro_screen.dart';
import 'package:projeto_final/features/auth/screens/login_screen.dart';
import 'package:projeto_final/features/auth/screens/senha_screen.dart';
import 'package:projeto_final/features/home/screens/criar_agendamento_screen.dart';
import 'package:projeto_final/features/shell/screens/main_shell_screen.dart';
import 'package:projeto_final/features/splash/screens/splash_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String senha = '/senha';
  static const String cadastro = '/cadastro';

  /// Área logada: [MainShellScreen] com as abas Home, Histórico, Fila e Perfil.
  /// A troca entre as abas é feita dentro do shell (sem rotas nomeadas).
  static const String home = '/home';

  /// Tela empilhada por cima do shell (com botão de voltar).
  static const String agendamento = '/agendamento';

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        login: (context) => const LoginScreen(),
        senha: (context) => const SenhaScreen(),
        cadastro: (context) => const CadastroScreen(),
        home: (context) => const MainShellScreen(),
        agendamento: (context) => const CriarAgendamentoScreen(),
      };
}

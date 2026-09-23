import 'package:flutter/material.dart';

import '../features/splash/screens/splash_screen.dart';
import '../features/auth/screens/login_screen.dart';
import 'package:projeto_final/features/auth/screens/senha_screen.dart';
import '../features/home/screens/home_screen.dart';
import '../features/historico/screens/historico_screen.dart';
import '../features/fila/screens/fila_screen.dart';
import '../features/perfil/screens/perfil_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String senha = '/senha';
  static const String home = '/home';
  static const String historico = '/historico';
  static const String fila = '/fila';
  static const String perfil = '/perfil';

  static const Map<int, String> bottomNavRoutes = {
    0: home,
    1: historico,
    3: fila,
    4: perfil,
  };

  static Map<String, WidgetBuilder> get routes => {
        splash: (context) => const SplashScreen(),
        login: (context) => LoginScreen(),
        senha: (context) => const SenhaScreen(),
        home: (context) => const HomeScreen(),
        historico: (context) => const HistoricoScreen(),
        fila: (context) => const FilaScreen(),
        perfil: (context) => const PerfilScreen(),
      };
}
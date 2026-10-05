import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projeto_final/app/routes.dart';
import 'package:projeto_final/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  static const _duracao = Duration(seconds: 3);

  @override
  void initState() {
    super.initState();

    // O splash nativo (mesma cor de fundo) só sai depois que este splash já
    // foi desenhado, então o usuário vê uma única transição contínua.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });

    _iniciar();
  }

  Future<void> _iniciar() async {
    // Verifica a sessão salva enquanto a animação do splash roda.
    final restauracao = AuthService.instance.restaurarSessao();
    await Future<void>.delayed(_duracao);
    final logado = await restauracao;

    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      logado ? AppRoutes.home : AppRoutes.login,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/images/logo.svg',
              width: 120,
            ),
            const SizedBox(height: 5),
            SvgPicture.asset(
              'assets/images/medlink.svg',
              width: 180,
            ),
          ],
        ),
      ),
    );
  }
}

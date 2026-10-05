import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:projeto_final/app/navigation.dart';
import 'package:projeto_final/core/network/api_client.dart';

import 'app/app.dart';

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Mantém o splash nativo na tela até o splash do Flutter estar desenhado
  // (a remoção acontece em SplashScreen), evitando "piscar" entre os dois.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Token vencido/inválido em qualquer requisição => volta ao login.
  ApiClient.instance.onSessaoExpirada = AppNavigator.sessaoExpirada;

  runApp(const MainApp());
}

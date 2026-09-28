import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'app/app.dart';

void main() {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // Mantém o splash nativo na tela até o splash do Flutter estar desenhado
  // (a remoção acontece em SplashScreen), evitando "piscar" entre os dois.
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(const MainApp());
}

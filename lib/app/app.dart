import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projeto_final/app/app_info.dart';
import 'package:projeto_final/app/routes.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final WidgetsBinding widgetsBinding =
        WidgetsFlutterBinding.ensureInitialized();
    FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FlutterNativeSplash.remove();
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      title: AppInfo.name,

      locale: const Locale('pt', 'BR'),

      supportedLocales: const [
        Locale('pt', 'BR'),
      ],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      theme: AppTheme.lightTheme,

      routes: AppRoutes.routes,

      initialRoute: AppRoutes.splash,
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Tema do app. Todas as cores usadas nas telas devem vir do [ColorScheme]
/// (`Theme.of(context).colorScheme`), nunca de `Color(0xFF...)` solto.
///
/// Mapa de uso:
/// - `primary`            azul escuro da marca (AppBar, rodapé, textos)
/// - `secondary`          azul de destaque (botões, links, seleção)
/// - `surface`            fundo das telas
/// - `primaryContainer`   fundo dos cards de consulta
/// - `inversePrimary`     azul claro para textos sobre fundo `primary`
/// - `tertiary*`          estado "ok/sucesso" (ex.: fila em tempo real)
class AppTheme {
  static const Color _primary = Color(0xFF082849);
  static const Color _secondary = Color(0xFF0371CA);
  static const Color _surface = Color(0xFFF0F7FF);

  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Inter',
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      },
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primary,
      primary: _primary,
      onPrimary: Colors.white,
      secondary: _secondary,
      onSecondary: Colors.white,
      surface: _surface,
      onSurface: _primary,
      primaryContainer: const Color(0xFFC3D3E3),
      onPrimaryContainer: _primary,
      inversePrimary: const Color(0xFFC4D9ED),
      tertiary: const Color(0xFF18A86F),
      onTertiary: Colors.white,
      tertiaryContainer: const Color(0xFFE3F7EE),
      onTertiaryContainer: const Color(0xFF18A86F),
    ),
  );
}

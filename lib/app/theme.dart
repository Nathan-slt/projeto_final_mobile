import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    fontFamily: 'Inter',
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: const FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
      },
    ),
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF082849),
      primary: const Color(0xFF082849),
      secondary: const Color(0xFF0371CA),
      surface: const Color(0xFFF0F7FF),
      onSurface: const Color(0xFF082849),
    ),
  );
}
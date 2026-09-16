import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projeto_final/app/routes.dart';

class SenhaScreen extends StatelessWidget {
  const SenhaScreen({super.key});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
          Navigator.pushReplacementNamed(context, AppRoutes.home);
        },
          child: const Text('Login'),
        ),
      ),
    );
  }
}
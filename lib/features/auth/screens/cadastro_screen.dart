import 'package:flutter/material.dart';
import 'package:projeto_final/app/routes.dart';

class CadastroScreen extends StatelessWidget {
  const CadastroScreen({super.key});

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
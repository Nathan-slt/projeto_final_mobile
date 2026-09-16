import 'package:flutter/material.dart';
import 'package:projeto_final/app/routes.dart';

import 'package:projeto_final/core/widgets/rodape.dart';
import 'package:projeto_final/core/widgets/app_bar.dart';

class FilaScreen extends StatelessWidget {
  const FilaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Fila de Consultas',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.home);
              },
              child: const Text('Voltar para Home'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Rodape(
        currentIndex: 3,
      ),
    );
  }
}
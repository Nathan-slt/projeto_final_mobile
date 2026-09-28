import 'package:flutter/material.dart';
import 'package:projeto_final/core/widgets/app_bar.dart';
import 'package:projeto_final/features/home/widgets/agendamento_card.dart';
import 'package:projeto_final/features/home/widgets/calendario.dart';

/// Aba "Início". O rodapé e o botão de criar agendamento ficam no
/// [MainShellScreen].
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = (screenWidth * 0.045).clamp(16.0, 32.0);

    return Scaffold(
      appBar: const AppBarWidget(),
      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 8.0,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5),
                  Text(
                    'Meus agendamentos',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Próxima consulta:',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 5),
                  AgendamentoCard(),
                  Calendario(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

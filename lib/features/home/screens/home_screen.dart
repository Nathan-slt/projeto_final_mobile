import 'package:flutter/material.dart';

import '../../../core/widgets/app_bar.dart';
import '../widgets/agendamento_card.dart';
import '../widgets/calendario.dart';
import '../widgets/criar_agendamento.dart';
import '../../../core/widgets/rodape.dart';
 
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBarWidget(),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [

              const Text(
                'Meus agendamentos',

                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              const Text(
                'Próxima consulta:',

                style: TextStyle(
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 5),

              const AgendamentoCard(),

              const Calendario(),
            ],
          ),
        ), 
      ),
      bottomNavigationBar: Rodape(
        currentIndex: 0, // Fazer sistema pra current index nao ser selecionado
      ),
      floatingActionButton: AppFloatingActionButton(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
    );
  }
}       
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projeto_final/app/routes.dart';

import '../../../core/widgets/rodape.dart';
import '../widgets/criar_agendamento.dart';
import '../widgets/agendamento_card.dart';
import '../widgets/calendario.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
    
        title: SizedBox(
          height: 35,

          child: SvgPicture.asset(
            'assets/images/medlink.svg',
            fit: BoxFit.contain,
          ),
        ),
      ),

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
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              const Text(
                'Próxima consulta:',

                style: TextStyle(
                  fontSize: 18,
                ),
              ),

              const SizedBox(height: 10),

              const AgendamentoCard(),

              const Calendario(),
            ],
          ),
        ), 
      ),
      bottomNavigationBar: Rodape(
        currentIndex: 0,

        onItemSelected: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, AppRoutes.home);
              break;

            case 1:
              Navigator.pushReplacementNamed(context, AppRoutes.historico);
              break;

            case 3:
              Navigator.pushReplacementNamed(context, AppRoutes.fila);
              break;

            case 4:
              Navigator.pushReplacementNamed(context, AppRoutes.perfil);
              break;
          }
        },

        onAddPressed: () {
          // Nova consulta/agendamento
        },
      ),
      floatingActionButton: const AppFloatingActionButton(),
    );
  }
}
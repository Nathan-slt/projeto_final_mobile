import 'package:flutter/material.dart';

// import '../../../core/widgets/app_bar.dart';
import '../widgets/agendamento_card.dart';
import '../widgets/calendario.dart';
import '../widgets/criar_agendamento.dart';
import '../../../core/widgets/rodape.dart';

class CriarAgendamentoScreen extends StatelessWidget {
  const CriarAgendamentoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final horizontalPadding = (screenWidth * 0.045).clamp(16.0, 32.0);

    return Scaffold(
      // appBar: AppBarWidget(),

      body: SingleChildScrollView(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: 8.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const Text(
                  //   'Meus agendamentos',
                  //   style: TextStyle(
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),

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
        ),
      ),
      bottomNavigationBar: Rodape(
        currentIndex: 0,
      ),
      floatingActionButton: AppFloatingActionButton(),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
    );
  }
}
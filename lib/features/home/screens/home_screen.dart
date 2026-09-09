import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../perfil/screens/perfil_screen.dart';
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

      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: Theme.of(context).colorScheme.primary,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,

          children: [
            buildNavBarItem(
              const Icon(
                Icons.home,
                color: Colors.white,
              ),
              0,
            ),

            buildNavBarItem(
              const Icon(
                Icons.history_outlined,
                color: Colors.white,
              ),
              1,
            ),

            const SizedBox(width: 20),

            buildNavBarItem(
              const Text(
                'PXX',

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.white,
                  decorationThickness: 2.0,
                ),
              ),
              3,
            ),

            buildNavBarItem(
              const Icon(
                Icons.account_circle_outlined,
                color: Colors.white,
              ),
              4,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const PerfilScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      floatingActionButton: _buildFloatingActionButton(context),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildFloatingActionButton(BuildContext context) {
    return SizedBox(
      width: 58,
      height: 58,

      child: Stack(
        alignment: Alignment.center,

        children: [

          FloatingActionButton(
            elevation: 0,
            disabledElevation: 0,
            focusElevation: 0,
            hoverElevation: 0,
            highlightElevation: 0,

            backgroundColor:
                Theme.of(context).colorScheme.secondary,

            onPressed: () {},

            shape: const CircleBorder(),

            child: Icon(
              Icons.add,
              size: 24,

              color:
                  Theme.of(context).colorScheme.surface,
            ),
          ),

          IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,

                border: Border.all(
                  color:
                      Theme.of(context).colorScheme.surface,
                  width: 4.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildNavBarItem(
    Widget icon,
    int index, {
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          height: 60,
          width: 60,
          alignment: Alignment.center,
          child: SizedBox(
            width: 36,
            height: 36,
            child: FittedBox(
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
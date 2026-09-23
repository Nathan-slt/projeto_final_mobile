import 'package:flutter/material.dart';
import 'package:projeto_final/app/routes.dart';

class AppFloatingActionButton extends StatelessWidget {
  const AppFloatingActionButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
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

            onPressed: () {
              // Fazer agendamento
              Navigator.pushNamed(context, AppRoutes.agendamento);
            },

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
}
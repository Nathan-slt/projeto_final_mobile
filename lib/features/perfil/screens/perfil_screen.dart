import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projeto_final/features/home/screens/home_screen.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final surface = Theme.of(context).colorScheme.surface;

    return Scaffold(
      backgroundColor: surface,

      body: Column(
        children: [
          Container(
            height: 222,
            width: double.infinity,
            color: primary,
            child: Stack(
              children: [
                const Positioned(
                  top: 20,
                  left: 0,
                  right: 0,
                  child: Text(
                    'Perfil',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFC4D9ED),
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                Positioned(
                  top: 58,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      width: 136,
                      height: 136,
                      decoration: BoxDecoration(
                        color: surface,
                        borderRadius: BorderRadius.circular(38),
                      ),
                      child: Icon(
                        Icons.person_outline,
                        size: 105,
                        color: primary,
                      ),
                    ),
                  ),
                ),

                Positioned(
                  right: 10,
                  bottom: 2,
                  child: SizedBox(
                    height: 38,
                    child: SvgPicture.asset(
                      'assets/images/medlink.svg',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 26,
                vertical: 18,
              ),
              child: Column(
                children: [
                  _buildProfileField(
                    context,
                    'Nome',
                    'Kauan Santos',
                  ),

                  _buildProfileField(
                    context,
                    'Telefone',
                    '(12)99775-6565',
                  ),

                  _buildProfileField(
                    context,
                    'Email',
                    'kauansnts@email.com',
                  ),

                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Alterar Senha',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: secondary,
                        side: BorderSide(
                          color: secondary,
                          width: 1,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Sair',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
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


  Widget _buildProfileField(
    BuildContext context,
    String label,
    String value,
  ) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      width: double.infinity,
      height: 70,
      padding: const EdgeInsets.only(
        left: 20,
        right: 12,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: primary.withOpacity(0.5),
            width: 1.2,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: primary,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: TextStyle(
                    color: primary,
                    fontSize: 19,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          Icon(
            Icons.edit,
            size: 20,
            color: primary,
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
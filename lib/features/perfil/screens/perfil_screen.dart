import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        height: 66,
        color: primary,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavBarItem(
              icon: Icons.grid_view_rounded,
              selected: false,
            ),

            _buildNavBarItem(
              icon: Icons.history,
              selected: false,
            ),

            const SizedBox(width: 52),

            _buildNavBarItem(
              icon: Icons.text_fields,
              selected: false,
            ),

            _buildNavBarItem(
              icon: Icons.account_circle_outlined,
              selected: true,
            ),
          ],
        ),
      ),

      floatingActionButton: SizedBox(
        width: 76,
        height: 76,
        child: Stack(
          alignment: Alignment.center,
          children: [
            FloatingActionButton(
              elevation: 0,
              backgroundColor: secondary,
              onPressed: () {},
              shape: const CircleBorder(),
              child: const Icon(
                Icons.add,
                size: 42,
                color: Colors.white,
              ),
            ),

            IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: surface,
                    width: 4,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
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

  Widget _buildNavBarItem({
    required IconData icon,
    required bool selected,
  }) {
    return Expanded(
      child: SizedBox(
        height: 66,
        child: Center(
          child: Icon(
            icon,
            size: 34,
            color: selected
                ? const Color(0xFF0371CA)
                : Colors.white,
          ),
        ),
      ),
    );
  }
}
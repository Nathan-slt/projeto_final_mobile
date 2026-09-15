import 'package:flutter/material.dart';

class Rodape extends StatelessWidget {
  final VoidCallback? onProfileTap;

  const Rodape({
    super.key,
    this.onProfileTap,
    required VoidCallback onAddPressed,
    required ValueChanged<int> onItemSelected,
    required int currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
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
            onTap: onProfileTap,
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


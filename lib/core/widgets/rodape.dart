import 'package:flutter/material.dart';
import 'package:projeto_final/app/routes.dart';

class Rodape extends StatelessWidget {
  final int currentIndex;

  const Rodape({
    super.key,
    required this.currentIndex,
  });

  void _navigate(BuildContext context, int index) {
    final route = AppRoutes.bottomNavRoutes[index];

    if (route != null) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      height: 60,
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        children: [
          _buildItem(
            context: context,
            icon: Icons.home,
            index: 0,
          ),
          _buildItem(
            context: context,
            icon: Icons.history_outlined,
            index: 1,
          ),
          const SizedBox(width: 20),
          _buildItem(
            context: context,
            text: 'PXX',
            index: 3,
          ),
          _buildItem(
            context: context,
            icon: Icons.account_circle_outlined,
            index: 4,
          ),
        ],
      ),
    );
  }

Widget _buildItem({
  required BuildContext context,
  IconData? icon,
  String? text,
  required int index,
}) {
  final bool isSelected = currentIndex == index;

  return Expanded(
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        _navigate(context, index);
      },
      child: SizedBox(
        height: 60,
        child: Center(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: 52,
            height: 44,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.white.withValues(alpha: 0.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: icon != null
                ? Icon(
                    icon,
                    color: Colors.white,
                    size: isSelected ? 31 : 27,
                  )
                : Text(
                    text!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: isSelected
                          ? TextDecoration.underline
                          : TextDecoration.none,
                      decorationColor: Colors.white,
                      decorationThickness: 2,
                    ),
                  ),
          ),
        ),
      ),
    ),
  );
}
}
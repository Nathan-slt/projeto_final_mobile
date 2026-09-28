import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  /// Mostra o botão de voltar quando a tela foi empilhada (`Navigator.push`).
  final bool showBackButton;

  const AppBarWidget({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return AppBar(
      automaticallyImplyLeading: showBackButton,
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      centerTitle: true,
      title: SizedBox(
        height: 35,
        child: SvgPicture.asset(
          'assets/images/medlink.svg',
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:flutter/material.dart';
import 'package:projeto_final/core/widgets/app_bar.dart';

/// Aba "Fila". O rodapé fica no [MainShellScreen].
class FilaScreen extends StatelessWidget {
  const FilaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = (screenWidth * 0.045).clamp(16.0, 32.0);

    final boxWidth = (screenWidth * 0.65).clamp(220.0, 260.0);
    final boxHeight = (screenWidth * 0.31).clamp(115.0, 125.0);
    final mainFontSize = (screenWidth * 0.15).clamp(48.0, 60.0);
    final titleFontSize = (screenWidth * 0.04).clamp(14.0, 16.0);
    final statusFontSize = (screenWidth * 0.035).clamp(13.0, 14.0);

    final scheme = Theme.of(context).colorScheme;
    final primary = scheme.primary;

    return Scaffold(
      appBar: const AppBarWidget(),

      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
            ),
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: boxWidth,
                            height: boxHeight,
                            decoration: BoxDecoration(
                              color: primary,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'SEU IDENTIFICADOR',
                                  style: TextStyle(
                                    color: scheme.inversePrimary,
                                    fontSize: titleFontSize,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),

                                const SizedBox(height: 5),

                                Text(
                                  'PXXX',
                                  style: TextStyle(
                                    color: scheme.onPrimary,
                                    fontSize: mainFontSize,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: (screenWidth * 0.06).clamp(20.0, 25.0),
                          ),

                          Text(
                            'POSIÇÃO NA FILA',
                            style: TextStyle(
                              color: primary,
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 5),

                          Text(
                            'XX',
                            style: TextStyle(
                              color: primary,
                              fontSize: mainFontSize,
                              fontWeight: FontWeight.w500,
                              height: 1,
                            ),
                          ),

                          SizedBox(
                            height: (screenWidth * 0.07).clamp(24.0, 30.0),
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  (screenWidth * 0.045).clamp(16.0, 18.0),
                              vertical:
                                  (screenWidth * 0.025).clamp(8.0, 10.0),
                            ),
                            decoration: BoxDecoration(
                              color: scheme.tertiaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.circle,
                                  color: scheme.tertiary,
                                  size: 6,
                                ),

                                const SizedBox(width: 8),

                                Text(
                                  'Atualizando em tempo real',
                                  style: TextStyle(
                                    color: scheme.onTertiaryContainer,
                                    fontSize: statusFontSize,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
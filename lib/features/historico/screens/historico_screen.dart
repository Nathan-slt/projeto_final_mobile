import 'package:flutter/material.dart';

import '../../../core/widgets/app_bar.dart';

import 'package:projeto_final/core/widgets/rodape.dart';

import 'package:projeto_final/features/historico/widgets/consulta_card.dart';

class HistoricoScreen extends StatelessWidget {
  const HistoricoScreen({super.key});

  static final List<Consulta> _consultas = [
    Consulta(
      medico: 'Dr. Tom Holland',
      especialidade: 'Oftalmologista',
      tipoExame: 'Exame de Vista',
      clinica: 'Clínica Vista+',
      endereco: 'Rua Amélia Prado, 560 - Jardim do Vale\nLorena, São Paulo - 12615-670',
      observacoes: 'Pequeno relatório da consulta',
      data: DateTime(2026, 8, 24, 14, 0),
    ),
    Consulta(
      medico: 'Dr. Tom Holland',
      especialidade: 'Oftalmologista',
      tipoExame: 'Exame de Vista',
      clinica: 'Clínica Vista+',
      endereco: 'Rua Amélia Prado, 560 - Jardim do Vale\nLorena, São Paulo - 12615-670',
      data: DateTime(2026, 8, 15, 16, 0),
    ),
    Consulta(
      medico: 'Dr. Tom Holland',
      especialidade: 'Oftalmologista',
      tipoExame: 'Exame de Vista',
      clinica: 'Clínica Vista+',
      endereco: 'Rua Amélia Prado, 560 - Jardim do Vale\nLorena, São Paulo - 12615-670',
      data: DateTime(2026, 7, 27, 18, 0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final horizontalPadding = (screenWidth * 0.045).clamp(16.0, 32.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FF),
      appBar: AppBarWidget(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Últimas consultas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0A2A52),
                  ),
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    0,
                    horizontalPadding,
                    16,
                  ),
                  itemCount: _consultas.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => ConsultaCard(
                    consulta: _consultas[index],
                    onTap: () {
                      // TODO: abrir detalhes da consulta
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Rodape(
        currentIndex: 1,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:projeto_final/core/widgets/app_bar.dart';
import 'package:projeto_final/core/models/agendamento.dart';
import 'package:projeto_final/features/historico/widgets/agendamento_card.dart';

/// Aba "Histórico". O rodapé fica no [MainShellScreen].
class HistoricoScreen extends StatelessWidget {
  const HistoricoScreen({super.key});

  static final List<Agendamento> _agendamentos = [
    Agendamento(
      medico: 'Dr. Tom Holland',
      especialidade: 'Oftalmologista',
      tipoExame: 'Exame de Vista',
      clinica: 'Clínica Vista+',
      endereco:
          'Rua Amélia Prado, 560 - Jardim do Vale\nLorena, São Paulo - 12615-670',
      observacoes: 'Pequeno relatório da consulta',
      data: DateTime(2026, 8, 24, 14, 0),
    ),
    Agendamento(
      medico: 'Dr. Tom Holland',
      especialidade: 'Oftalmologista',
      tipoExame: 'Exame de Vista',
      clinica: 'Clínica Vista+',
      endereco:
          'Rua Amélia Prado, 560 - Jardim do Vale\nLorena, São Paulo - 12615-670',
      data: DateTime(2026, 8, 15, 16, 0),
    ),
    Agendamento(
      medico: 'Dr. Tom Holland',
      especialidade: 'Oftalmologista',
      tipoExame: 'Exame de Vista',
      clinica: 'Clínica Vista+',
      endereco:
          'Rua Amélia Prado, 560 - Jardim do Vale\nLorena, São Paulo - 12615-670',
      data: DateTime(2026, 7, 27, 18, 0),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = (screenWidth * 0.045).clamp(16.0, 32.0);

    return Scaffold(
      appBar: const AppBarWidget(),
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
                  itemCount: _agendamentos.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) => AgendamentoCard(
                    agendamento: _agendamentos[index],
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
    );
  }
}

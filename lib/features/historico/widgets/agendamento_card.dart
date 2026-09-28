import 'package:flutter/material.dart';
import 'package:projeto_final/core/models/agendamento.dart';

class AgendamentoCard extends StatelessWidget {
  final Agendamento agendamento;
  final VoidCallback? onTap;

  const AgendamentoCard({super.key, required this.agendamento, this.onTap});

  static const _meses = [
    'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN',
    'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ',
  ];

  String get _hora {
    final h = agendamento.data.hour.toString().padLeft(2, '0');
    final m = agendamento.data.minute.toString().padLeft(2, '0');
    return '$h:${m}h';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.primaryContainer,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildInfo(scheme)),
              Container(
                width: 2,
                color: scheme.onPrimary.withValues(alpha: 0.6),
              ),
              SizedBox(width: 100, child: _buildData(scheme)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo(ColorScheme scheme) {
    final cor = scheme.onPrimaryContainer;

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: scheme.onPrimary,
                backgroundImage: agendamento.fotoUrl != null
                    ? NetworkImage(agendamento.fotoUrl!)
                    : null,
                child: agendamento.fotoUrl == null
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      agendamento.medico,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: cor,
                      ),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                agendamento.especialidade,
                                style: TextStyle(fontSize: 12, color: cor),
                              ),
                              Text(
                                agendamento.tipoExame,
                                style: TextStyle(fontSize: 12, color: cor),
                              ),
                            ],
                          ),
                        ),
                        _buildChip(scheme),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            agendamento.clinica,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: cor,
            ),
          ),
          Text(
            agendamento.endereco,
            style: TextStyle(fontSize: 12, color: cor),
          ),
          const SizedBox(height: 6),
          Text(
            'Observações',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: cor,
            ),
          ),
          Text(
            agendamento.observacoes,
            style: TextStyle(fontSize: 12, color: cor),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(ColorScheme scheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.onPrimary.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        agendamento.tipoLocal,
        style: TextStyle(fontSize: 11, color: scheme.secondary),
      ),
    );
  }

  Widget _buildData(ColorScheme scheme) {
    final cor = scheme.onPrimaryContainer;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          agendamento.data.day.toString().padLeft(2, '0'),
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: cor,
          ),
        ),
        Text(
          _meses[agendamento.data.month - 1],
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: cor,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          _hora,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: cor,
          ),
        ),
      ],
    );
  }
}

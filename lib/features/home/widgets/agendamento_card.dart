import 'package:flutter/material.dart';
import 'package:projeto_final/core/models/agendamento_detalhado.dart';
import 'package:projeto_final/core/utils/datas.dart';

/// Cartão de uma consulta (médico, clínica, hora e dia).
class AgendamentoCard extends StatelessWidget {
  final AgendamentoDetalhado consulta;

  const AgendamentoCard({super.key, required this.consulta});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final onPrimary = scheme.onPrimary;
    final data = consulta.data;

    return Container(
      width: double.infinity,
      // Altura mínima (não fixa): cresce se o nome for longo ou a fonte
      // do sistema estiver aumentada.
      constraints: const BoxConstraints(minHeight: 110),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 33,
            backgroundColor: onPrimary,
            child: const Icon(
              Icons.person_outline,
              size: 45,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  TextSpan(
                    children: [
                      TextSpan(
                        text: consulta.medico,
                        style: TextStyle(
                          color: onPrimary,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (consulta.especialidade.isNotEmpty)
                        TextSpan(
                          text: ' - ${consulta.especialidade}',
                          style: TextStyle(
                            color: onPrimary,
                            fontSize: 15,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  consulta.clinica,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: onPrimary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            height: 70,
            width: 1.5,
            color: onPrimary,
          ),
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                formatarHora(data),
                style: TextStyle(
                  color: onPrimary,
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${data.day} ${abreviacaoMes(data.month)}',
                style: TextStyle(
                  color: onPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
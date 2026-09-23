import 'package:flutter/material.dart';

/// Modelo simples de consulta. Se preferir, mova para `core/models/consulta.dart`.
class Consulta {
  final String medico;
  final String especialidade;
  final String tipoExame;
  final String tipoLocal; // ex.: "Consultório"
  final String clinica;
  final String endereco;
  final String observacoes;
  final DateTime data;
  final String? fotoUrl;

  const Consulta({
    required this.medico,
    required this.especialidade,
    required this.tipoExame,
    required this.clinica,
    required this.endereco,
    required this.data,
    this.tipoLocal = 'Consultório',
    this.observacoes = '-',
    this.fotoUrl,
  });
}

class ConsultaCard extends StatelessWidget {
  final Consulta consulta;
  final VoidCallback? onTap;

  const ConsultaCard({super.key, required this.consulta, this.onTap});

  static const _azulEscuro = Color(0xFF0A2A52);
  static const _azulMedio = Color(0xFF0B6FC9);
  static const _fundoCard = Color(0xFFC3D3E3);
  static const _meses = [
    'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN',
    'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ',
  ];

  String get _hora {
    final h = consulta.data.hour.toString().padLeft(2, '0');
    final m = consulta.data.minute.toString().padLeft(2, '0');
    return '$h:${m}h';
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _fundoCard,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _buildInfo()),
              Container(width: 2, color: Colors.white.withOpacity(0.6)),
              SizedBox(width: 100, child: _buildData()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfo() {
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
                backgroundColor: Colors.white,
                backgroundImage: consulta.fotoUrl != null
                    ? NetworkImage(consulta.fotoUrl!)
                    : null,
                child: consulta.fotoUrl == null
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      consulta.medico,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: _azulEscuro,
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
                                consulta.especialidade,
                                style: const TextStyle(
                                    fontSize: 10, color: _azulEscuro),
                              ),
                              Text(
                                consulta.tipoExame,
                                style: const TextStyle(
                                    fontSize: 10, color: _azulEscuro),
                              ),
                            ],
                          ),
                        ),
                        _buildChip(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            consulta.clinica,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: _azulEscuro,
            ),
          ),
          Text(
            consulta.endereco,
            style: const TextStyle(fontSize: 10, color: _azulEscuro),
          ),
          const SizedBox(height: 6),
          const Text(
            'Observações',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: _azulEscuro,
            ),
          ),
          Text(
            consulta.observacoes,
            style: const TextStyle(fontSize: 10, color: _azulEscuro),
          ),
        ],
      ),
    );
  }

  Widget _buildChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        consulta.tipoLocal,
        style: const TextStyle(fontSize: 8, color: _azulMedio),
      ),
    );
  }

  Widget _buildData() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          consulta.data.day.toString().padLeft(2, '0'),
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: _azulEscuro,
          ),
        ),
        Text(
          _meses[consulta.data.month - 1],
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _azulEscuro,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          _hora,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: _azulEscuro,
          ),
        ),
      ],
    );
  }
}
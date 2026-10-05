class FilaEspera {
  final int idFila;
  final int idAgendamento;
  final DateTime? horarioChegada;
  final String status;
  final int? posicao;
  final String? codigoAtendimento;

  const FilaEspera({
    required this.idFila,
    required this.idAgendamento,
    this.horarioChegada,
    required this.status,
    this.posicao,
    this.codigoAtendimento,
  });

  factory FilaEspera.fromJson(
    Map<String, dynamic> json,
  ) {
    return FilaEspera(
      idFila:
          json['id_fila'] as int,
      idAgendamento:
          json['id_agendamento'] as int,
      horarioChegada:
          json['horario_chegada'] == null
              ? null
              : DateTime.parse(
                  json['horario_chegada']
                      .toString(),
                ).toLocal(),
      status:
          json['status'].toString(),
      posicao:
          json['posicao'] as int?,
      codigoAtendimento:
          json['codigo_atendimento']
              ?.toString(),
    );
  }
}
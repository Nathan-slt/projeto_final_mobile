class HorarioDisponivel {
  final int idHorario;
  final int idProfissional;
  final DateTime data;
  final String horaInicio;
  final String horaFim;
  final bool disponivel;

  const HorarioDisponivel({
    required this.idHorario,
    required this.idProfissional,
    required this.data,
    required this.horaInicio,
    required this.horaFim,
    required this.disponivel,
  });

  factory HorarioDisponivel.fromJson(Map<String, dynamic> json) {
    return HorarioDisponivel(
      idHorario: json['id_horario'] as int,
      idProfissional: json['id_profissional'] as int,
      data: DateTime.parse(json['data'] as String),
      horaInicio: json['hora_inicio'].toString(),
      horaFim: json['hora_fim'].toString(),
      disponivel: json['disponivel'] == true || json['disponivel'] == 1,
    );
  }

  String get horaExibicao => horaInicio.length >= 5
      ? horaInicio.substring(0, 5)
      : horaInicio;
}
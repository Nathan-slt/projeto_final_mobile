class Especialidade {
  final int idEspecialidade;
  final String nome;

  const Especialidade({
    required this.idEspecialidade,
    required this.nome,
  });

  factory Especialidade.fromJson(
    Map<String, dynamic> json,
  ) {
    return Especialidade(
      idEspecialidade:
          json['id_especialidade']
              as int,
      nome:
          json['nome'].toString(),
    );
  }
}
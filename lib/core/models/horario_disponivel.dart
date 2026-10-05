class Clinica {
  final int idClinica;
  final String nome;
  final String? endereco;
  final String? telefone;

  const Clinica({
    required this.idClinica,
    required this.nome,
    this.endereco,
    this.telefone,
  });

  factory Clinica.fromJson(
    Map<String, dynamic> json,
  ) {
    return Clinica(
      idClinica:
          json['id_clinica'] as int,
      nome:
          json['nome'].toString(),
      endereco:
          json['endereco']?.toString(),
      telefone:
          json['telefone']?.toString(),
    );
  }
}
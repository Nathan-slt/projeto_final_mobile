/// Tabela `profissionais`.
class Profissional {
  final int idProfissional;
  final String nome;
  final int idEspecialidade;

  /// Registro no conselho (ex.: CRM). Único por profissional.
  final String registroProfissional;
  final bool ativo;
  final int idClinica;

  const Profissional({
    required this.idProfissional,
    required this.nome,
    required this.idEspecialidade,
    required this.registroProfissional,
    required this.idClinica,
    this.ativo = true,
  });

  factory Profissional.fromJson(Map<String, dynamic> json) {
    return Profissional(
      idProfissional: json['id_profissional'] as int,
      nome: json['nome'] as String,
      idEspecialidade: json['id_especialidade'] as int,
      registroProfissional: json['registro_profissional'] as String,
      ativo: json['ativo'] as bool? ?? true,
      idClinica: json['id_clinica'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_profissional': idProfissional,
      'nome': nome,
      'id_especialidade': idEspecialidade,
      'registro_profissional': registroProfissional,
      'ativo': ativo,
      'id_clinica': idClinica,
    };
  }
}

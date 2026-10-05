/// Tabela `pacientes`.
class Paciente {
  final int idPaciente;
  final int idUsuario;
  final String cpf;
  final DateTime dataNascimento;
  final String? telefone;
  final String? endereco;

  const Paciente({
    required this.idPaciente,
    required this.idUsuario,
    required this.cpf,
    required this.dataNascimento,
    this.telefone,
    this.endereco,
  });

  factory Paciente.fromJson(Map<String, dynamic> json) {
    return Paciente(
      idPaciente: json['id_paciente'] as int,
      idUsuario: json['id_usuario'] as int,
      cpf: json['cpf'] as String,
      dataNascimento: DateTime.parse(
        json['data_nascimento'] as String,
      ),
      telefone: json['telefone'] as String?,
      endereco: json['endereco'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_paciente': idPaciente,
      'id_usuario': idUsuario,
      'cpf': cpf,
      'data_nascimento':
          dataNascimento.toIso8601String().split('T').first,
      'telefone': telefone,
      'endereco': endereco,
    };
  }
}
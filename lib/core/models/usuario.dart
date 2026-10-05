/// Papel do usuário no sistema (ENUM `papel` no banco).
enum PapelUsuario {
  paciente('paciente'),
  recepcionista('recepcionista'),
  administrador('administrador'),
  adminGeral('admin_geral');

  /// Valor exatamente como a API envia/recebe.
  final String valor;

  const PapelUsuario(this.valor);

  static PapelUsuario fromJson(String valor) {
    return values.firstWhere(
      (papel) => papel.valor == valor,
      orElse: () => throw FormatException('Papel de usuário inválido: $valor'),
    );
  }
}

/// Tabela `usuarios`.
///
/// O campo `senha_hash` NÃO faz parte deste modelo de propósito: o hash da
/// senha nunca deve chegar ao app. A senha só trafega em requisições
/// específicas (login, cadastro, alterar senha), não no objeto do usuário.
class Usuario {
  final int idUsuario;
  final String nome;
  final String email;
  final PapelUsuario papel;
  final bool ativo;

  /// Nulo para usuários que não pertencem a uma clínica (ex.: admin geral).
  final int? idClinica;

  const Usuario({
    required this.idUsuario,
    required this.nome,
    required this.email,
    required this.papel,
    this.ativo = true,
    this.idClinica,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['id_usuario'] as int,
      nome: json['nome'] as String,
      email: json['email'] as String,
      papel: PapelUsuario.fromJson(json['papel'] as String),
      ativo: json['ativo'] == null ? true : (json['ativo'] == true || json['ativo'] == 1),
      idClinica: json['id_clinica'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id_usuario': idUsuario,
      'nome': nome,
      'email': email,
      'papel': papel.valor,
      'ativo': ativo,
      'id_clinica': idClinica,
    };
  }
}

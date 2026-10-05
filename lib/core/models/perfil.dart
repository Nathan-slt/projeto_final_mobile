import 'package:projeto_final/core/models/usuario.dart';

/// Dados da tela de perfil: o usuário + o telefone do paciente.
class Perfil {
  final Usuario usuario;

  /// Nulo quando ainda não há telefone conhecido.
  final String? telefone;

  const Perfil({required this.usuario, this.telefone});
}

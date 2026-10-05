import 'package:projeto_final/core/auth/jwt_utils.dart';
import 'package:projeto_final/core/models/usuario.dart';

/// Quem está logado, extraído do token devolvido pelo login.
///
/// O backend coloca no JWT: `id_usuario`, `papel`, `id_paciente` (só para
/// pacientes) e `id_clinica`. O login em si não devolve esses ids no corpo.
class Sessao {
  final String token;
  final int idUsuario;
  final PapelUsuario papel;
  final int? idPaciente;
  final int? idClinica;
  final DateTime? expiraEm;

  const Sessao({
    required this.token,
    required this.idUsuario,
    required this.papel,
    this.idPaciente,
    this.idClinica,
    this.expiraEm,
  });

  /// Lança [FormatException] se o token não tiver o formato esperado.
  factory Sessao.fromToken(String token) {
    final payload = decodificarPayloadJwt(token);

    final idUsuario = payload['id_usuario'];
    final papel = payload['papel'];
    if (idUsuario is! int || papel is! String) {
      throw const FormatException('Token sem os dados do usuário.');
    }

    final exp = payload['exp'];

    return Sessao(
      token: token,
      idUsuario: idUsuario,
      papel: PapelUsuario.fromJson(papel),
      idPaciente: payload['id_paciente'] as int?,
      idClinica: payload['id_clinica'] as int?,
      // `exp` do JWT é em segundos desde 1970.
      expiraEm: exp is num
          ? DateTime.fromMillisecondsSinceEpoch(exp.toInt() * 1000)
          : null,
    );
  }

  bool get expirada {
    final fim = expiraEm;
    return fim != null && !DateTime.now().isBefore(fim);
  }
}

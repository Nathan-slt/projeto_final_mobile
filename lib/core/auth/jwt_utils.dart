import 'dart:convert';

/// Lê o conteúdo (payload) de um JWT.
///
/// Só DECODIFICA: não verifica a assinatura (isso é papel do servidor, que
/// valida o token em toda requisição). Serve apenas para o app saber quem
/// está logado (id, papel) e quando o token vence.
Map<String, dynamic> decodificarPayloadJwt(String token) {
  final partes = token.split('.');
  if (partes.length != 3) {
    throw const FormatException('Token JWT inválido.');
  }

  final json = utf8.decode(base64Url.decode(base64Url.normalize(partes[1])));
  final payload = jsonDecode(json);
  if (payload is! Map<String, dynamic>) {
    throw const FormatException('Conteúdo do token inválido.');
  }
  return payload;
}

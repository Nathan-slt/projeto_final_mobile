/// Erro de uma chamada à API, já com mensagem pronta para mostrar ao usuário.
class ApiException implements Exception {
  final String mensagem;

  /// Código HTTP, quando o servidor chegou a responder (nulo em erro de rede).
  final int? statusCode;

  const ApiException(this.mensagem, {this.statusCode});

  @override
  String toString() => mensagem;
}

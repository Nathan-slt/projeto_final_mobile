import 'package:projeto_final/core/models/fila_posicao.dart';
import 'package:projeto_final/core/network/api_client.dart';
import 'package:projeto_final/core/network/api_exception.dart';

class FilaService {
  FilaService({ApiClient? api}) : _api = api ?? ApiClient.instance;

  static FilaService instance = FilaService();

  final ApiClient _api;

  /// Retorna nulo quando o paciente ainda não fez check-in ou já saiu da fila.
  Future<FilaPosicao?> minhaPosicao() async {
    final resposta = await _api.get('/fila/minha-posicao');
    if (resposta is! Map || resposta['naFila'] is! bool) {
      throw const ApiException('Resposta inesperada do servidor.');
    }

    if (resposta['naFila'] == false) return null;

    try {
      return FilaPosicao.fromJson(Map<String, dynamic>.from(resposta));
    } on FormatException {
      throw const ApiException('Resposta inesperada do servidor.');
    }
  }
}

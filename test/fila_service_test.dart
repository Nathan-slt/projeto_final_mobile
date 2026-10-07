import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:projeto_final/core/network/api_client.dart';
import 'package:projeto_final/core/network/api_exception.dart';
import 'package:projeto_final/services/fila_service.dart';

void main() {
  test('consulta posição autenticada na rota do paciente', () async {
    late http.Request requisicao;
    final service = FilaService(
      api: ApiClient(
        client: MockClient((request) async {
          requisicao = request;
          return http.Response(
            jsonEncode({
              'naFila': true,
              'codigo_atendimento': 'C123',
              'status': 'aguardando',
              'posicao': 2,
              'total': 5,
              'profissional': 'Dra. Juliana Martins',
              'especialidade': 'Ortopedia',
            }),
            200,
            headers: {'content-type': 'application/json'},
          );
        }),
        baseUrl: 'http://teste/api',
      )..token = 'token-teste',
    );

    final posicao = await service.minhaPosicao();

    expect(requisicao.method, 'GET');
    expect(requisicao.url.path, '/api/fila/minha-posicao');
    expect(requisicao.headers['Authorization'], isNotEmpty);
    expect(posicao?.codigoAtendimento, 'C123');
    expect(posicao?.status, 'aguardando');
    expect(posicao?.posicao, 2);
    expect(posicao?.profissional, 'Dra. Juliana Martins');
    expect(posicao?.especialidade, 'Ortopedia');
  });

  test('retorna nulo quando o backend informa que não está na fila', () async {
    final service = FilaService(
      api: ApiClient(
        client: MockClient((_) async => http.Response('{"naFila":false}', 200)),
        baseUrl: 'http://teste/api',
      ),
    );

    expect(await service.minhaPosicao(), isNull);
  });

  test(
    'informa resposta inválida em vez de apresentar dados incompletos',
    () async {
      final service = FilaService(
        api: ApiClient(
          client: MockClient(
            (_) async => http.Response(
              '{"naFila":true,"codigo_atendimento":"C123","status":"aguardando","posicao":2}',
              200,
            ),
          ),
          baseUrl: 'http://teste/api',
        ),
      );

      await expectLater(
        service.minhaPosicao(),
        throwsA(
          isA<ApiException>().having(
            (erro) => erro.mensagem,
            'mensagem',
            'Resposta inesperada do servidor.',
          ),
        ),
      );
    },
  );
}

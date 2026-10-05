import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:projeto_final/core/network/api_client.dart';
import 'package:projeto_final/core/network/api_exception.dart';

const _json = {'content-type': 'application/json; charset=utf-8'};

ApiClient _criar(MockClientHandler handler) {
  return ApiClient(client: MockClient(handler), baseUrl: 'http://teste/api');
}

Matcher _erroCom(String mensagem, {int? status}) {
  return throwsA(
    isA<ApiException>()
        .having((e) => e.mensagem, 'mensagem', mensagem)
        .having((e) => e.statusCode, 'statusCode', status),
  );
}

void main() {
  test('envia o token em rotas autenticadas e devolve o JSON', () async {
    late http.Request recebida;
    final api = _criar((req) async {
      recebida = req;
      return http.Response('{"ok":true}', 200, headers: _json);
    });
    api.token = 'abc';

    final resposta = await api.get('/usuarios/me');

    expect(recebida.url.toString(), 'http://teste/api/usuarios/me');
    expect(recebida.headers['Authorization'], 'Bearer abc');
    expect(resposta, {'ok': true});
  });

  test('não envia o token quando autenticado = false', () async {
    late http.Request recebida;
    final api = _criar((req) async {
      recebida = req;
      return http.Response('{}', 200, headers: _json);
    });
    api.token = 'abc';

    await api.post('/usuarios/login', corpo: {'email': 'a'}, autenticado: false);

    expect(recebida.headers.containsKey('Authorization'), isFalse);
    expect(recebida.headers['Content-Type'], contains('application/json'));
    expect(recebida.body, '{"email":"a"}');
  });

  test('em 4xx usa a mensagem do campo "erro" do backend', () async {
    final api = _criar((_) async => http.Response(
          '{"erro":"Email ou senha inválidos."}',
          401,
          headers: _json,
        ));

    await expectLater(
      api.post('/usuarios/login', autenticado: false),
      _erroCom('Email ou senha inválidos.', status: 401),
    );
  });

  test('em 5xx não expõe a mensagem crua do servidor', () async {
    final api = _criar((_) async => http.Response(
          '{"erro":"SequelizeDatabaseError: tabela x"}',
          500,
          headers: _json,
        ));

    await expectLater(
      api.get('/usuarios/me'),
      _erroCom('Erro no servidor. Tente novamente em instantes.', status: 500),
    );
  });

  test('401 em rota autenticada avisa a sessão expirada', () async {
    var avisos = 0;
    final api = _criar((_) async => http.Response(
          '{"erro":"Token invalido ou expirado."}',
          401,
          headers: _json,
        ));
    api.token = 'vencido';
    api.onSessaoExpirada = () async => avisos++;

    await expectLater(
      api.get('/usuarios/me'),
      _erroCom('Sua sessão expirou. Faça login novamente.', status: 401),
    );
    expect(avisos, 1);
  });

  test('falha de rede vira mensagem de "sem conexão"', () async {
    final api = _criar((_) async => throw http.ClientException('sem rede'));

    await expectLater(
      api.get('/usuarios/me'),
      _erroCom('Sem conexão com o servidor. Verifique sua internet.'),
    );
  });
}

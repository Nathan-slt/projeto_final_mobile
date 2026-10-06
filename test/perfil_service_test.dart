import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:projeto_final/core/network/api_client.dart';
import 'package:projeto_final/core/storage/armazenamento_local.dart';
import 'package:projeto_final/services/perfil_service.dart';

class _ArmazenamentoFake extends ArmazenamentoLocal {
  @override
  Future<String?> lerTelefone(int idUsuario) async => null;
}

Future<String?> _buscarTelefone(Map<String, dynamic> json) async {
  final api = ApiClient(
    client: MockClient(
      (_) async => http.Response(
        jsonEncode(json),
        200,
        headers: {'content-type': 'application/json'},
      ),
    ),
    baseUrl: 'http://teste/api',
  );
  final service = PerfilService(
    api: api,
    armazenamento: _ArmazenamentoFake(),
  );

  return (await service.buscarPerfil()).telefone;
}

Map<String, dynamic> _usuario({required Object telefone}) => {
      'id_usuario': 1,
      'nome': 'Paciente',
      'email': 'paciente@example.com',
      'papel': 'paciente',
      ...telefone as Map<String, dynamic>,
    };

void main() {
  test('lê telefone no nível principal da resposta', () async {
    expect(
      await _buscarTelefone(_usuario(telefone: {'telefone': '12997756565'})),
      '12997756565',
    );
  });

  test('lê telefone do paciente com chave maiúscula ou minúscula', () async {
    expect(
      await _buscarTelefone(
        _usuario(telefone: {'Paciente': {'telefone': '(12)99775-6565'}}),
      ),
      '(12)99775-6565',
    );
    expect(
      await _buscarTelefone(
        _usuario(telefone: {'paciente': {'telefone': '(12)99775-6565'}}),
      ),
      '(12)99775-6565',
    );
  });

  test('PATCH envia apenas o nome ou e-mail alterado', () async {
    final requisicoes = <http.Request>[];
    final api = ApiClient(
      client: MockClient((requisicao) async {
        requisicoes.add(requisicao);
        return http.Response(
          '{}',
          200,
          headers: {'content-type': 'application/json'},
        );
      }),
      baseUrl: 'http://teste/api',
    );
    final service = PerfilService(
      api: api,
      armazenamento: _ArmazenamentoFake(),
    );

    await service.atualizarDadosUsuario(1, nome: 'Nome atualizado');
    await service.atualizarDadosUsuario(1, email: 'novo@example.com');

    expect(requisicoes.map((request) => request.method), ['PATCH', 'PATCH']);
    expect(requisicoes.first.url.path, '/api/usuarios/1');
    expect(jsonDecode(requisicoes[0].body), {'nome': 'Nome atualizado'});
    expect(jsonDecode(requisicoes[1].body), {'email': 'novo@example.com'});
  });
}
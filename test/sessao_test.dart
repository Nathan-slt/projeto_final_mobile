import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_final/core/auth/sessao.dart';
import 'package:projeto_final/core/models/usuario.dart';

/// Monta um JWT de mentira (a assinatura não é lida pelo app).
String _token(Map<String, dynamic> payload) {
  String b64(Object o) =>
      base64Url.encode(utf8.encode(jsonEncode(o))).replaceAll('=', '');
  return '${b64({'alg': 'HS256', 'typ': 'JWT'})}.${b64(payload)}.assinatura';
}

int _emSegundos(DateTime d) => d.millisecondsSinceEpoch ~/ 1000;

void main() {
  test('lê os dados do paciente a partir do token', () {
    final exp = DateTime.now().add(const Duration(hours: 8));
    final sessao = Sessao.fromToken(_token({
      'id_usuario': 7,
      'papel': 'paciente',
      'id_paciente': 3,
      'id_clinica': null,
      'exp': _emSegundos(exp),
    }));

    expect(sessao.idUsuario, 7);
    expect(sessao.papel, PapelUsuario.paciente);
    expect(sessao.idPaciente, 3);
    expect(sessao.idClinica, isNull);
    expect(sessao.expirada, isFalse);
  });

  test('token com exp no passado está expirado', () {
    final exp = DateTime.now().subtract(const Duration(minutes: 1));
    final sessao = Sessao.fromToken(_token({
      'id_usuario': 1,
      'papel': 'paciente',
      'exp': _emSegundos(exp),
    }));

    expect(sessao.expirada, isTrue);
  });

  test('token malformado lança FormatException', () {
    expect(() => Sessao.fromToken('lixo'), throwsFormatException);
    expect(() => Sessao.fromToken('a.b.c'), throwsFormatException);
  });

  test('token sem id_usuario ou com papel desconhecido é rejeitado', () {
    expect(
      () => Sessao.fromToken(_token({'papel': 'paciente'})),
      throwsFormatException,
    );
    expect(
      () => Sessao.fromToken(_token({'id_usuario': 1, 'papel': 'alien'})),
      throwsFormatException,
    );
  });
}

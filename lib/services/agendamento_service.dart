import 'package:flutter/foundation.dart';
import 'package:projeto_final/core/models/agendamento.dart';
import 'package:projeto_final/core/models/agendamento_detalhado.dart';
import 'package:projeto_final/core/network/api_client.dart';
import 'package:projeto_final/core/network/api_exception.dart';
import 'package:projeto_final/services/auth_service.dart';

/// Agendamentos do paciente logado.
class AgendamentoService {
  AgendamentoService({ApiClient? api}) : _api = api ?? ApiClient.instance;

  /// Instância usada pelo app. Pode ser trocada em testes.
  static AgendamentoService instance = AgendamentoService();

  /// Sobe a cada mudança (criar, cancelar, remarcar). As telas que mostram
  /// agendamentos escutam isto e recarregam.
  static final ValueNotifier<int> alteracoes = ValueNotifier<int>(0);

  static void notificarAlteracao() => alteracoes.value++;

  final ApiClient _api;

  /// Todos os agendamentos do paciente, do mais antigo para o mais novo.
  ///
  /// O backend devolve `/agendamentos/paciente/:id` só com IDs. Para mostrar
  /// nome do médico, especialidade e clínica, busca também `/profissionais`
  /// (que já traz a especialidade) e `/clinica`, e junta tudo aqui.
  Future<List<AgendamentoDetalhado>> listarMeus() async {
    final idPaciente = AuthService.instance.sessao?.idPaciente;
    if (idPaciente == null) {
      throw const ApiException('Sessão inválida. Faça login novamente.');
    }

    final respostas = await Future.wait<dynamic>([
      _api.get('/agendamentos/paciente/$idPaciente'),
      _api.get('/profissionais'),
      _api.get('/clinica'),
    ]);

    try {
      final agendamentos =
          _lista(respostas[0]).map(Agendamento.fromJson).toList();
      final profissionais = {
        for (final p in _lista(respostas[1])) p['id_profissional'] as int: p,
      };
      final clinicas = {
        for (final c in _lista(respostas[2])) c['id_clinica'] as int: c,
      };

      final detalhados = agendamentos.map((a) {
        final profissional = profissionais[a.idProfissional];
        final especialidade = profissional?['Especialidade'];
        final clinica = clinicas[a.idClinica];

        return AgendamentoDetalhado(
          agendamento: a,
          medico: profissional?['nome'] as String? ?? 'Profissional',
          especialidade:
              especialidade is Map ? (especialidade['nome'] as String?) ?? '' : '',
          clinica: clinica?['nome'] as String? ?? 'Clínica',
          endereco: clinica?['endereco'] as String?,
        );
      }).toList();

      detalhados.sort((a, b) => a.data.compareTo(b.data));
      return detalhados;
    } on FormatException {
      throw const ApiException('Resposta inesperada do servidor.');
    } on TypeError {
      throw const ApiException('Resposta inesperada do servidor.');
    }
  }

  List<Map<String, dynamic>> _lista(dynamic dado) {
    if (dado is! List) throw const FormatException('Esperava uma lista.');
    return dado.cast<Map<String, dynamic>>();
  }
}
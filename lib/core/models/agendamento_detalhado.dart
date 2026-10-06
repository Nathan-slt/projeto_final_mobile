import 'package:projeto_final/core/models/agendamento.dart';

/// Um agendamento já com os nomes prontos para exibir na tela.
///
/// A API devolve o agendamento só com IDs (profissional, clínica); o
/// `AgendamentoService` junta com as listas de profissionais e clínicas.
class AgendamentoDetalhado {
  final Agendamento agendamento;
  final String medico;
  final String especialidade;
  final String clinica;
  final String? endereco;

  const AgendamentoDetalhado({
    required this.agendamento,
    required this.medico,
    required this.especialidade,
    required this.clinica,
    this.endereco,
  });

  /// Data e hora da consulta, no fuso do aparelho.
  DateTime get data => agendamento.dataHoraConsulta;

  StatusAgendamento get status => agendamento.status;

  /// Ainda vale: nem cancelada nem já realizada (agendada ou remarcada).
  bool get ativo =>
      status == StatusAgendamento.agendado ||
      status == StatusAgendamento.remarcado;
}
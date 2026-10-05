/// Consulta exibida no histórico (dados já "montados" para a tela).
///
/// Diferente de `core/models/agendamento.dart`, que espelha a tabela
/// `agendamentos` (só IDs), esta classe traz nomes prontos para exibir.
class Consulta {
  final String medico;
  final String especialidade;
  final String tipoExame;
  final String clinica;
  final String endereco;
  final DateTime data;

  /// Texto livre da consulta. `-` quando não há observações.
  final String observacoes;

  /// Ex.: Consultório, Telemedicina.
  final String tipoLocal;
  final String? fotoUrl;

  const Consulta({
    required this.medico,
    required this.especialidade,
    required this.tipoExame,
    required this.clinica,
    required this.endereco,
    required this.data,
    this.observacoes = '-',
    this.tipoLocal = 'Consultório',
    this.fotoUrl,
  });
}

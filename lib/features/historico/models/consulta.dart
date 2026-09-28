/// Modelo simples de consulta.
class Consulta {
  final String medico;
  final String especialidade;
  final String tipoExame;
  final String tipoLocal; // ex.: "Consultório"
  final String clinica;
  final String endereco;
  final String observacoes;
  final DateTime data;
  final String? fotoUrl;

  const Consulta({
    required this.medico,
    required this.especialidade,
    required this.tipoExame,
    required this.clinica,
    required this.endereco,
    required this.data,
    this.tipoLocal = 'Consultório',
    this.observacoes = '-',
    this.fotoUrl,
  });
}

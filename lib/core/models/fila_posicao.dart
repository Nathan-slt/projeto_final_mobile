class FilaPosicao {
  final String codigoAtendimento;
  final String status;
  final int posicao;
  final String profissional;
  final String especialidade;

  const FilaPosicao({
    required this.codigoAtendimento,
    required this.status,
    required this.posicao,
    required this.profissional,
    required this.especialidade,
  });

  factory FilaPosicao.fromJson(Map<String, dynamic> json) {
    final codigo = json['codigo_atendimento'];
    final status = json['status'];
    final posicao = json['posicao'];
    final profissional = json['profissional'];
    final especialidade = json['especialidade'];

    if (codigo is! String || codigo.isEmpty ||
        status is! String ||
        posicao is! int ||
        profissional is! String ||
        profissional.isEmpty ||
        especialidade is! String ||
        especialidade.isEmpty) {
      throw const FormatException('Posição da fila inválida.');
    }

    return FilaPosicao(
      codigoAtendimento: codigo,
      status: status,
      posicao: posicao,
      profissional: profissional,
      especialidade: especialidade,
    );
  }
}

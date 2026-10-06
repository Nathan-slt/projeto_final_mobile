import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_final/core/models/agendamento.dart';
import 'package:projeto_final/core/models/agendamento_detalhado.dart';

void main() {
  test('aplica três horas ao horário do agendamento', () {
    final horarioRecebido = DateTime(2026, 10, 6, 10);
    final agendamento = Agendamento(
      idAgendamento: 1,
      idPaciente: 2,
      idProfissional: 3,
      idClinica: 4,
      idHorario: 5,
      dataHoraConsulta: horarioRecebido,
      criadoPorUsuario: 6,
    );
    final detalhado = AgendamentoDetalhado(
      agendamento: agendamento,
      medico: 'Profissional',
      especialidade: 'Clínica geral',
      clinica: 'Clínica',
    );

    expect(detalhado.data, DateTime(2026, 10, 6, 13));
    expect(agendamento.dataHoraConsulta, horarioRecebido);
  });
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_final/app/theme.dart';
import 'package:projeto_final/core/models/agendamento.dart';
import 'package:projeto_final/core/models/agendamento_detalhado.dart';
import 'package:projeto_final/features/home/widgets/agendamento_card.dart';

AgendamentoDetalhado _consulta(int id, DateTime data) {
  return AgendamentoDetalhado(
    agendamento: Agendamento(
      idAgendamento: id,
      idPaciente: 2,
      idProfissional: 3,
      idClinica: 4,
      idHorario: 5,
      dataHoraConsulta: data,
      criadoPorUsuario: 6,
    ),
    medico: 'Dra. Maria Silva',
    especialidade: 'Cardiologia',
    clinica: 'Clínica MedLink',
  );
}

void main() {
  testWidgets('a divisória vertical ocupa toda a altura do card',
      (tester) async {
    tester.view.physicalSize = const Size(390, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    final consulta = _consulta(1, DateTime(2026, 10, 6, 14));

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AgendamentoCard(consulta: consulta),
          ),
        ),
      ),
    );

    final cardSize = tester.getSize(find.byKey(const ValueKey('agendamento-card-1')));
    final divisoriaSize = tester.getSize(
      find.byKey(const ValueKey('agendamento-card-divider-1')),
    );
    expect(cardSize.height, greaterThanOrEqualTo(110));
    expect(divisoriaSize.height, cardSize.height);
    expect(tester.takeException(), isNull);
  });

  testWidgets('coluna de horário fica alinhada entre cards com horários diferentes',
      (tester) async {
    tester.view.physicalSize = const Size(390, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                AgendamentoCard(
                  consulta: _consulta(1, DateTime(2026, 10, 6, 5)),
                ),
                const SizedBox(height: 8),
                AgendamentoCard(
                  consulta: _consulta(2, DateTime(2026, 10, 6, 11)),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final primeiraDivisoria = tester.getTopLeft(
      find.byKey(const ValueKey('agendamento-card-divider-1')),
    );
    final segundaDivisoria = tester.getTopLeft(
      find.byKey(const ValueKey('agendamento-card-divider-2')),
    );
    final primeiroHorario = tester.getTopLeft(find.text('08:00h'));
    final segundoHorario = tester.getTopLeft(find.text('14:00h'));

    expect(segundaDivisoria.dx, primeiraDivisoria.dx);
    expect(segundoHorario.dx, primeiroHorario.dx);
    expect(tester.takeException(), isNull);
  });
}
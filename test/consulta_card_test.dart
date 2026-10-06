import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_final/app/theme.dart';
import 'package:projeto_final/features/historico/models/consulta.dart';
import 'package:projeto_final/features/historico/widgets/consulta_card.dart';

void main() {
  testWidgets('ConsultaCard mostra médico, data e hora sem observações',
      (tester) async {
    final consulta = Consulta(
      medico: 'Dr. Tom Holland',
      especialidade: 'Oftalmologista',
      tipoExame: 'Exame de Vista',
      clinica: 'Clínica Vista+',
      endereco: 'Rua Amélia Prado, 560',
      data: DateTime(2026, 8, 24, 14, 5),
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        home: Scaffold(body: ConsultaCard(consulta: consulta)),
      ),
    );

    expect(find.text('Dr. Tom Holland'), findsOneWidget);
    expect(find.text('24'), findsOneWidget);
    expect(find.text('AGO'), findsOneWidget);
    expect(find.text('14:05h'), findsOneWidget);
    expect(find.text('Consultório'), findsOneWidget);
    expect(find.text('Observações'), findsNothing);
  });
}

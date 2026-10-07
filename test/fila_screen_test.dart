import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:projeto_final/core/models/fila_posicao.dart';
import 'package:projeto_final/features/fila/screens/fila_screen.dart';
import 'package:projeto_final/services/fila_service.dart';

class _FilaServiceFake extends FilaService {
  _FilaServiceFake(this.resposta);

  final FilaPosicao? resposta;
  int consultas = 0;

  @override
  Future<FilaPosicao?> minhaPosicao() async {
    consultas++;
    return resposta;
  }
}

void main() {
  testWidgets('oculta identificador e posição até o check-in', (tester) async {
    final service = _FilaServiceFake(null);
    await tester.pumpWidget(
      MaterialApp(home: FilaScreen(isActive: true, service: service)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Você ainda não está na fila.'), findsOneWidget);
    expect(find.text('SEU IDENTIFICADOR'), findsNothing);
    expect(find.text('POSIÇÃO NA FILA'), findsNothing);
    expect(service.consultas, 1);

    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'mostra os valores enviados pelo backend e atualiza por polling',
    (tester) async {
      final service = _FilaServiceFake(
        const FilaPosicao(
          codigoAtendimento: 'C123',
          status: 'aguardando',
          posicao: 2,
          profissional: 'Dra. Juliana Martins',
          especialidade: 'Ortopedia',
        ),
      );
      await tester.pumpWidget(
        MaterialApp(home: FilaScreen(isActive: true, service: service)),
      );
      await tester.pumpAndSettle();

      expect(find.text('C123'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
      expect(find.text('Dra. Juliana Martins'), findsOneWidget);
      expect(find.text('Ortopedia'), findsOneWidget);
      expect(find.text('Fila em tempo real'), findsOneWidget);

      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();
      expect(service.consultas, 2);

      await tester.pumpWidget(const SizedBox());
    },
  );
}

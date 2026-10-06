import 'package:flutter/material.dart';
import 'package:projeto_final/core/models/agendamento.dart';
import 'package:projeto_final/core/network/api_exception.dart';
import 'package:projeto_final/core/widgets/app_bar.dart';
import 'package:projeto_final/features/historico/models/consulta.dart';
import 'package:projeto_final/features/historico/widgets/consulta_card.dart';
import 'package:projeto_final/services/agendamento_service.dart';

/// Aba "Histórico". O rodapé fica no [MainShellScreen].
class HistoricoScreen extends StatefulWidget {
  const HistoricoScreen({super.key});

  @override
  State<HistoricoScreen> createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  List<Consulta> _consultas = const [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    AgendamentoService.alteracoes.addListener(_carregar);
    _carregar();
  }

  @override
  void dispose() {
    AgendamentoService.alteracoes.removeListener(_carregar);
    super.dispose();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      final agendamentos = await AgendamentoService.instance.listarMeus();
      final agora = DateTime.now();
      final consultas = agendamentos
          .where((agendamento) =>
              agendamento.status != StatusAgendamento.cancelado)
          .where((agendamento) =>
              agendamento.status == StatusAgendamento.realizado ||
              !agendamento.data.isAfter(agora))
          .map(Consulta.fromAgendamento)
          .toList()
        ..sort((a, b) => b.data.compareTo(a.data));

      if (!mounted) return;
      setState(() {
        _consultas = consultas;
        _carregando = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = e.mensagem;
        _carregando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = (screenWidth * 0.045).clamp(16.0, 32.0);

    return Scaffold(
      appBar: const AppBarWidget(),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'Últimas consultas',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(child: _buildConteudo(horizontalPadding)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConteudo(double horizontalPadding) {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_erro != null) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_erro!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              TextButton(
                onPressed: _carregar,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    if (_consultas.isEmpty) {
      return const Center(child: Text('Nenhuma consulta no histórico.'));
    }

    return ListView.separated(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        0,
        horizontalPadding,
        16,
      ),
      itemCount: _consultas.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => ConsultaCard(
        consulta: _consultas[index],
      ),
    );
  }
}

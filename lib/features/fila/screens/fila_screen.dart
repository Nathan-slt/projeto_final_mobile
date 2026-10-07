import 'dart:async';

import 'package:flutter/material.dart';
import 'package:projeto_final/core/models/fila_posicao.dart';
import 'package:projeto_final/core/network/api_exception.dart';
import 'package:projeto_final/core/widgets/app_bar.dart';
import 'package:projeto_final/services/fila_service.dart';

/// Aba "Fila". O rodapé fica no [MainShellScreen].
class FilaScreen extends StatefulWidget {
  final bool isActive;
  final FilaService service;

  FilaScreen({super.key, required this.isActive, FilaService? service})
    : service = service ?? FilaService.instance;

  @override
  State<FilaScreen> createState() => _FilaScreenState();
}

class _FilaScreenState extends State<FilaScreen> {
  static const _intervaloAtualizacao = Duration(seconds: 5);

  Timer? _timer;
  FilaPosicao? _fila;
  String? _erro;
  bool _consultando = false;
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    if (widget.isActive) _iniciarAtualizacao();
  }

  @override
  void didUpdateWidget(covariant FilaScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive == widget.isActive) return;

    if (widget.isActive) {
      _iniciarAtualizacao();
    } else {
      _pararAtualizacao();
    }
  }

  @override
  void dispose() {
    _pararAtualizacao();
    super.dispose();
  }

  void _iniciarAtualizacao() {
    _pararAtualizacao();
    _consultar();
    _timer = Timer.periodic(_intervaloAtualizacao, (_) => _consultar());
  }

  void _pararAtualizacao() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _consultar() async {
    if (_consultando || !mounted || !widget.isActive) return;
    _consultando = true;
    try {
      final fila = await widget.service.minhaPosicao();
      if (!mounted) return;
      setState(() {
        _fila = fila;
        _erro = null;
        _carregando = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _erro = e.mensagem;
        _carregando = false;
      });
    } finally {
      _consultando = false;
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: _carregando
                ? const Center(child: CircularProgressIndicator())
                : _erro != null && _fila == null
                ? _buildErro(context)
                : _fila == null
                ? _buildSemCheckin(context)
                : _buildFila(context, _fila!),
          ),
        ),
      ),
    );
  }

  Widget _buildErro(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_erro!, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _consultar,
            child: const Text('Tentar novamente'),
          ),
          const SizedBox(height: 8),
          Icon(Icons.error_outline, color: scheme.error),
        ],
      ),
    );
  }

  Widget _buildSemCheckin(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.hourglass_empty, size: 44, color: primary),
          const SizedBox(height: 16),
          Text(
            'Você ainda não está na fila.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: primary,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'A recepção precisa registrar seu check-in para você acompanhar a fila.',
            textAlign: TextAlign.center,
            style: TextStyle(color: primary),
          ),
          if (_erro != null) ...[
            const SizedBox(height: 12),
            Text(
              'Não foi possível atualizar: $_erro',
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFila(BuildContext context, FilaPosicao fila) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final scheme = Theme.of(context).colorScheme;
    final boxWidth = (screenWidth * 0.65).clamp(220.0, 260.0);
    final boxHeight = (screenWidth * 0.31).clamp(115.0, 125.0);
    final mainFontSize = (screenWidth * 0.15).clamp(48.0, 60.0);
    final titleFontSize = (screenWidth * 0.04).clamp(14.0, 16.0);
    final statusFontSize = (screenWidth * 0.035).clamp(13.0, 14.0);

    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              fila.profissional,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: scheme.primary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              fila.especialidade,
              textAlign: TextAlign.center,
              style: TextStyle(color: scheme.primary, fontSize: 16),
            ),
            const SizedBox(height: 24),
            Container(
              width: boxWidth,
              constraints: BoxConstraints(minHeight: boxHeight),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'SEU IDENTIFICADOR',
                    style: TextStyle(
                      color: scheme.inversePrimary,
                      fontSize: titleFontSize,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    fila.codigoAtendimento,
                    style: TextStyle(
                      color: scheme.onPrimary,
                      fontSize: mainFontSize,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: (screenWidth * 0.06).clamp(20.0, 25.0)),
            Text(
              'POSIÇÃO NA FILA',
              style: TextStyle(
                color: scheme.primary,
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              '${fila.posicao}',
              style: TextStyle(
                color: scheme.primary,
                fontSize: mainFontSize,
                fontWeight: FontWeight.w500,
                height: 1,
              ),
            ),
            SizedBox(height: (screenWidth * 0.07).clamp(24.0, 30.0)),
            Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: screenWidth - 32),
              padding: EdgeInsets.symmetric(
                horizontal: (screenWidth * 0.045).clamp(16.0, 18.0),
                vertical: (screenWidth * 0.025).clamp(8.0, 10.0),
              ),
              decoration: BoxDecoration(
                color: _erro == null
                    ? scheme.tertiaryContainer
                    : scheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.circle,
                    color: _erro == null ? scheme.tertiary : scheme.error,
                    size: 6,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      _erro == null
                          ? 'Fila em tempo real'
                          : 'Falha ao atualizar; tentando novamente',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: _erro == null
                            ? scheme.onTertiaryContainer
                            : scheme.onErrorContainer,
                        fontSize: statusFontSize,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

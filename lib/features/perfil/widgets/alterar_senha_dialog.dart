import 'package:flutter/material.dart';
import 'package:projeto_final/core/network/api_exception.dart';
import 'package:projeto_final/services/perfil_service.dart';

/// Diálogo de troca de senha. Fecha com `true` quando a senha foi alterada.
class AlterarSenhaDialog extends StatefulWidget {
  final int idUsuario;

  const AlterarSenhaDialog({super.key, required this.idUsuario});

  @override
  State<AlterarSenhaDialog> createState() => _AlterarSenhaDialogState();
}

class _AlterarSenhaDialogState extends State<AlterarSenhaDialog> {
  static const _tamanhoMinimo = 6;

  final _formKey = GlobalKey<FormState>();
  final _atualController = TextEditingController();
  final _novaController = TextEditingController();
  final _confirmarController = TextEditingController();

  bool _enviando = false;
  String? _erro;

  @override
  void dispose() {
    _atualController.dispose();
    _novaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    if (_enviando) return;
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() {
      _enviando = true;
      _erro = null;
    });

    try {
      await PerfilService.instance.alterarSenha(
        idUsuario: widget.idUsuario,
        senhaAtual: _atualController.text,
        novaSenha: _novaController.text,
      );
      if (!mounted) return;
      Navigator.pop(context, true);
    } on ApiException catch (e) {
      _mostrarErro(e.mensagem);
    } catch (_) {
      _mostrarErro('Não foi possível alterar a senha. Tente novamente.');
    }
  }

  void _mostrarErro(String mensagem) {
    if (!mounted) return;
    setState(() {
      _erro = mensagem;
      _enviando = false;
    });
  }

  Widget _campo({
    required String rotulo,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputAction acao = TextInputAction.next,
    VoidCallback? aoEnviar,
  }) {
    return TextFormField(
      controller: controller,
      enabled: !_enviando,
      obscureText: true,
      textInputAction: acao,
      onFieldSubmitted: aoEnviar == null ? null : (_) => aoEnviar(),
      decoration: InputDecoration(labelText: rotulo),
      validator: validator,
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: !_enviando,
      child: AlertDialog(
        backgroundColor: scheme.surface,
        title: const Text('Alterar senha'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _campo(
                  rotulo: 'Senha atual',
                  controller: _atualController,
                  validator: (v) =>
                      (v == null || v.isEmpty) ? 'Informe a senha atual' : null,
                ),
                _campo(
                  rotulo: 'Nova senha',
                  controller: _novaController,
                  validator: (v) {
                    if (v == null || v.length < _tamanhoMinimo) {
                      return 'Use ao menos $_tamanhoMinimo caracteres';
                    }
                    if (v == _atualController.text) {
                      return 'A nova senha deve ser diferente da atual';
                    }
                    return null;
                  },
                ),
                _campo(
                  rotulo: 'Confirmar nova senha',
                  controller: _confirmarController,
                  acao: TextInputAction.done,
                  aoEnviar: _salvar,
                  validator: (v) =>
                      v != _novaController.text ? 'As senhas não conferem' : null,
                ),
                if (_erro != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    _erro!,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: scheme.error, fontSize: 14),
                  ),
                ],
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: _enviando ? null : () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: _enviando ? null : _salvar,
            style: FilledButton.styleFrom(
              backgroundColor: scheme.secondary,
              foregroundColor: scheme.onSecondary,
            ),
            child: _enviando
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Text('Alterar'),
          ),
        ],
      ),
    );
  }
}

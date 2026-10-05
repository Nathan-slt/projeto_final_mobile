import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Campo de formulário das telas de autenticação: rótulo em negrito em cima e
/// campo com linha embaixo (mesmo visual do login).
///
/// Com [senha] = true, esconde o texto e mostra o botão de "olhinho".
class CampoAuth extends StatefulWidget {
  final String rotulo;
  final TextEditingController controller;
  final String hint;
  final IconData icone;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final ValueChanged<String>? onFieldSubmitted;
  final bool enabled;
  final bool senha;

  /// Campo que não abre o teclado (ex.: data escolhida num calendário).
  final bool readOnly;
  final VoidCallback? onTap;
  final Widget? sufixo;

  const CampoAuth({
    super.key,
    required this.rotulo,
    required this.controller,
    required this.hint,
    required this.icone,
    this.validator,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.inputFormatters,
    this.autofillHints,
    this.onFieldSubmitted,
    this.enabled = true,
    this.senha = false,
    this.readOnly = false,
    this.onTap,
    this.sufixo,
  });

  @override
  State<CampoAuth> createState() => _CampoAuthState();
}

class _CampoAuthState extends State<CampoAuth> {
  bool _visivel = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    Widget? sufixo = widget.sufixo;
    if (widget.senha) {
      sufixo = IconButton(
        onPressed: () => setState(() => _visivel = !_visivel),
        icon: Icon(
          _visivel ? Icons.visibility : Icons.visibility_off,
          color: scheme.primary,
          size: 22,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.rotulo,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: scheme.primary,
          ),
        ),
        TextFormField(
          controller: widget.controller,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          showCursor: widget.readOnly ? false : null,
          onTap: widget.onTap,
          obscureText: widget.senha && !_visivel,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          inputFormatters: widget.inputFormatters,
          autofillHints: widget.autofillHints,
          onFieldSubmitted: widget.onFieldSubmitted,
          validator: widget.validator,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontSize: 14,
              color: scheme.primary.withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(widget.icone, color: scheme.primary, size: 22),
            prefixIconConstraints:
                const BoxConstraints(minWidth: 32, minHeight: 32),
            suffixIcon: sufixo,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: scheme.primary, width: 1),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: scheme.secondary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
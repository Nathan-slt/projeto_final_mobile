import 'package:flutter/material.dart';
import 'package:projeto_final/core/widgets/app_bar.dart';

// TODO: substituir estes dados de exemplo pelos da API (ApiService).
const Map<String, List<String>> _profissionaisPorEspecialidade = {
  'Cardiologia': ['Dr. Carlos Lima', 'Dra. Marina Alves'],
  'Clínico geral': ['Dra. Paula Ferreira', 'Dr. Ricardo Gomes'],
  'Dermatologia': ['Dra. Beatriz Costa'],
  'Oftalmologia': ['Dr. Tom Holland'],
  'Ortopedia': ['Dr. André Martins', 'Dra. Juliana Rocha'],
};

// TODO: os horários livres devem vir da API, conforme profissional e data.
final List<String> _horarios = [
  for (var h = 8; h < 18; h++)
    if (h != 12) // intervalo de almoço
      for (final m in [0, 30])
        '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}',
];

String _formatarData(DateTime d) {
  final dia = d.day.toString().padLeft(2, '0');
  final mes = d.month.toString().padLeft(2, '0');
  return '$dia/$mes/${d.year}';
}

/// Tela empilhada por cima do shell (aberta pelo botão "+" da Home).
/// Tem botão de voltar e não repete o rodapé.
class CriarAgendamentoScreen extends StatefulWidget {
  const CriarAgendamentoScreen({super.key});

  @override
  State<CriarAgendamentoScreen> createState() => _CriarAgendamentoScreenState();
}

class _CriarAgendamentoScreenState extends State<CriarAgendamentoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dataController = TextEditingController();

  // Só passa a validar enquanto o usuário digita depois da 1ª tentativa
  // de agendar, para não mostrar erros num formulário ainda vazio.
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  String? _especialidade;
  String? _profissional;
  DateTime? _data;
  String? _horario;

  @override
  void dispose() {
    _dataController.dispose();
    super.dispose();
  }

  Future<void> _selecionarData() async {
    final hoje = DateUtils.dateOnly(DateTime.now());

    final data = await showDatePicker(
      context: context,
      initialDate: _data ?? hoje,
      firstDate: hoje,
      lastDate: DateTime(hoje.year + 1, hoje.month, hoje.day),
      helpText: 'Selecione a data',
    );

    if (data == null || !mounted) return;

    setState(() {
      _data = data;
      _dataController.text = _formatarData(data);
    });
  }

  void _agendar() {
    final valido = _formKey.currentState?.validate() ?? false;

    if (!valido) {
      setState(() => _autovalidate = AutovalidateMode.onUserInteraction);
      return;
    }

    // TODO: enviar o agendamento para a API antes de fechar a tela.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Consulta com $_profissional em ${_dataController.text} '
          'às $_horario.',
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = (screenWidth * 0.045).clamp(16.0, 32.0);

    final profissionais =
        _profissionaisPorEspecialidade[_especialidade] ?? const <String>[];

    return Scaffold(
      appBar: const AppBarWidget(showBackButton: true),
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                16,
                horizontalPadding,
                24,
              ),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Criar agendamento',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),

                    _CampoDropdown(
                      rotulo: 'Especialidade',
                      hint: 'Selecione a especialidade médica',
                      mensagemErro: 'Selecione a especialidade',
                      opcoes: _profissionaisPorEspecialidade.keys.toList(),
                      onChanged: (valor) => setState(() {
                        _especialidade = valor;
                        _profissional = null; // lista depende da especialidade
                      }),
                    ),
                    const SizedBox(height: 20),

                    // A key recria o campo (e limpa a seleção) quando a
                    // especialidade muda. Fica desabilitado até escolher uma.
                    _CampoDropdown(
                      key: ValueKey('profissional-$_especialidade'),
                      rotulo: 'Profissional',
                      hint: 'Selecione o profissional',
                      mensagemErro: 'Selecione o profissional',
                      opcoes: profissionais,
                      onChanged: _especialidade == null
                          ? null
                          : (valor) => setState(() => _profissional = valor),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: _CampoComRotulo(
                            rotulo: 'Data',
                            child: TextFormField(
                              controller: _dataController,
                              readOnly: true,
                              showCursor: false,
                              onTap: _selecionarData,
                              style: TextStyle(
                                fontSize: 14,
                                color: scheme.primary,
                              ),
                              decoration: _decoracaoCampo(
                                context,
                                hint: 'dd/mm/aaaa',
                                suffixIcon: Icon(
                                  Icons.calendar_today_outlined,
                                  size: 20,
                                  color: scheme.primary,
                                ),
                              ),
                              validator: (valor) =>
                                  (valor == null || valor.isEmpty)
                                      ? 'Selecione a data'
                                      : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _CampoDropdown(
                            rotulo: 'Hora',
                            hint: 'Horário',
                            mensagemErro: 'Selecione o horário',
                            opcoes: _horarios,
                            onChanged: (valor) =>
                                setState(() => _horario = valor),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: scheme.secondary,
                                side: BorderSide(
                                  color: scheme.secondary,
                                  width: 1,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 46,
                            child: ElevatedButton(
                              onPressed: _agendar,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: scheme.secondary,
                                foregroundColor: scheme.onSecondary,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              child: const Text(
                                'Agendar',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Borda/preenchimento comuns a todos os campos do formulário.
InputDecoration _decoracaoCampo(
  BuildContext context, {
  String? hint,
  Widget? suffixIcon,
}) {
  final scheme = Theme.of(context).colorScheme;

  OutlineInputBorder borda(Color cor, [double largura = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: cor, width: largura),
    );
  }

  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      fontSize: 14,
      color: scheme.primary.withValues(alpha: 0.6),
    ),
    filled: true,
    fillColor: Colors.white,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    suffixIcon: suffixIcon,
    enabledBorder: borda(scheme.primary.withValues(alpha: 0.6)),
    disabledBorder: borda(scheme.primary.withValues(alpha: 0.25)),
    focusedBorder: borda(scheme.secondary, 1.5),
    errorBorder: borda(scheme.error),
    focusedErrorBorder: borda(scheme.error, 1.5),
  );
}

/// Rótulo em negrito acima de um campo (mesmo estilo do login).
class _CampoComRotulo extends StatelessWidget {
  final String rotulo;
  final Widget child;

  const _CampoComRotulo({required this.rotulo, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          rotulo,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

/// Campo de seleção (lista suspensa) com rótulo e validação de obrigatório.
/// Com [onChanged] nulo, o campo fica desabilitado.
class _CampoDropdown extends StatelessWidget {
  final String rotulo;
  final String hint;
  final String mensagemErro;
  final List<String> opcoes;
  final ValueChanged<String?>? onChanged;

  const _CampoDropdown({
    super.key,
    required this.rotulo,
    required this.hint,
    required this.mensagemErro,
    required this.opcoes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final habilitado = onChanged != null;

    return _CampoComRotulo(
      rotulo: rotulo,
      child: DropdownButtonFormField<String>(
        isExpanded: true,
        decoration: _decoracaoCampo(context),
        icon: const Icon(Icons.keyboard_arrow_down),
        iconEnabledColor: scheme.primary,
        iconDisabledColor: scheme.primary.withValues(alpha: 0.35),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(8),
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 14,
          color: scheme.primary,
        ),
        hint: Text(
          hint,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            color: scheme.primary.withValues(alpha: habilitado ? 0.6 : 0.35),
          ),
        ),
        items: [
          for (final opcao in opcoes)
            DropdownMenuItem<String>(value: opcao, child: Text(opcao)),
        ],
        onChanged: onChanged,
        validator: (valor) => valor == null ? mensagemErro : null,
      ),
    );
  }
}

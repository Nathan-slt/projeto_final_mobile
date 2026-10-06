import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:projeto_final/app/navigation.dart';
import 'package:projeto_final/app/routes.dart';
import 'package:projeto_final/core/network/api_exception.dart';
import 'package:projeto_final/core/utils/mascaras.dart';
import 'package:projeto_final/core/utils/validadores.dart';
import 'package:projeto_final/features/auth/widgets/campo_auth.dart';
import 'package:projeto_final/services/auth_service.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  static const _tamanhoMinimoSenha = 6;

  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _nascimentoController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarController = TextEditingController();

  // Só valida enquanto digita depois da 1ª tentativa de criar a conta.
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  DateTime? _dataNascimento;
  bool _carregando = false;
  String? _erro;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _nascimentoController.dispose();
    _telefoneController.dispose();
    _senhaController.dispose();
    _confirmarController.dispose();
    super.dispose();
  }

  Future<void> _selecionarNascimento() async {
    FocusScope.of(context).unfocus();
    final hoje = DateUtils.dateOnly(DateTime.now());

    final data = await showDatePicker(
      context: context,
      initialDate: _dataNascimento ?? DateTime(hoje.year - 30, 1, 1),
      firstDate: DateTime(1900),
      lastDate: hoje,
      initialDatePickerMode: DatePickerMode.year,
      helpText: 'Data de nascimento',
    );

    if (data == null || !mounted) return;

    setState(() {
      _dataNascimento = data;
      _nascimentoController.text = formatarData(data);
    });
  }

  Future<void> _criarConta() async {
    if (_carregando) return;
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() => _autovalidate = AutovalidateMode.onUserInteraction);
      return;
    }

    final nascimento = _dataNascimento;
    if (nascimento == null) return;

    setState(() {
      _carregando = true;
      _erro = null;
    });

    final auth = AuthService.instance;
    final email = _emailController.text.trim();
    final senha = _senhaController.text;

    try {
      await auth.cadastrar(
        nome: _nomeController.text,
        email: email,
        senha: senha,
        cpf: _cpfController.text,
        dataNascimento: nascimento,
        telefone: _telefoneController.text,
      );
    } on ApiException catch (e) {
      _mostrarErro(e.mensagem);
      return;
    } catch (_) {
      _mostrarErro('Não foi possível criar a conta. Tente novamente.');
      return;
    }

    // Conta criada. O cadastro não devolve token, então entramos em seguida.
    try {
      await auth.login(email: email, senha: senha);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (_) {
      AppNavigator.messengerKey.currentState
        ?..clearSnackBars()
        ..showSnackBar(
          const SnackBar(
            content: Text('Conta criada! Faça login para continuar.'),
          ),
        );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _mostrarErro(String mensagem) {
    if (!mounted) return;
    setState(() {
      _erro = mensagem;
      _carregando = false;
    });
  }

  void _irParaLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = (screenWidth * 0.045).clamp(16.0, 32.0);

    // O login troca para esta tela (não empilha), então o botão "voltar" do
    // Android leva ao login em vez de fechar o app.
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && !_carregando) _irParaLogin();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: scheme.surface,
          centerTitle: true,
          scrolledUnderElevation: 0,
          surfaceTintColor: Colors.transparent,
          toolbarHeight: 100,
          title: SizedBox(
            height: 70,
            width: 200,
            child: Center(
              child: SvgPicture.asset(
                'assets/images/medlink_dark.svg',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                0,
                horizontalPadding,
                24,
              ),
              child: Form(
                key: _formKey,
                autovalidateMode: _autovalidate,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Criar conta',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    CampoAuth(
                      rotulo: 'Nome completo',
                      controller: _nomeController,
                      hint: 'Seu nome',
                      icone: Icons.person_outline,
                      enabled: !_carregando,
                      keyboardType: TextInputType.name,
                      autofillHints: const [AutofillHints.name],
                      validator: (valor) {
                        final nome = valor?.trim() ?? '';
                        return nome.length < 3 ? 'Informe seu nome completo' : null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CampoAuth(
                      rotulo: 'Email',
                      controller: _emailController,
                      hint: 'nome@exemplo.com',
                      icone: Icons.mail_outline,
                      enabled: !_carregando,
                      keyboardType: TextInputType.emailAddress,
                      autofillHints: const [AutofillHints.email],
                      validator: (valor) {
                        final email = valor?.trim() ?? '';
                        if (email.isEmpty) return 'Informe seu e-mail';
                        if (!emailValido(email)) return 'E-mail inválido';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CampoAuth(
                      rotulo: 'CPF',
                      controller: _cpfController,
                      hint: '000.000.000-00',
                      icone: Icons.badge_outlined,
                      enabled: !_carregando,
                      keyboardType: TextInputType.number,
                      inputFormatters: [CpfInputFormatter()],
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return 'Informe seu CPF';
                        }
                        return cpfValido(valor) ? null : 'CPF inválido';
                      },
                    ),
                    const SizedBox(height: 20),
                    CampoAuth(
                      rotulo: 'Data de nascimento',
                      controller: _nascimentoController,
                      hint: 'dd/mm/aaaa',
                      icone: Icons.cake_outlined,
                      enabled: !_carregando,
                      readOnly: true,
                      onTap: _selecionarNascimento,
                      sufixo: Icon(
                        Icons.calendar_today_outlined,
                        size: 20,
                        color: scheme.primary,
                      ),
                      validator: (valor) => (valor == null || valor.isEmpty)
                          ? 'Selecione a data de nascimento'
                          : null,
                    ),
                    const SizedBox(height: 20),
                    CampoAuth(
                      rotulo: 'Telefone',
                      controller: _telefoneController,
                      hint: '(00)00000-0000',
                      icone: Icons.phone_outlined,
                      enabled: !_carregando,
                      keyboardType: TextInputType.phone,
                      autofillHints: const [AutofillHints.telephoneNumber],
                      inputFormatters: [TelefoneInputFormatter()],
                      validator: (valor) {
                        if (valor == null || valor.trim().isEmpty) {
                          return 'Informe seu telefone';
                        }
                        return telefoneValido(valor)
                            ? null
                            : 'Informe um telefone válido, com DDD';
                      },
                    ),
                    const SizedBox(height: 20),
                    CampoAuth(
                      rotulo: 'Senha',
                      controller: _senhaController,
                      hint: 'Crie uma senha',
                      icone: Icons.lock_outline,
                      enabled: !_carregando,
                      senha: true,
                      autofillHints: const [AutofillHints.newPassword],
                      validator: (valor) {
                        if (valor == null || valor.length < _tamanhoMinimoSenha) {
                          return 'Use ao menos $_tamanhoMinimoSenha caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CampoAuth(
                      rotulo: 'Confirmar senha',
                      controller: _confirmarController,
                      hint: 'Repita a senha',
                      icone: Icons.lock_outline,
                      enabled: !_carregando,
                      senha: true,
                      textInputAction: TextInputAction.done,
                      onFieldSubmitted: (_) => _criarConta(),
                      validator: (valor) => valor != _senhaController.text
                          ? 'As senhas não conferem'
                          : null,
                    ),
                    if (_erro != null) ...[
                      const SizedBox(height: 16),
                      Text(
                        _erro!,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: scheme.error),
                      ),
                    ],
                    const SizedBox(height: 25),
                    SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: _carregando ? null : _criarConta,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: scheme.secondary,
                          foregroundColor: Colors.white,
                          disabledBackgroundColor:
                              scheme.secondary.withValues(alpha: 0.6),
                          disabledForegroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: _carregando
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
                                'Criar conta',
                                style: TextStyle(fontSize: 16),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 46,
                      child: OutlinedButton(
                        onPressed: _carregando ? null : _irParaLogin,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: scheme.secondary,
                          side: BorderSide(color: scheme.secondary, width: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                        child: const Text(
                          'Já tenho uma conta',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
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
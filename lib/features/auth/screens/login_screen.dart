import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:projeto_final/app/routes.dart';
import 'package:projeto_final/core/network/api_exception.dart';
import 'package:projeto_final/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static final _regexEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _senhaFocus = FocusNode();

  // Só valida enquanto digita depois da 1ª tentativa de entrar, para não
  // mostrar erros num formulário ainda vazio.
  AutovalidateMode _autovalidate = AutovalidateMode.disabled;

  bool _senhaVisivel = false;
  bool _carregando = false;
  String? _erro;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    _senhaFocus.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    if (_carregando) return;
    FocusScope.of(context).unfocus();

    if (!(_formKey.currentState?.validate() ?? false)) {
      setState(() => _autovalidate = AutovalidateMode.onUserInteraction);
      return;
    }

    setState(() {
      _carregando = true;
      _erro = null;
    });

    try {
      await AuthService.instance.login(
        email: _emailController.text,
        senha: _senhaController.text,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } on ApiException catch (e) {
      _mostrarErro(e.mensagem);
    } catch (_) {
      // Ex.: falha ao gravar o token no armazenamento seguro do aparelho.
      _mostrarErro('Não foi possível entrar. Tente novamente.');
    }
  }

  void _mostrarErro(String mensagem) {
    if (!mounted) return;
    setState(() {
      _erro = mensagem;
      _carregando = false;
    });
  }

  InputDecoration _decoracao({
    required String hint,
    required IconData icone,
    Widget? suffixIcon,
  }) {
    final scheme = Theme.of(context).colorScheme;

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 14,
        color: scheme.primary.withValues(alpha: 0.6),
      ),
      prefixIcon: Icon(icone, color: scheme.primary, size: 22),
      prefixIconConstraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      suffixIcon: suffixIcon,
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: scheme.primary, width: 1),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: scheme.secondary, width: 1.5),
      ),
    );
  }

  Widget _rotulo(String texto) {
    return Text(
      texto,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final secondary = Theme.of(context).colorScheme.secondary;
    final erroCor = Theme.of(context).colorScheme.error;
    final screenWidth = MediaQuery.sizeOf(context).width;
    final horizontalPadding = (screenWidth * 0.045).clamp(16.0, 32.0);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
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
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Form(
                      key: _formKey,
                      autovalidateMode: _autovalidate,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Fazer login',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _rotulo('Email'),
                                TextFormField(
                                  controller: _emailController,
                                  enabled: !_carregando,
                                  keyboardType: TextInputType.emailAddress,
                                  textInputAction: TextInputAction.next,
                                  autofillHints: const [AutofillHints.email],
                                  onFieldSubmitted: (_) =>
                                      _senhaFocus.requestFocus(),
                                  decoration: _decoracao(
                                    hint: 'nome@exemplo.com',
                                    icone: Icons.mail_outline,
                                  ),
                                  validator: (valor) {
                                    final email = valor?.trim() ?? '';
                                    if (email.isEmpty) {
                                      return 'Informe seu e-mail';
                                    }
                                    if (!_regexEmail.hasMatch(email)) {
                                      return 'E-mail inválido';
                                    }
                                    return null;
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 25),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _rotulo('Senha'),
                                TextFormField(
                                  controller: _senhaController,
                                  focusNode: _senhaFocus,
                                  enabled: !_carregando,
                                  obscureText: !_senhaVisivel,
                                  textInputAction: TextInputAction.done,
                                  autofillHints: const [AutofillHints.password],
                                  onFieldSubmitted: (_) => _entrar(),
                                  decoration: _decoracao(
                                    hint: 'Digite sua senha',
                                    icone: Icons.lock_outline,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _senhaVisivel = !_senhaVisivel;
                                        });
                                      },
                                      icon: Icon(
                                        _senhaVisivel
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: primary,
                                        size: 22,
                                      ),
                                    ),
                                  ),
                                  validator: (valor) =>
                                      (valor == null || valor.isEmpty)
                                          ? 'Informe sua senha'
                                          : null,
                                ),
                              ],
                            ),
                          ),
                          if (_erro != null) ...[
                            const SizedBox(height: 16),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: horizontalPadding,
                              ),
                              child: Text(
                                _erro!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: erroCor,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 25),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 46,
                              child: ElevatedButton(
                                onPressed: _carregando ? null : _entrar,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: secondary,
                                  foregroundColor: Colors.white,
                                  disabledBackgroundColor:
                                      secondary.withValues(alpha: 0.6),
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
                                        'Entrar',
                                        style: TextStyle(fontSize: 16),
                                      ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                            ),
                            child: SizedBox(
                              width: double.infinity,
                              height: 46,
                              child: TextButton(
                                onPressed: _carregando
                                    ? null
                                    : () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          AppRoutes.senha,
                                        );
                                      },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  'Esqueceu sua senha?',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: secondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: horizontalPadding,
                  right: horizontalPadding,
                  bottom: 20,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: OutlinedButton(
                    onPressed: _carregando
                        ? null
                        : () {
                            Navigator.pushReplacementNamed(
                              context,
                              AppRoutes.cadastro,
                            );
                          },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: secondary,
                      side: BorderSide(color: secondary, width: 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Criar uma conta',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
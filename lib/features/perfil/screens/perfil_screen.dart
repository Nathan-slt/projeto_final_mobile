import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projeto_final/app/routes.dart';
import 'package:projeto_final/core/models/perfil.dart';
import 'package:projeto_final/core/network/api_exception.dart';
import 'package:projeto_final/core/utils/mascaras.dart';
import 'package:projeto_final/core/utils/validadores.dart';
import 'package:projeto_final/features/perfil/widgets/alterar_senha_dialog.dart';
import 'package:projeto_final/services/auth_service.dart';
import 'package:projeto_final/services/perfil_service.dart';

/// Aba "Perfil". O rodapé fica no [MainShellScreen].
class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _nomeFocus = FocusNode();
  final _telefoneFocus = FocusNode();
  final _emailFocus = FocusNode();

  Perfil? _perfil;
  bool _carregando = true;
  String? _erroCarga;

  bool _editandoNome = false;
  bool _salvandoNome = false;
  bool _editandoTelefone = false;
  bool _salvandoTelefone = false;
  bool _editandoEmail = false;
  bool _salvandoEmail = false;

  String _nomeSalvo = '';
  /// Último telefone confirmado (para detectar se houve mudança).
  String _telefoneSalvo = '';
  String _emailSalvo = '';

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _nomeFocus.dispose();
    _telefoneFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erroCarga = null;
    });

    try {
      final perfil = await PerfilService.instance.buscarPerfil();
      if (!mounted) return;
      setState(() {
        _perfil = perfil;
        _nomeSalvo = perfil.usuario.nome;
        _nomeController.text = perfil.usuario.nome;
        _emailSalvo = perfil.usuario.email;
        _emailController.text = perfil.usuario.email;
        _telefoneSalvo = formatarTelefone(perfil.telefone ?? '');
        _telefoneController.text = _telefoneSalvo;
        _carregando = false;
      });
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _erroCarga = e.mensagem;
        _carregando = false;
      });
    }
  }

  void _mostrarMensagem(String mensagem) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(mensagem)));
  }

  Future<void> _alternarEdicaoCampo({
    required bool editando,
    required bool salvando,
    required FocusNode focusNode,
    required VoidCallback iniciarEdicao,
    required Future<void> Function() salvar,
  }) async {
    if (salvando) return;

    if (!editando) {
      iniciarEdicao();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) focusNode.requestFocus();
      });
      return;
    }

    await salvar();
  }

  Future<void> _alternarEdicaoNome() => _alternarEdicaoCampo(
        editando: _editandoNome,
        salvando: _salvandoNome,
        focusNode: _nomeFocus,
        iniciarEdicao: () => setState(() => _editandoNome = true),
        salvar: _salvarNome,
      );

  Future<void> _alternarEdicaoEmail() => _alternarEdicaoCampo(
        editando: _editandoEmail,
        salvando: _salvandoEmail,
        focusNode: _emailFocus,
        iniciarEdicao: () => setState(() => _editandoEmail = true),
        salvar: _salvarEmail,
      );

  Future<void> _salvarNome() async {
    final perfil = _perfil;
    if (perfil == null) return;

    final novo = _nomeController.text.trim();
    if (novo.isEmpty) {
      _mostrarMensagem('Informe seu nome.');
      return;
    }
    if (novo == _nomeSalvo) {
      setState(() => _editandoNome = false);
      _nomeFocus.unfocus();
      return;
    }

    setState(() => _salvandoNome = true);
    try {
      await PerfilService.instance.atualizarDadosUsuario(
        perfil.usuario.idUsuario,
        nome: novo,
      );
      if (!mounted) return;
      setState(() {
        _nomeSalvo = novo;
        _nomeController.text = novo;
        _editandoNome = false;
        _salvandoNome = false;
      });
      _nomeFocus.unfocus();
      _mostrarMensagem('Nome atualizado.');
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _salvandoNome = false);
      _mostrarMensagem(e.mensagem);
    }
  }

  Future<void> _salvarEmail() async {
    final perfil = _perfil;
    if (perfil == null) return;

    final novo = _emailController.text.trim();
    if (!emailValido(novo)) {
      _mostrarMensagem('Informe um e-mail válido.');
      return;
    }
    if (novo == _emailSalvo) {
      setState(() => _editandoEmail = false);
      _emailFocus.unfocus();
      return;
    }

    setState(() => _salvandoEmail = true);
    try {
      await PerfilService.instance.atualizarDadosUsuario(
        perfil.usuario.idUsuario,
        email: novo,
      );
      if (!mounted) return;
      setState(() {
        _emailSalvo = novo;
        _emailController.text = novo;
        _editandoEmail = false;
        _salvandoEmail = false;
      });
      _emailFocus.unfocus();
      _mostrarMensagem('E-mail atualizado.');
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _salvandoEmail = false);
      _mostrarMensagem(e.mensagem);
    }
  }

  Future<void> _alternarEdicaoTelefone() async {
    if (_salvandoTelefone) return;

    if (!_editandoTelefone) {
      setState(() => _editandoTelefone = true);
      // Foca o campo no próximo frame, quando ele já virou um TextField.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _telefoneFocus.requestFocus();
      });
      return;
    }

    await _salvarTelefone();
  }

  Future<void> _salvarTelefone() async {
    final perfil = _perfil;
    if (perfil == null) return;

    final novo = _telefoneController.text.trim();

    if (novo == _telefoneSalvo) {
      setState(() => _editandoTelefone = false);
      _telefoneFocus.unfocus();
      return;
    }

    final digitos = novo.replaceAll(RegExp(r'\D'), '');
    if (digitos.length < 10 || digitos.length > 11) {
      _mostrarMensagem('Informe um telefone válido, com DDD.');
      return;
    }

    setState(() => _salvandoTelefone = true);

    try {
      await PerfilService.instance.atualizarTelefone(
        perfil.usuario.idUsuario,
        novo,
      );
      if (!mounted) return;
      setState(() {
        _telefoneSalvo = novo;
        _editandoTelefone = false;
        _salvandoTelefone = false;
      });
      _telefoneFocus.unfocus();
      _mostrarMensagem('Telefone atualizado.');
    } on ApiException catch (e) {
      if (!mounted) return;
      // Continua em edição para o usuário poder corrigir/tentar de novo.
      setState(() => _salvandoTelefone = false);
      _mostrarMensagem(e.mensagem);
    }
  }

  Future<void> _abrirAlterarSenha() async {
    final perfil = _perfil;
    if (perfil == null) return;

    final alterou = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlterarSenhaDialog(idUsuario: perfil.usuario.idUsuario),
    );

    if (alterou == true && mounted) {
      _mostrarMensagem('Senha alterada com sucesso.');
    }
  }

  Future<void> _sair() async {
    await AuthService.instance.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  Widget _buildHeader(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final width = MediaQuery.sizeOf(context).width;

    final avatarSize = (width * 0.34).clamp(96.0, 150.0);
    final logoHeight = (width * 0.095).clamp(28.0, 42.0);

    return Container(
      width: double.infinity,
      color: scheme.primary,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 16, 10, 14),
          child: Column(
            children: [
              Text(
                'Perfil',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: scheme.inversePrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  color: scheme.surface,
                  borderRadius: BorderRadius.circular(avatarSize * 0.28),
                ),
                child: Icon(
                  Icons.person_outline,
                  size: avatarSize * 0.77,
                  color: scheme.primary,
                ),
              ),
              const SizedBox(height: 14),
              Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  height: logoHeight,
                  child: SvgPicture.asset(
                    'assets/images/medlink.svg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(child: _buildCorpo(context)),
        ],
      ),
    );
  }

  Widget _buildCorpo(BuildContext context) {
    // Padding horizontal proporcional à largura da tela, igual à Home.
    final horizontalPadding =
        (MediaQuery.sizeOf(context).width * 0.045).clamp(16.0, 32.0);

    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    final secondary = Theme.of(context).colorScheme.secondary;

    return SingleChildScrollView(
      child: Center(
        // Em telas largas (tablet/web) o conteúdo não estica até a
        // borda, fica centralizado com largura máxima confortável.
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: 18,
            ),
            child: Column(
              children: [
                if (_erroCarga != null) ...[
                  Text(
                    _erroCarga!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _carregar,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Tentar novamente',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ] else ...[
                  _buildProfileField(
                    context,
                    'Nome',
                    _nomeController,
                    focusNode: _nomeFocus,
                    isEditing: _editandoNome,
                    salvando: _salvandoNome,
                    onToggleEdit: _alternarEdicaoNome,
                  ),
                  _buildProfileField(
                    context,
                    'Telefone',
                    _telefoneController,
                    focusNode: _telefoneFocus,
                    isEditing: _editandoTelefone,
                    salvando: _salvandoTelefone,
                    keyboardType: TextInputType.phone,
                    textoVazio: 'Não informado',
                    onToggleEdit: _alternarEdicaoTelefone,
                  ),
                  _buildProfileField(
                    context,
                    'Email',
                    _emailController,
                    focusNode: _emailFocus,
                    isEditing: _editandoEmail,
                    salvando: _salvandoEmail,
                    keyboardType: TextInputType.emailAddress,
                    onToggleEdit: _alternarEdicaoEmail,
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: _abrirAlterarSenha,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: secondary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: const Text(
                        'Alterar Senha',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: OutlinedButton(
                    onPressed: _sair,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: secondary,
                      side: BorderSide(
                        color: secondary,
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      'Sair',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Campo do perfil. Sem [onToggleEdit], o campo é só leitura (sem lápis).
  Widget _buildProfileField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    FocusNode? focusNode,
    bool isEditing = false,
    bool salvando = false,
    VoidCallback? onToggleEdit,
    TextInputType keyboardType = TextInputType.text,
    String textoVazio = '-',
  }) {
    final primary = Theme.of(context).colorScheme.primary;
    final vazio = controller.text.trim().isEmpty;

    final Widget acao;
    if (onToggleEdit == null) {
      acao = const SizedBox(width: 48, height: 48);
    } else if (salvando) {
      acao = const SizedBox(
        width: 48,
        height: 48,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    } else {
      acao = IconButton(
        onPressed: onToggleEdit,
        icon: Icon(
          isEditing ? Icons.check : Icons.edit,
          size: 20,
          color: primary,
        ),
        splashRadius: 20,
        tooltip: isEditing ? 'Salvar' : 'Editar',
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        left: 20,
        right: 12,
        top: 8,
        bottom: 8,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: primary.withValues(alpha: 0.5),
            width: 1.2,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: primary,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                // Enquanto não está em edição, mostra um Text simples
                // (não clicável/editável). Ao tocar no lápis, vira TextField.
                isEditing
                    ? TextField(
                        controller: controller,
                        focusNode: focusNode,
                        keyboardType: keyboardType,
                        autofocus: true,
                        enabled: !salvando,
                        onSubmitted: (_) => onToggleEdit?.call(),
                        style: TextStyle(
                          color: primary,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          isDense: true,
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      )
                    : Text(
                        vazio ? textoVazio : controller.text,
                        style: TextStyle(
                          color: vazio ? primary.withValues(alpha: 0.5) : primary,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ],
            ),
          ),
          acao,
        ],
      ),
    );
  }
}

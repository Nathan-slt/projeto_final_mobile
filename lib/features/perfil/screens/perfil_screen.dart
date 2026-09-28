import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projeto_final/app/routes.dart';

/// Aba "Perfil". O rodapé fica no [MainShellScreen].
class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  final _nomeController = TextEditingController(text: 'Kauan Santos');
  final _telefoneController = TextEditingController(text: '(12)99775-6565');
  final _emailController = TextEditingController(text: 'kauansnts@email.com');

  final _nomeFocus = FocusNode();
  final _telefoneFocus = FocusNode();
  final _emailFocus = FocusNode();

  bool _editandoNome = false;
  bool _editandoTelefone = false;
  bool _editandoEmail = false;

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

  void _toggleEdicao({
    required bool valorAtual,
    required void Function(bool) onChanged,
    required FocusNode focusNode,
  }) {
    final novoValor = !valorAtual;
    setState(() => onChanged(novoValor));

    if (novoValor) {
      // Entrando em modo de edição: foca o campo no próximo frame.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        focusNode.requestFocus();
      });
    } else {
      // Saindo do modo de edição: apenas fecha o teclado (o valor já
      // está salvo no controller).
      focusNode.unfocus();
    }
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
    final secondary = Theme.of(context).colorScheme.secondary;

    // Padding horizontal proporcional à largura da tela, igual à Home.
    final horizontalPadding =
        (MediaQuery.sizeOf(context).width * 0.045).clamp(16.0, 32.0);

    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),

          Expanded(
            child: SingleChildScrollView(
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
                        _buildProfileField(
                          context,
                          'Nome',
                          _nomeController,
                          focusNode: _nomeFocus,
                          isEditing: _editandoNome,
                          onToggleEdit: () => _toggleEdicao(
                            valorAtual: _editandoNome,
                            onChanged: (v) => _editandoNome = v,
                            focusNode: _nomeFocus,
                          ),
                        ),

                        _buildProfileField(
                          context,
                          'Telefone',
                          _telefoneController,
                          focusNode: _telefoneFocus,
                          isEditing: _editandoTelefone,
                          keyboardType: TextInputType.phone,
                          onToggleEdit: () => _toggleEdicao(
                            valorAtual: _editandoTelefone,
                            onChanged: (v) => _editandoTelefone = v,
                            focusNode: _telefoneFocus,
                          ),
                        ),

                        _buildProfileField(
                          context,
                          'Email',
                          _emailController,
                          focusNode: _emailFocus,
                          isEditing: _editandoEmail,
                          keyboardType: TextInputType.emailAddress,
                          onToggleEdit: () => _toggleEdicao(
                            valorAtual: _editandoEmail,
                            onChanged: (v) => _editandoEmail = v,
                            focusNode: _emailFocus,
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: ElevatedButton(
                            onPressed: () {},
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
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 10),

                        SizedBox(
                          width: double.infinity,
                          height: 46,
                          child: OutlinedButton(
                            onPressed: () {
                              Navigator.pushNamedAndRemoveUntil(
                                context,
                                AppRoutes.login,
                                (route) => false,
                              );
                            },
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField(
    BuildContext context,
    String label,
    TextEditingController controller, {
    required FocusNode focusNode,
    required bool isEditing,
    required VoidCallback onToggleEdit,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final primary = Theme.of(context).colorScheme.primary;

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
                        onSubmitted: (_) => onToggleEdit(),
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
                        controller.text,
                        style: TextStyle(
                          color: primary,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ],
            ),
          ),

          IconButton(
            onPressed: onToggleEdit,
            icon: Icon(
              isEditing ? Icons.check : Icons.edit,
              size: 20,
              color: primary,
            ),
            splashRadius: 20,
            tooltip: isEditing ? 'Salvar' : 'Editar',
          ),
        ],
      ),
    );
  }
}
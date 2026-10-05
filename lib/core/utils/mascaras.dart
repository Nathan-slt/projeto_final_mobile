import 'package:flutter/services.dart';
import 'package:projeto_final/core/utils/validadores.dart';

/// dd/mm/aaaa
String formatarData(DateTime d) {
  final dia = d.day.toString().padLeft(2, '0');
  final mes = d.month.toString().padLeft(2, '0');
  return '$dia/$mes/${d.year}';
}

/// aaaa-mm-dd (formato que o backend espera em campos de data).
String formatarDataIso(DateTime d) {
  final mes = d.month.toString().padLeft(2, '0');
  final dia = d.day.toString().padLeft(2, '0');
  return '${d.year}-$mes-$dia';
}

/// 52998224725 -> 529.982.247-25
String formatarCpf(String texto) {
  final digitos = apenasDigitos(texto);
  final d = digitos.length > 11 ? digitos.substring(0, 11) : digitos;

  final buffer = StringBuffer();
  for (var i = 0; i < d.length; i++) {
    if (i == 3 || i == 6) buffer.write('.');
    if (i == 9) buffer.write('-');
    buffer.write(d[i]);
  }
  return buffer.toString();
}

/// 12997756565 -> (12)99775-6565   |   1233334444 -> (12)3333-4444
String formatarTelefone(String texto) {
  final digitos = apenasDigitos(texto);
  final d = digitos.length > 11 ? digitos.substring(0, 11) : digitos;

  if (d.isEmpty) return '';
  // O ")" só entra com o 3º dígito, senão o backspace não consegue apagá-lo.
  if (d.length <= 2) return '($d';

  final ddd = d.substring(0, 2);
  final resto = d.substring(2);
  final corte = d.length > 10 ? 5 : 4; // celular: 5-4, fixo: 4-4

  if (resto.length <= corte) return '($ddd)$resto';
  return '($ddd)${resto.substring(0, corte)}-${resto.substring(corte)}';
}

class _MascaraFormatter extends TextInputFormatter {
  final String Function(String) formatar;

  const _MascaraFormatter(this.formatar);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue antigo,
    TextEditingValue novo,
  ) {
    final texto = formatar(novo.text);
    return TextEditingValue(
      text: texto,
      selection: TextSelection.collapsed(offset: texto.length),
    );
  }
}

class CpfInputFormatter extends _MascaraFormatter {
  CpfInputFormatter() : super(formatarCpf);
}

class TelefoneInputFormatter extends _MascaraFormatter {
  TelefoneInputFormatter() : super(formatarTelefone);
}
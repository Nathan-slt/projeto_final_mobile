/// Só os dígitos de um texto ("123.456" -> "123456").
String apenasDigitos(String texto) => texto.replaceAll(RegExp(r'\D'), '');

final RegExp _regexEmail = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

bool emailValido(String email) => _regexEmail.hasMatch(email.trim());

/// Telefone brasileiro com DDD: 10 (fixo) ou 11 dígitos (celular).
bool telefoneValido(String telefone) {
  final digitos = apenasDigitos(telefone);
  return digitos.length == 10 || digitos.length == 11;
}

/// Valida CPF pelos dígitos verificadores (aceita com ou sem máscara).
bool cpfValido(String cpf) {
  final d = apenasDigitos(cpf);
  if (d.length != 11) return false;
  if (RegExp(r'^(\d)\1{10}$').hasMatch(d)) return false; // 111.111.111-11...

  int digito(int quantos) {
    var soma = 0;
    for (var i = 0; i < quantos; i++) {
      soma += int.parse(d[i]) * (quantos + 1 - i);
    }
    final resto = (soma * 10) % 11;
    return resto == 10 ? 0 : resto;
  }

  return digito(9) == int.parse(d[9]) && digito(10) == int.parse(d[10]);
}
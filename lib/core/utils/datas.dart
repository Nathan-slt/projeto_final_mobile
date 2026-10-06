const _meses = [
  'JAN', 'FEV', 'MAR', 'ABR', 'MAI', 'JUN',
  'JUL', 'AGO', 'SET', 'OUT', 'NOV', 'DEZ',
];

/// 1 -> JAN ... 12 -> DEZ
String abreviacaoMes(int mes) => _meses[mes - 1];

/// 14:05 -> "14:05h"
String formatarHora(DateTime d) {
  final hora = d.hour.toString().padLeft(2, '0');
  final minuto = d.minute.toString().padLeft(2, '0');
  return '$hora:${minuto}h';
}
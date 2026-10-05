/// Configuração de acesso à API.
///
/// A URL pode ser trocada sem mexer no código, na hora de rodar/compilar:
///
///   flutter run --dart-define=API_URL=http://10.0.2.2:3000/api
///
/// (10.0.2.2 é o "localhost" do computador visto pelo emulador Android.)
class ApiConfig {
  ApiConfig._();

  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'http://168.138.142.124:3000/api',
  );

  /// Tempo máximo de espera por uma resposta do servidor.
  static const Duration timeout = Duration(seconds: 15);
}

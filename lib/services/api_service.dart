import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000/api';

  static Future<List<dynamic>> buscarAgendamentos() async {
    final response = await http.get(
      Uri.parse('$baseUrl/agendamentos'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro ao buscar agendamentos');
    }
  }
}
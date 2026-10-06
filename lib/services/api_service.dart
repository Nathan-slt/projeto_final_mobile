import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:projeto_final/core/config/api_config.dart';

class ApiService {
  static const String baseUrl = ApiConfig.baseUrl;

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
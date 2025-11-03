import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://tramitegraduadosudh.com/api/mobile';

  static Future<Map<String, dynamic>?> consultarTramite(String dni) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/consulta/$dni'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print('Error en la consulta: $e');
      return null;
    }
  }
}

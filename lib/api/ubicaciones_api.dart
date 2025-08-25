import 'dart:convert';
import 'package:http/http.dart' as http;

class UbicacionesApi {
  static const String baseUrl = 'https://example.com/api/ubicaciones';

  static Future<List<Map<String, dynamic>>> fetchUbicaciones() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Error al obtener las ubicaciones');
    }
  }
}

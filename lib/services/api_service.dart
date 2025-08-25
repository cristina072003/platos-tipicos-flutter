import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/plato.dart';
import '../models/usuario.dart';

class ApiService {
  static final String? _baseUrl = dotenv.env['API_BASE_URL'];

  static Future<Map<String, String>> _getHeaders() async {
    return {
      'Content-Type': 'application/json',
    };
  }

  // Autenticación
  static Future<Usuario> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/login'),
      headers: await _getHeaders(),
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Usuario.fromJson(data['user']);
    } else {
      throw Exception('Error en el login');
    }
  }

  static Future<Usuario> register(String nombre, String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/auth/register'),
      headers: await _getHeaders(),
      body: json.encode({'nombre': nombre, 'email': email, 'password': password}),
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return Usuario.fromJson(data['user']);
    } else {
      throw Exception('Error en el registro');
    }
  }

  // Obtener platos por categoría
  static Future<List<Plato>> getPlatosPorCategoria(String categoria) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/platos?categoria=$categoria'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Plato.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los platos');
    }
  }

  // Obtener todos los platos
  static Future<List<Plato>> getAllPlatos() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/platos'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Plato.fromJson(json)).toList();
    } else {
      throw Exception('Error al cargar los platos');
    }
  }

  // Crear un nuevo plato (CRUD)
  static Future<Plato> createPlato(Plato plato) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/platos'),
      headers: await _getHeaders(),
      body: json.encode(plato.toJson()),
    );

    if (response.statusCode == 201) {
      return Plato.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al crear el plato');
    }
  }

  // Actualizar un plato (CRUD)
  static Future<Plato> updatePlato(String id, Plato plato) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/platos/$id'),
      headers: await _getHeaders(),
      body: json.encode(plato.toJson()),
    );

    if (response.statusCode == 200) {
      return Plato.fromJson(json.decode(response.body));
    } else {
      throw Exception('Error al actualizar el plato');
    }
  }

  // Eliminar un plato (CRUD)
  static Future<void> deletePlato(String id) async {
    final response = await http.delete(
      Uri.parse('$_baseUrl/platos/$id'),
      headers: await _getHeaders(),
    );

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar el plato');
    }
  }
}
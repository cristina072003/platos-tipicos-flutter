import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/usuario.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  Usuario? _usuario;
  bool _isLoading = false;

  Usuario? get usuario => _usuario;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _usuario != null;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _usuario = await ApiService.login(email, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userToken', _usuario!.token);
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> register(String nombre, String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      _usuario = await ApiService.register(nombre, email, password);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userToken', _usuario!.token);
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> autoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('userToken');
    
    if (token != null) {
      // Aquí podrías implementar una verificación del token
      // Por simplicidad, asumimos que el token es válido
      _usuario = Usuario(id: 'temp', nombre: 'Usuario', email: 'user@example.com', token: token);
      notifyListeners();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
    _usuario = null;
    notifyListeners();
  }
}
import 'package:flutter/foundation.dart';
import '../models/plato.dart';
import '../services/api_service.dart';

class PlatosProvider with ChangeNotifier {
  List<Plato> _platos = [];
  List<Plato> _platosFiltrados = [];
  String _categoriaSeleccionada = 'Todos';

  List<Plato> get platos => _platosFiltrados;
  List<Plato> get todosLosPlatos => _platos;
  String get categoriaSeleccionada => _categoriaSeleccionada;

  Future<void> cargarPlatos() async {
    try {
      _platos = await ApiService.getAllPlatos();
      _platosFiltrados = _platos;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  void filtrarPorCategoria(String categoria) {
    _categoriaSeleccionada = categoria;
    if (categoria == 'Todos') {
      _platosFiltrados = _platos;
    } else {
      _platosFiltrados = _platos.where((plato) => plato.categoria == categoria).toList();
    }
    notifyListeners();
  }

  Future<void> agregarPlato(Plato plato) async {
    try {
      final nuevoPlato = await ApiService.createPlato(plato);
      _platos.add(nuevoPlato);
      filtrarPorCategoria(_categoriaSeleccionada);
    } catch (error) {
      rethrow;
    }
  }

  Future<void> actualizarPlato(String id, Plato plato) async {
    try {
      final platoActualizado = await ApiService.updatePlato(id, plato);
      final index = _platos.indexWhere((p) => p.id == id);
      if (index != -1) {
        _platos[index] = platoActualizado;
        filtrarPorCategoria(_categoriaSeleccionada);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> eliminarPlato(String id) async {
    try {
      await ApiService.deletePlato(id);
      _platos.removeWhere((plato) => plato.id == id);
      filtrarPorCategoria(_categoriaSeleccionada);
    } catch (error) {
      rethrow;
    }
  }
}
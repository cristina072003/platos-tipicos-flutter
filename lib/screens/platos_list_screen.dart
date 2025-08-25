import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/platos_provider.dart';
import '../widgets/plato_item.dart';

class PlatosListScreen extends StatefulWidget {
  const PlatosListScreen({super.key});

  @override
  _PlatosListScreenState createState() => _PlatosListScreenState();
}

class _PlatosListScreenState extends State<PlatosListScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      Provider.of<PlatosProvider>(context, listen: false).cargarPlatos();
    });
  }

  @override
  Widget build(BuildContext context) {
    final platosProvider = Provider.of<PlatosProvider>(context);
    final platos = platosProvider.platos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Platos Típicos de Cochabamba'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              platosProvider.filtrarPorCategoria(value);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'Todos', child: Text('Todos')),
              const PopupMenuItem(value: 'Desayuno', child: Text('Desayuno')),
              const PopupMenuItem(value: 'Almuerzo', child: Text('Almuerzo')),
              const PopupMenuItem(value: 'Cena', child: Text('Cena')),
            ],
          ),
        ],
      ),
      body: platos.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: platos.length,
              itemBuilder: (ctx, i) => PlatoItem(platos[i]),
            ),
    );
  }
}
import 'package:flutter/material.dart';
import '../models/plato.dart';

class PlatoDetailScreen extends StatelessWidget {
  static const routeName = '/plato-detail';

  const PlatoDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final plato = ModalRoute.of(context)!.settings.arguments as Plato;

    return Scaffold(
      appBar: AppBar(
        title: Text(plato.nombre),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 300,
              width: double.infinity,
              child: Image.network(
                plato.imagenUrl,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              plato.nombre,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'Precio: Bs. ${plato.precio.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                plato.descripcion,
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Lugares donde se puede consumir:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 10),
            Column(
              children: plato.lugares
                  .map((lugar) => Card(
                        child: ListTile(
                          leading: const Icon(Icons.restaurant),
                          title: Text(lugar),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
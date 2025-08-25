import 'package:flutter/material.dart';
import '../models/plato.dart';

class PlatoItem extends StatelessWidget {
  final Plato plato;

  const PlatoItem(this.plato, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: NetworkImage(plato.imagenUrl),
        ),
        title: Text(plato.nombre),
        subtitle: Text('Bs. ${plato.precio.toStringAsFixed(2)} - ${plato.categoria}'),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.of(context).pushNamed(
            '/plato-detail',
            arguments: plato,
          );
        },
      ),
    );
  }
}
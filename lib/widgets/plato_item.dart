import 'package:flutter/material.dart';
import 'package:platos_cochabamba/widgets/rating_stars.dart';
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
        leading: _buildImage(plato.imagenUrl),
        title: _buildTitle(plato.nombre),
        subtitle: _buildSubtitle(context, plato),
        onTap: () => _navigateToDetail(context, plato),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return CircleAvatar(
      backgroundImage: NetworkImage(imageUrl),
    );
  }

  Widget _buildTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildSubtitle(BuildContext context, Plato plato) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bs. ${plato.precio.toStringAsFixed(2)} - ${plato.categoria}'),
        const SizedBox(height: 4),
        RatingStars(rating: plato.rating),
      ],
    );
  }

  void _navigateToDetail(BuildContext context, Plato plato) {
    Navigator.of(context).pushNamed('/plato-detail', arguments: plato);
  }
}

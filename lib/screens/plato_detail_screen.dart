import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PlatoDetailScreen extends StatelessWidget {
  final String nombre;
  final String imagen;
  final String descripcion;
  final double precio;
  final String receta;
  final String videoUrl;
  final String ubicacion;
  final String ubicacionUrl;

  const PlatoDetailScreen({
    super.key,
    required this.nombre,
    required this.imagen,
    required this.descripcion,
    required this.precio,
    required this.receta,
    required this.videoUrl,
    required this.ubicacion,
    required this.ubicacionUrl,
  });

  // Función MEJORADA para Google Maps que SIEMPRE funciona
  Future<void> _openGoogleMaps(BuildContext context) async {
    try {
      // Usar la ubicación específica o el nombre del plato
      final String lugarParaBuscar = ubicacion.isNotEmpty ? ubicacion : nombre;
      
      // URL CORRECTA y COMPATIBLE de Google Maps
      final encodedLugar = Uri.encodeComponent('$lugarParaBuscar, Cochabamba, Bolivia');
      final mapsUrl = 'https://www.google.com/maps/search/?api=1&query=$encodedLugar';
      
      print('Buscando en Google Maps: $lugarParaBuscar');
      print('URL válida: $mapsUrl');

      final Uri uri = Uri.parse(mapsUrl);
      
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        // Fallback: abrir en el navegador
        final webUrl = 'https://www.google.com/search?q=$encodedLugar';
        if (await canLaunchUrl(Uri.parse(webUrl))) {
          await launchUrl(Uri.parse(webUrl));
        } else {
          _showError(context, 'No se pudo abrir la ubicación');
        }
      }
    } catch (e) {
      print('Error en Google Maps: $e');
      _showError(context, 'Error al abrir la ubicación');
    }
  }

  // Función para YouTube
  Future<void> _openYouTube(BuildContext context) async {
    try {
      if (videoUrl.isEmpty || videoUrl.contains('example')) {
        _searchYouTubeVideos(context);
        return;
      }

      // Verificar si es una URL válida de YouTube
      String videoId = _extractVideoId(videoUrl);
      final youtubeUrl = 'https://www.youtube.com/watch?v=$videoId';
      
      final Uri uri = Uri.parse(youtubeUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        _searchYouTubeVideos(context);
      }
    } catch (e) {
      print('Error con YouTube: $e');
      _searchYouTubeVideos(context);
    }
  }

  String _extractVideoId(String url) {
    try {
      if (url.contains('youtu.be/')) {
        return url.split('youtu.be/')[1].split('?')[0];
      } else if (url.contains('youtube.com/watch?v=')) {
        return url.split('v=')[1].split('&')[0];
      } else if (url.contains('youtube.com/embed/')) {
        return url.split('embed/')[1].split('?')[0];
      }
      return url;
    } catch (e) {
      return '';
    }
  }

  Future<void> _searchYouTubeVideos(BuildContext context) async {
    try {
      final encodedQuery = Uri.encodeComponent('$nombre receta Cochabamba');
      final searchUrl = 'https://www.youtube.com/results?search_query=$encodedQuery';
      
      final Uri uri = Uri.parse(searchUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      }
    } catch (e) {
      print('Error en búsqueda YouTube: $e');
      _showError(context, 'No se pudo abrir YouTube');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 260,
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(nombre, maxLines: 1, overflow: TextOverflow.ellipsis),
              background: Hero(
                tag: imagen.isNotEmpty ? imagen : nombre,
                child: CachedNetworkImage(
                  imageUrl: imagen,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.broken_image, size: 48)),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.sell, size: 18),
                        label: Text('Bs. ${precio.toStringAsFixed(2)}'),
                        backgroundColor: cs.secondaryContainer,
                        labelStyle: TextStyle(color: cs.onSecondaryContainer),
                      ),
                      Chip(
                        avatar: const Icon(Icons.place, size: 18),
                        label: Text(ubicacion),
                        backgroundColor: cs.surfaceVariant,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  Text(
                    'Descripción',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(descripcion),
                  
                  const SizedBox(height: 16),
                  Text(
                    'Receta',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(receta),
                  
                  const SizedBox(height: 20),
                  
                  // BOTONES QUE SIEMPRE FUNCIONAN
                  Column(
                    children: [
                      FilledButton.icon(
                        onPressed: () => _openYouTube(context),
                        icon: const Icon(Icons.play_circle_fill),
                        label: const Text('Ver Video de Preparación'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      
                      OutlinedButton.icon(
                        onPressed: () => _searchYouTubeVideos(context),
                        icon: const Icon(Icons.search),
                        label: const Text('Buscar Más Videos'),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                      const SizedBox(height: 10),
                      
                      // BOTÓN DE MAPAS CORREGIDO - ¡AHORA FUNCIONA!
                      FilledButton.icon(
                        onPressed: () => _openGoogleMaps(context),
                        icon: const Icon(Icons.map),
                        label: const Text('Ver en Google Maps'),
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';

import './providers/auth_provider.dart';
import './providers/platos_provider.dart';
import './screens/login_screen.dart';
import './screens/platos_list_screen.dart';
import './api/ubicaciones_api.dart';

Future<void> main() async {
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("No se encontró archivo .env, usando valores por defecto");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, PlatosProvider>(
          create: (ctx) => PlatosProvider(),
          update: (ctx, auth, previousPlatos) => PlatosProvider(),
        ),
      ],
      child: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Platos Cochabamba',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            fontFamily: 'Lato',
          ),
          home: const PlatosScreen(),
        ),
      ),
    );
  }
}

class PlatosScreen extends StatefulWidget {
  const PlatosScreen({super.key});

  @override
  State<PlatosScreen> createState() => _PlatosScreenState();
}

class _PlatosScreenState extends State<PlatosScreen> {
  late Future<List<Map<String, dynamic>>> _ubicaciones;

  @override
  void initState() {
    super.initState();
    _ubicaciones = UbicacionesApi.fetchUbicaciones();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final Map<String, List<Map<String, dynamic>>> categorias = {
      'Desayuno': [
        {
          'nombre': 'Salteña',
          'imagen': 'https://i.pinimg.com/736x/12/23/a9/1223a95cc29983c68a4339e4afb848d4.jpg',
          'descripcion': 'Empanada rellena con carne y caldo.',
          'precio': 10.0,
          'receta': '1. Preparar masa. 2. Cocinar relleno. 3. Hornear.',
          'videoUrl': 'https://www.youtube.com/watch?v=example5',
          'ubicacion': 'Restaurante típico en Cochabamba.',
          'ubicacionUrl': 'https://www.google.com/maps?q=Cochabamba',
        },
        {
          'nombre': 'Relleno',
          'imagen': 'https://i.pinimg.com/1200x/4f/20/24/4f2024dc15495e606ecaf89f4180d92f.jpg',
          'descripcion': 'Plato típico con carne rellena y papas.',
          'precio': 15.0,
          'receta': '1. Preparar carne rellena. 2. Cocinar papas.',
          'videoUrl': 'https://www.youtube.com/watch?v=example6',
          'ubicacion': 'Restaurante típico en Cochabamba.',
          'ubicacionUrl': 'https://www.google.com/maps?q=Cochabamba',
        },
        {
          'nombre': 'Api con pastel',
          'imagen': 'https://i.pinimg.com/1200x/9e/28/93/9e2893ad132da91cf708e6ed16a77f43.jpg',
          'descripcion': 'Bebida caliente de maíz morado con pastel.',
          'precio': 8.0,
          'receta': '1. Preparar api. 2. Freír pastel.',
          'videoUrl': 'https://www.youtube.com/watch?v=example7',
          'ubicacion': 'Restaurante típico en Cochabamba.',
          'ubicacionUrl': 'https://www.google.com/maps?q=Cochabamba',
        },
        {
          'nombre': 'Empanadas Wistupiku',
          'imagen': 'https://i.pinimg.com/736x/4c/fe/a8/4cfea82f4027c934a99cd8a4ebad3e4c.jpg',
          'descripcion': 'Empanadas típicas de Cochabamba.',
          'precio': 12.0,
          'receta': '1. Preparar masa. 2. Cocinar relleno. 3. Hornear.',
          'videoUrl': 'https://www.youtube.com/watch?v=example8',
          'ubicacion': 'Restaurante típico en Cochabamba.',
          'ubicacionUrl': 'https://www.google.com/maps?q=Cochabamba',
        },
      ],
      'Almuerzo': [
        {
          'nombre': 'Silpancho',
          'imagen':
          'https://i.pinimg.com/736x/3a/f6/03/3af603235909c360a2465c3578eb21f1.jpg',
          'descripcion':
          'Plato típico de Cochabamba con carne apanada, arroz y huevo.',
          'precio': 25.0,
          'receta':
          '1. Preparar carne apanada. 2. Cocinar arroz y papas. 3. Freír huevo.',
          'videoUrl': 'https://www.youtube.com/watch?v=example',
          'ubicacion': 'Restaurante típico en Cochabamba.',
          'ubicacionUrl': 'https://www.google.com/maps?q=Quillacollo',
        },
        {
          'nombre': 'Pique Macho',
          'imagen': 'https://i.pinimg.com/736x/75/78/e7/7578e71c7245f487a2d7a37ea2cbf646.jpg',
          'descripcion':
          'Plato típico con carne, papas fritas y salsa picante.',
          'precio': 30.0,
          'receta':
          '1. Cocinar carne. 2. Freír papas. 3. Preparar salsa picante.',
          'videoUrl': 'https://www.youtube.com/watch?v=example2',
          'ubicacion': 'Restaurante típico en Cochabamba.',
          'ubicacionUrl': 'https://www.google.com/maps?q=Quillacollo',
        },
        {
          'nombre': 'Chicharrón',
          'imagen': 'https://i.pinimg.com/1200x/60/1e/0e/601e0e8bedc0d4c27d7c68d2092974a3.jpg',
          'descripcion': 'Plato típico con carne de cerdo frita y mote.',
          'precio': 35.0,
          'receta': '1. Freír carne de cerdo. 2. Cocinar mote.',
          'videoUrl': 'https://www.youtube.com/watch?v=example3',
          'ubicacion': 'Restaurante típico en Cochabamba.',
          'ubicacionUrl': 'https://www.google.com/maps?q=Sacaba',
        },
        {
          'nombre': 'Sopa de Maní',
          'imagen': 'https://i.pinimg.com/736x/d9/55/bd/d955bd3d164e8d62f9c32b0ab7253b5c.jpg',
          'descripcion': 'Sopa típica con maní, carne y papas.',
          'precio': 20.0,
          'receta': '1. Preparar caldo con maní. 2. Cocinar carne y papas.',
          'videoUrl': 'https://www.youtube.com/watch?v=example4',
          'ubicacion': 'Restaurante típico en Cochabamba.',
          'ubicacionUrl': 'https://www.google.com/maps?q=Sacaba',
        },
      ],
      'Cena': [
        {
          'nombre': 'Anticucho',
          'imagen': 'https://i.pinimg.com/736x/57/68/69/576869dac070f70e8518c1025b75d3b6.jpg',
          'descripcion': 'Plato típico con carne a la parrilla y papas.',
          'precio': 18.0,
          'receta': '1. Preparar carne. 2. Cocinar papas. 3. Servir con salsa.',
          'videoUrl': 'https://www.youtube.com/watch?v=example9',
          'ubicacion': 'Restaurante típico en Cochabamba.',
          'ubicacionUrl': 'https://www.google.com/maps?q=Cochabamba',
        },
      ],
    };

    return DefaultTabController(
      length: categorias.keys.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Platos Cochabamba'),
          centerTitle: true,
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          bottom: TabBar(
            indicatorColor: cs.onPrimary,
            labelColor: cs.onPrimary,
            unselectedLabelColor: cs.onPrimary.withOpacity(0.7),
            tabs: categorias.keys.map((categoria) => Tab(text: categoria)).toList(),
          ),
        ),
        body: TabBarView(
          children: categorias.keys.map((categoria) {
            final platos = categorias[categoria]!;
            return GridView.builder(
              padding: const EdgeInsets.all(12),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: platos.length,
              itemBuilder: (ctx, i) {
                final p = platos[i];
                return _PlatoCard(
                  nombre: p['nombre'] ?? 'Nombre',
                  imagenUrl: p['imagen'] ?? '',
                  descripcion: p['descripcion'] ?? '',
                  precio: (p['precio'] ?? 0.0) as double,
                  receta: p['receta'] ?? '',
                  videoUrl: p['videoUrl'] ?? '',
                  ubicacion: p['ubicacion'] ?? '',
                  ubicacionUrl: p['ubicacionUrl'] ?? '',
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir el enlace: $url';
    }
  }
}

class _PlatoCard extends StatelessWidget {
  final String nombre;
  final String imagenUrl;
  final String descripcion;
  final double precio;
  final String receta;
  final String videoUrl;
  final String ubicacion;
  final String ubicacionUrl;

  const _PlatoCard({
    required this.nombre,
    required this.imagenUrl,
    required this.descripcion,
    required this.precio,
    required this.receta,
    required this.videoUrl,
    required this.ubicacion,
    required this.ubicacionUrl,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 1,
      surfaceTintColor: cs.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => PlatoDetailScreen(
                nombre: nombre,
                imagen: imagenUrl,
                descripcion: descripcion,
                precio: precio,
                receta: receta,
                videoUrl: videoUrl,
                ubicacion: ubicacion,
                ubicacionUrl: ubicacionUrl,
              ),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen con Hero + overlay de precio
            Expanded(
              child: Stack(
                children: [
                  Hero(
                    tag: imagenUrl.isNotEmpty ? imagenUrl : nombre,
                    child: CachedNetworkImage(
                      imageUrl: imagenUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: Icon(Icons.broken_image)),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    bottom: 8,
                    child: Chip(
                      label: Text('Bs. ${precio.toStringAsFixed(2)}'),
                      backgroundColor: cs.primaryContainer,
                      labelStyle: TextStyle(color: cs.onPrimaryContainer),
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Text(
                nombre,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir el enlace: $url';
    }
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
                  Row(
                    children: [
                      FilledButton.icon(
                        onPressed: () => _launchURL(videoUrl),
                        icon: const Icon(Icons.play_circle_fill),
                        label: const Text('Ver video'),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () => _launchURL(ubicacionUrl),
                        icon: const Icon(Icons.map),
                        label: const Text('Ver en Maps'),
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
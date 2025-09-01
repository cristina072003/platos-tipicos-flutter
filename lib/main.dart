import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cached_network_image/cached_network_image.dart';
import './providers/platos_provider.dart';
import './screens/platos_list_screen.dart';
import './screens/splash_screen.dart';

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
      providers: [ChangeNotifierProvider(create: (ctx) => PlatosProvider())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Platos Cochabamba',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          fontFamily: 'Lato',
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueGrey,
            brightness: Brightness.dark,
          ),
          fontFamily: 'Lato',
        ),
        themeMode: ThemeMode.system,
        initialRoute: '/',
        routes: {
          '/': (ctx) => const SplashScreen(),
          '/platos-list': (ctx) => const PlatosScreen(),
        },
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final Map<String, List<Map<String, dynamic>>> categorias = {
      'Desayuno': [
        {
          'nombre': 'Salteña',
          'imagen':
              'https://i.pinimg.com/736x/12/23/a9/1223a95cc29983c68a4339e4afb848d4.jpg',
          'descripcion': 'Empanada rellena con carne y caldo.',
          'precio': 10.0,
          'receta': '1. Preparar masa. 2. Cocinar relleno. 3. Hornear.',
          'videoUrl':
              'https://youtube.com/watch?v=VydD2si0MwI&si=wBEIzLS2y_nO0xbD',
          'ubicacion': 'SALTEÑERÍA VICTORIA',
          'ubicacionUrl': 'https://maps.app.goo.gl/DHSMjZV7U8ecUVG69',
        },
        {
          'nombre': 'Relleno',
          'imagen':
              'https://www.hotrodsrecipes.com/wp-content/uploads/2022/10/cuban-papas-rellenas.jpg',
          'descripcion': 'Plato típico con carne rellena y papas.',
          'precio': 15.0,
          'receta': '1. Preparar carne rellena. 2. Cocinar papas.',
          'videoUrl': 'https://www.youtube.com/watch?v=example6',
          'ubicacion': 'RELLENOS CALAMA',
          'ubicacionUrl': 'https://maps.app.goo.gl/QLPXWdDAea6ToiUJ8',
        },
        {
          'nombre': 'Api con pastel',
          'imagen':
              'https://blog.amigofoods.com/wp-content/uploads/2023/01/popular-api-con-pastel.jpg',
          'descripcion': 'Bebida caliente de maíz morado con pastel.',
          'precio': 8.0,
          'receta': '1. Preparar api. 2. Freír pastel.',
          'videoUrl': 'https://www.youtube.com/watch?v=example7',
          'ubicacion': 'APIS XPRESS',
          'ubicacionUrl': 'https://maps.app.goo.gl/KS7hpd5jWtzTKbaP7',
        },
        {
          'nombre': 'Empanadas Wistupiku',
          'imagen':
              'https://tse1.mm.bing.net/th/id/OIP.rq3C20dP_gx4Cvf-quowLQHaIv?rs=1&pid=ImgDetMain&o=7&rm=3',
          'descripcion': 'Empanadas típicas de Cochabamba.',
          'precio': 12.0,
          'receta': '1. Preparar masa. 2. Cocinar relleno. 3. Hornear.',
          'videoUrl': 'https://www.youtube.com/watch?v=example8',
          'ubicacion': 'WISTUPIKU',
          'ubicacionUrl': 'https://maps.app.goo.gl/1W98R5F7cravXzzp6',
        },
        {
          'nombre': 'Caldo de Kawi',
          'imagen':
              'https://recetasbolivia.com/wp-content/uploads/caldo-de-kawi-Boliviano.jpg',
          'descripcion': 'Caldo tradicional de cerdo con chuño y hierbas.',
          'precio': 18.0,
          'receta': '1. Cocinar cerdo. 2. Preparar chuño. 3. Añadir hierbas.',
          'videoUrl': 'https://www.youtube.com/watch?v=example9',
          'ubicacion': 'SAN JORGE CALDOS DE LA MAÑANA',
          'ubicacionUrl': 'https://maps.app.goo.gl/WwGMq2kKhHfbg7R68',
        },
        {
          'nombre': 'Humintas',
          'imagen':
              'https://lh4.googleusercontent.com/-rdPWgg3V510/TYwcFxkMN-I/AAAAAAAAAB8/YbHxLKL-KJY/s1600/humintas.jpg',
          'descripcion': 'Tamales dulces de maíz envueltos en hojas de maíz.',
          'precio': 5.0,
          'receta': '1. Moler maíz. 2. Preparar masa. 3. Cocinar al vapor.',
          'videoUrl': 'https://www.youtube.com/watch?v=example10',
          'ubicacion': 'HUMINTAS "QUE CHALITA"',
          'ubicacionUrl': 'https://maps.app.goo.gl/FGN9AGXmXwmLSEec9',
        },
        {
          'nombre': 'Marraqueta con cafe',
          'imagen':
              'https://i.pinimg.com/736x/94/ca/79/94ca79402d0acc37af15c564f70fb476.jpg',
          'descripcion': 'Pan crujiente acompañado de cafe caliente',
          'precio': 7.0,
          'receta': '1. Preparar pan. 2. Servir con cafe.',
          'videoUrl': 'https://www.youtube.com/watch?v=example11',
          'ubicacion': 'MARRAQUETA ECO SANDWICH',
          'ubicacionUrl': 'https://maps.app.goo.gl/kWP3VB3EPn331ryK9',
        },
      ],
      'Almuerzo': [
        {
          'nombre': 'Silpancho',
          'imagen':
              'https://okdiario.com/img/2020/05/05/receta-de-silpancho-boliviano.jpg',
          'descripcion':
              'Plato típico de Cochabamba con carne apanada, arroz y huevo.',
          'precio': 25.0,
          'receta':
              '1. Preparar carne apanada. 2. Cocinar arroz y papas. 3. Freír huevo.',
          'videoUrl': 'https://www.youtube.com/watch?v=example',
          'ubicacion': 'Restaurante típico en Cochabamba',
          'ubicacionUrl': 'https://maps.google.com/?q=Quillacollo+Bolivia',
        },
        {
          'nombre': 'Pique Macho',
          'imagen':
              'https://i.pinimg.com/736x/75/78/e7/7578e71c7245f487a2d7a37ea2cbf646.jpg',
          'descripcion':
              'Plato típico con carne, papas fritas y salsa picante.',
          'precio': 30.0,
          'receta':
              '1. Cocinar carne. 2. Freír papas. 3. Preparar salsa picante.',
          'videoUrl': 'https://www.youtube.com/watch?v=example2',
          'ubicacion': 'Restaurante típico en Cochabamba',
          'ubicacionUrl': 'https://maps.google.com/?q=Quillacollo+Bolivia',
        },
        {
          'nombre': 'Chicharrón',
          'imagen':
              'https://i.pinimg.com/1200x/60/1e/0e/601e0e8bedc0d4c27d7c68d2092974a3.jpg',
          'descripcion': 'Plato típico con carne de cerdo frita y mote.',
          'precio': 35.0,
          'receta': '1. Freír carne de cerdo. 2. Cocinar mote.',
          'videoUrl': 'https://www.youtube.com/watch?v=example3',
          'ubicacion': 'Restaurante típico en Cochabamba',
          'ubicacionUrl': 'https://maps.google.com/?q=Sacaba+Bolivia',
        },
        {
          'nombre': 'Sopa de Maní',
          'imagen':
              'https://i.pinimg.com/736x/d9/55/bd/d955bd3d164e8d62f9c32b0ab7253b5c.jpg',
          'descripcion': 'Sopa típica con maní, carne y papas.',
          'precio': 20.0,
          'receta': '1. Preparar caldo con maní. 2. Cocinar carne y papas.',
          'videoUrl': 'https://www.youtube.com/watch?v=example4',
          'ubicacion': 'Restaurante típico en Cochabamba',
          'ubicacionUrl': 'https://maps.google.com/?q=Sacaba+Bolivia',
        },
        {
          'nombre': 'Lapping',
          'imagen':
              'https://tse3.mm.bing.net/th/id/OIP.PmIarPznNQy7KQmpj_6twgHaE8?rs=1&pid=ImgDetMain&o=7&rm=3',
          'descripcion':
              'Carne de res asada al sartén, acompañada de mote, habas, papa y ensalada de tomate y cebolla.',
          'precio': 28.0,
          'receta':
              '1. Asar el pecho de vaca. 2. Cocinar el mote, habas y papas. 3. Preparar una ensalada de cebolla y tomate.',
          'videoUrl': 'https://www.youtube.com/watch?v=aAtnnqGMzDU',
          'ubicacion': 'Restaurante típico en Cochabamba',
          'ubicacionUrl': 'https://maps.google.com/?q=Cochabamba+Bolivia',
        },
        {
          'nombre': 'Chancho a la Cruz',
          'imagen':
              'https://i.pinimg.com/736x/8d/e2/60/8de260944a5d9ffe10088845d0404c51.jpg',
          'descripcion':
              'Cerdo entero cocinado lentamente en una cruz de metal sobre fuego de leña, resultando en una carne tierna y jugosa con un cuero muy crocante.',
          'precio': 35.0,
          'receta':
              '1. Marinar el cerdo con sal, limón y especias. 2. Atar el cerdo a una cruz de metal. 3. Cocinar a fuego lento por varias horas, girándolo y rociándolo con cerveza para mantenerlo húmedo.',
          'videoUrl': 'https://www.youtube.com/watch?v=EoapLgv8Ho4',
          'ubicacion': 'Restaurantes especializados en Cochabamba',
          'ubicacionUrl': 'https://maps.google.com/?q=Cochabamba+Bolivia',
        },
      ],
      'Cena': [
        {
          'nombre': 'Anticucho',
          'imagen':
              'https://i.pinimg.com/736x/57/68/69/576869dac070f70e8518c1025b75d3b6.jpg',
          'descripcion': 'Plato típico con carne a la parrilla y papas.',
          'precio': 18.0,
          'receta': '1. Preparar carne. 2. Cocinar papas. 3. Servir con salsa.',
          'videoUrl': 'https://www.youtube.com/watch?v=example9',
          'ubicacion': 'Restaurante típico en Cochabamba',
          'ubicacionUrl': 'https://maps.google.com/?q=Cochabamba+Bolivia',
        },
        {
          'nombre': 'Tripitas',
          'imagen':
              'https://azafranbolivia.com/wp-content/uploads/2023/01/tripitas-bolivia-origen-beneficios-preparacion.jpg',
          'descripcion':
              'Plato popular de comida callejera que consiste en intestinos de res trenzados y fritos hasta quedar crujientes. Se sirve con papas y llajwa.',
          'precio': 15.0,
          'receta':
              '1. Limpiar y hervir las tripas. 2. Trenzar y freír las tripas. 3. Servir con papas y salsa picante (llajwa).',
          'videoUrl': 'https://www.youtube.com/watch?v=1_q4gE73f8Y',
          'ubicacion': 'Puestos de comida nocturna en Cochabamba',
          'ubicacionUrl': 'https://maps.google.com/?q=Cochabamba+Bolivia',
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
            tabs: categorias.keys
                .map((categoria) => Tab(text: categoria))
                .toList(),
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
                        child: const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
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
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
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
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'No se pudo abrir el enlace: $url';
      }
    } catch (e) {
      print('Error al abrir URL: $e');
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
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 48),
                    ),
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

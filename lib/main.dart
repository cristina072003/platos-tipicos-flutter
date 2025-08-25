import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:url_launcher/url_launcher.dart';

import './providers/auth_provider.dart';
import './providers/platos_provider.dart';
import './screens/login_screen.dart';
import './screens/platos_list_screen.dart';
import './screens/plato_detail_screen.dart';
import './api/ubicaciones_api.dart';

Future<void> main() async {
  // Carga variables de entorno desde un archivo o usa valores por defecto
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    // Si no existe el archivo .env, usar valores por defecto
    print("No se encontró archivo .env, usando valores por defecto");
  }
  runApp(MyApp());
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
          title: 'Platos Cochabamba',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            // accentColor ha sido reemplazado por colorScheme en versiones recientes
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.blue,
              accentColor: Colors.amber, // Esto reemplaza a accentColor
            ),
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
  _PlatosScreenState createState() => _PlatosScreenState();
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
    final Map<String, List<Map<String, dynamic>>> categorias = {
      'Desayuno': [
        {
          'nombre': 'Salteña',
          'imagen': 'assets/salteña.jpg',
          'descripcion': 'Empanada rellena con carne y caldo.',
          'precio': 10.0,
          'receta': '1. Preparar masa. 2. Cocinar relleno. 3. Hornear.',
          'videoUrl': 'https://www.youtube.com/watch?v=example5',
          'ubicacion': 'Restaurante típico en Cochabamba.',
          'ubicacionUrl': 'https://www.google.com/maps?q=Cochabamba',
        },
        {
          'nombre': 'Relleno',
          'imagen': 'assets/relleno.jpg',
          'descripcion': 'Plato típico con carne rellena y papas.',
          'precio': 15.0,
          'receta': '1. Preparar carne rellena. 2. Cocinar papas.',
          'videoUrl': 'https://www.youtube.com/watch?v=example6',
          'ubicacion': 'Restaurante típico en Cochabamba.',
          'ubicacionUrl': 'https://www.google.com/maps?q=Cochabamba',
        },
        {
          'nombre': 'Api con pastel',
          'imagen': 'assets/api_pastel.jpg',
          'descripcion': 'Bebida caliente de maíz morado con pastel.',
          'precio': 8.0,
          'receta': '1. Preparar api. 2. Freír pastel.',
          'videoUrl': 'https://www.youtube.com/watch?v=example7',
          'ubicacion': 'Restaurante típico en Cochabamba.',
          'ubicacionUrl': 'https://www.google.com/maps?q=Cochabamba',
        },
        {
          'nombre': 'Empanadas Wistupiku',
          'imagen': 'assets/wistupiku.jpg',
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
          'imagen': 'assets/pique macho.jpg',
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
          'imagen': 'assets/chicharron.jpg',
          'descripcion': 'Plato típico con carne de cerdo frita y mote.',
          'precio': 35.0,
          'receta': '1. Freír carne de cerdo. 2. Cocinar mote.',
          'videoUrl': 'https://www.youtube.com/watch?v=example3',
          'ubicacion': 'Restaurante típico en Cochabamba.',
          'ubicacionUrl': 'https://www.google.com/maps?q=Sacaba',
        },
        {
          'nombre': 'Sopa de Maní',
          'imagen': 'assets/sopa mani.jpg',
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
          'imagen': 'assets/anticucho.jpg',
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
          backgroundColor: Colors.blue,
          bottom: TabBar(
            tabs: categorias.keys
                .map((categoria) => Tab(text: categoria))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: categorias.keys.map((categoria) {
            final platos = categorias[categoria]!;
            return GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: platos.length,
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => PlatoDetailScreen(
                        nombre: platos[i]['nombre'] ?? 'Nombre no disponible',
                        imagen: platos[i]['imagen'] ?? 'assets/default.jpg',
                        descripcion:
                            platos[i]['descripcion'] ??
                            'Descripción no disponible',
                        precio: platos[i]['precio'] ?? 0.0,
                        receta: platos[i]['receta'] ?? 'Receta no disponible',
                        videoUrl:
                            platos[i]['videoUrl'] ?? 'https://www.youtube.com',
                        ubicacion:
                            platos[i]['ubicacion'] ?? 'Ubicación no disponible',
                        ubicacionUrl:
                            platos[i]['ubicacionUrl'] ??
                            'https://www.google.com/maps',
                      ),
                    ),
                  );
                },
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            platos[i]['imagen'] ?? 'assets/default.jpg',
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        platos[i]['nombre'] ?? 'Nombre no disponible',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
    return Scaffold(
      appBar: AppBar(title: Text(nombre), backgroundColor: Colors.blue),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                imagen,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Descripción:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(descripcion),
            const SizedBox(height: 10),
            Text(
              'Precio: Bs. $precio',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Receta:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(receta),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => _launchURL(videoUrl),
              child: const Text('Ver video de preparación'),
            ),
            const SizedBox(height: 10),
            Text(
              'Ubicación:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(ubicacion),
            ElevatedButton(
              onPressed: () => _launchURL(ubicacionUrl),
              child: const Text('Ver en Google Maps'),
            ),
          ],
        ),
      ),
    );
  }
}

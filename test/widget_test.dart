import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Platos Cochabamba',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PlatosScreen(),
    );
  }
}

class PlatosScreen extends StatelessWidget {
  const PlatosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Platos Cochabamba')),
      body: ListView(
        children: const [
          ListTile(
            title: Text('Pique Macho'),
            subtitle: Text('Carne, papas fritas, huevo, y más.'),
          ),
          ListTile(
            title: Text('Silpancho'),
            subtitle: Text('Carne apanada, arroz, y ensalada.'),
          ),
          ListTile(
            title: Text('Sopa de Maní'),
            subtitle: Text('Sopa cremosa con maní y carne.'),
          ),
        ],
      ),
    );
  }
}

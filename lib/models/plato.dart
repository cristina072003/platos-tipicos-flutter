class Plato {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String categoria;
  final String imagenUrl;
  final List<String> lugares;
  final double rating; // Nuevo campo agregado
  final List<String> imagenes; // Nuevo campo agregado

  Plato({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.categoria,
    required this.imagenUrl,
    required this.lugares,
    this.rating = 0.0, // Valor por defecto
    this.imagenes = const [], // Valor por defecto
  });

  factory Plato.fromJson(Map<String, dynamic> json) {
    return Plato(
      id: json['_id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      precio: json['precio'].toDouble(),
      categoria: json['categoria'],
      imagenUrl: json['imagenUrl'],
      lugares: List<String>.from(json['lugares']),
      rating: json['rating']?.toDouble() ?? 0.0, // Manejo del nuevo campo
      imagenes: List<String>.from(
        json['imagenes'] ?? [],
      ), // Manejo del nuevo campo
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio,
      'categoria': categoria,
      'imagenUrl': imagenUrl,
      'lugares': lugares,
      'rating': rating, // Inclusión del nuevo campo
      'imagenes': imagenes, // Inclusión del nuevo campo
    };
  }
}

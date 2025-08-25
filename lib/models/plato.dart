class Plato {
  final String id;
  final String nombre;
  final String descripcion;
  final double precio;
  final String categoria;
  final String imagenUrl;
  final List<String> lugares;

  Plato({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precio,
    required this.categoria,
    required this.imagenUrl,
    required this.lugares,
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
    };
  }
}
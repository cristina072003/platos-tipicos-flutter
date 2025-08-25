class Usuario {
  final String id;
  final String nombre;
  final String email;
  final String token;

  Usuario({
    required this.id,
    required this.nombre,
    required this.email,
    required this.token,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['_id'],
      nombre: json['nombre'],
      email: json['email'],
      token: json['token'],
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  // atributos
  final String uid;
  final String nombre;
  final String email;
  final String username;
  final int numLogros;

  Usuario({
    //constructor
    required this.uid,
    required this.nombre,
    required this.email,
    required this.username,
    required this.numLogros,
  });

  Map<String, dynamic> toMap() {
    // convertilo a mapa para poder guardarlo en Firestore
    return {
      'nombre': nombre,
      'email': email,
      'username': username,
      'numLogros': numLogros,
    };
  }
  // El constructor de fábrica fromMap lo usas cuando necesitas leer datos desde Firestore y convertirlos en un objeto Usuario en Flutter.
  factory Usuario.fromMap(String uid, Map<String, dynamic> data) {
    return Usuario(
      uid: uid,
      nombre: data['nombre'] ?? '',
      email: data['mail'] ?? '',
      username: data['username'] ?? '',
      numLogros: data['numLogros'] ?? 0,
    );
  }
}

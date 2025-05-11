import 'package:cloud_firestore/cloud_firestore.dart';

class Logro {
  final String id; // id del documento en Firestore
  final String descripcion;
  final int nivel;
  final String refUsuario;

  Logro({
    required this.id,
    required this.descripcion,
    required this.nivel,
    required this.refUsuario,
  });

  Map<String, dynamic> toMap() {
    return {
      'descripcion': descripcion,
      'nivel': nivel,
      'refUsuario': refUsuario,
    };
  }

  factory Logro.fromMap(String id, Map<String, dynamic> data) {
    return Logro(
      id: id,
      descripcion: data['descripcion'] ?? '',
      nivel: data['nivel'] ?? 0,
      refUsuario: data['refUsuario'] ?? '',
    );
  }
}

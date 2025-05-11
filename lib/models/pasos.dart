import 'package:cloud_firestore/cloud_firestore.dart';

class Pasos {
  final String id; // ID del documento en Firestore
  final DateTime fecha;
  final String idUsuario;
  final int numPasos;
  final String refUsuario;

  Pasos({
    required this.id,
    required this.fecha,
    required this.idUsuario,
    required this.numPasos,
    required this.refUsuario,
  });

  Map<String, dynamic> toMap() {
    return {
      'fecha': fecha,
      'idUsuario': idUsuario,
      'numPasos': numPasos,
      'refUsuario': refUsuario,
    };
  }

  factory Pasos.fromMap(String id, Map<String, dynamic> data) {
    return Pasos(
      id: id,
      fecha: (data['fecha'] as Timestamp).toDate(),
      idUsuario: data['idUsuario'] ?? '',
      numPasos: data['numPasos'] ?? 0,
      refUsuario: data['refUsuario'] ?? '',
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> registrarUsuario({
    required String nombre,
    required String mail,
    required String username,
    required String password,
  }) async {
    try {
      // 1. Crear usuario en Firebase Auth
      UserCredential cred = await _auth.createUserWithEmailAndPassword(
        email: mail,
        password: password,
      );

      final String uid = cred.user!.uid;

      // 2. Crear objeto Usuario
      final usuario = Usuario(
        uid: uid,
        nombre: nombre,
        email: mail,
        username: username,
        numLogros: 0,
      );

      // 3. Guardar en Firestore
      final doc = _db.collection('Usuarios').doc(uid);
      await doc.set(usuario.toMap());

    } catch (e) {
      throw Exception('Error al registrar usuario: $e');
    }
  }
}

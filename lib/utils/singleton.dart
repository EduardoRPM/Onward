// step_data.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StepData {
  static final StepData _instance = StepData._internal();

  int steps = 0;
  String userId = '';

  factory StepData() {
    return _instance;
  }

  StepData._internal();
}

// 👈 Para actualizar StepData también

class UserDataService {
  static final UserDataService _instance = UserDataService._internal();
  factory UserDataService() => _instance;

  UserDataService._internal();

  String? nombre;
  String? username;
  String? email;

  Future<void> cargarDatosUsuario({bool forceReload = false}) async {
    final prefs = await SharedPreferences.getInstance();
    final uid = FirebaseAuth.instance.currentUser?.uid;

    if (uid == null) {
      throw Exception('Usuario no autenticado');
    }

    if (!forceReload) {
      // Buscar en SharedPreferences primero
      final localNombre = prefs.getString('nombre');
      final localUsername = prefs.getString('username');
      final localEmail = prefs.getString('email');
      final localUserId = prefs.getString('userId');

      if (localNombre != null && localUsername != null && localEmail != null && localUserId != null) {
        nombre = localNombre;
        username = localUsername;
        email = localEmail;
        StepData().userId = localUserId;
        print('Datos cargados localmente');
        return;
      }
    }

    // Cargar de Firestore
    final doc = await FirebaseFirestore.instance.collection('Usuarios').doc(uid).get();
    final data = doc.data();
    if (data != null) {
      nombre = data['nombre'];
      username = data['username'];
      email = data['email'];
      StepData().userId = uid;

      // Guardar/actualizar en SharedPreferences
      await prefs.setString('nombre', nombre!);
      await prefs.setString('username', username!);
      await prefs.setString('email', email!);
      await prefs.setString('userId', uid);

      print('Datos cargados/actualizados de Firestore y guardados localmente');
    } else {
      throw Exception('No se encontraron datos para el UID: $uid');
    }
  }

  Future<void> limpiarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

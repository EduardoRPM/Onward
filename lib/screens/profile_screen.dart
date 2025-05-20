import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../constantes.dart';
import '../utils/singleton.dart';
import '../welcome.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? nombre;
  String? username;
  String? email;
  bool cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    try {
      await UserDataService().cargarDatosUsuario();
      setState(() {
        nombre = UserDataService().nombre;
        username = UserDataService().username;
        email = UserDataService().email;
        cargando = false;
      });
    } catch (e) {
      print('Error al cargar datos del usuario: $e');
      setState(() {
        cargando = false;
      });
    }
  }

  final stepData = StepData();
  final int achievements = 4;

  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 600,
        maxHeight: 600,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        setState(() {
          _profileImage = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint('Error al seleccionar imagen: $e');
    }
  }

  void _handleLogout() {
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: const Text('Cerrar Sesión'),
        content: const Text('¿Estás seguro que deseas cerrar sesión?'),
        actions: [
          CupertinoDialogAction(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Cerrar Sesión'),
            onPressed: () async {
              Navigator.pop(context); // Cierra el diálogo de confirmación
              try {
                await FirebaseAuth.instance.signOut();
                // Después de cerrar sesión, navegar a la pantalla de bienvenida
                await FirebaseAuth.instance.signOut();
                await UserDataService().limpiarDatos();
                //Navigator.pushReplacementNamed(context, '/welcome');
                // O, si estás usando rutas MaterialPageRoute:
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Welcome()));
              } catch (e) {
                print('Error al cerrar sesión: $e');
                // Puedes mostrar un mensaje de error aquí si es necesario
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (cargando) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: IconButton(
                      icon: const Icon(CupertinoIcons.arrow_left_circle_fill,
                          color: Colors.black,
                          size: 52),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Profile Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 32),

                      // Profile Image
                      Stack(
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Color1, width: 4),
                              color: Color2,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(60),
                              child: _profileImage != null
                                  ? Image.file(
                                _profileImage!,
                                fit: BoxFit.cover,
                              )
                                  : const Icon(
                                CupertinoIcons.person_alt,
                                size: 60,
                                color: Color1,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: _pickImage,
                              child: Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  CupertinoIcons.camera_fill,
                                  size: 18,
                                  color: Color3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Name and Username
                      Text(
                        nombre ?? 'Nombre desconocido',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color1,
                        ),
                      ),
                      Text(
                        username ?? 'Usuario desconocido',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue.shade900,
                        ),
                      ),
                      if (email != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            email!,
                            style: const TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                        ),

                      const SizedBox(height: 24),

                      Container(
                        height: 1,
                        width: double.infinity,
                        color: Colors.blue.shade700.withOpacity(0.3),
                      ),

                    ],
                  ),
                ),
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 12),
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                onPressed: _handleLogout,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      CupertinoIcons.square_arrow_right,
                      color: Color3,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Cerrar Sesión',
                      style: TextStyle(
                        color: Color3,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
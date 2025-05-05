import 'package:flutter/material.dart';
import 'constantes.dart';
import 'inicioSesion.dart';
import 'screens/medallas.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/welcome.webp',
              fit: BoxFit.cover,
            ),
          ),
          // Botón Iniciar Sesión
          Positioned(
            top: 95,
            left: 38,
            child: SizedBox(
              width: 186,
              height: 31,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Color1,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Iniciosesion()),
                  );
                },
                child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          // Botón Registrarse
          Positioned(
            top: 135,
            left: 38,
            child: SizedBox(
              width: 186,
              height: 31,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  side: const BorderSide(
                    color: Color1,
                    width: 2,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Iniciosesion()),
                  );
                },
                child: const Text(
                  'Registrarse',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color1,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

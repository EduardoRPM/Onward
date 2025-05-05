import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../widgets/achievement_list.dart';

class AchievementsScreen extends StatefulWidget {
  const AchievementsScreen({super.key});

  @override
  _AchievementsScreenState createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends State<AchievementsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/app_Fitt.png',
              fit: BoxFit.cover,
            ),
          ),

          // Animación Lottie
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width, // 80% del ancho de pantalla
              child: Lottie.asset(
                'assets/nube_sin_marca.json',
                fit: BoxFit.contain,
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..repeat();
                },
              ),
            ),
          ),
          Positioned.fill(
            child: Image.asset(
              'assets/app_Fitt_character.png',
              fit: BoxFit.cover,
            ),
          ),
          // Card que empieza en la mitad, pero más angosta
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              widthFactor: 0.9, // 90% del ancho
              child: Transform.translate(
                offset: const Offset(0, 30),
                child: Card(
                  color: Colors.white,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.67, // 65% de la altura
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: AchievementList(),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 40, // Distancia desde arriba (ajusta según tu diseño)
            left: 16, // Distancia desde la izquierda
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
              onPressed: () {
                Navigator.pop(context); // Regresa a la pantalla anterior
              },
            ),
          ),

        ],
      ),
    );
  }
}

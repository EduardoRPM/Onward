import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Medallas extends StatefulWidget {
  const Medallas({super.key});

  @override
  State<Medallas> createState() => _MedallasState();
}

class _MedallasState extends State<Medallas> with TickerProviderStateMixin{
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

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
              fit: BoxFit.cover, // Ajusta la imagen al tamaño del contenedor
            ),
          ),
          Center(
            child: SizedBox(
              width: 1000, // Ajusta estos valores según lo que necesites
              height: 1000,

            )
          ),
          Center(
            child: SizedBox(
              width: 1000, // Ajusta estos valores según lo que necesites
              height: 1000,
              child: Lottie.asset(
                'assets/nube_sin_marca.json',
                fit: BoxFit.contain, // Mantiene la proporción
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..repeat();
                },
              ),
            ),
          ),



        ],
      )
    );
  }
}

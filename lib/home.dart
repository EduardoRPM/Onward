import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:onward/screens/achievements_screen.dart';
import 'package:onward/screens/profile_screen.dart';
import 'package:onward/utils/singleton.dart';
import 'package:onward/widgets/mini_player.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';

import 'constantes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';

  late final AnimationController _controller;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _controller = AnimationController(vsync: this);

    _steps = StepData().steps.toString();
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
      StepData().steps = event.steps;  // Guarda los pasos en el singleton
      _steps = event.steps.toString();
    });
  }


  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    print('onPedestrianStatusError: $error');
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }
  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  Future<void> initPlatformState() async {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream.listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Detectar la orientación actual
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
        // appBar: PreferredSize(
        //   // Reducir altura del AppBar en modo horizontal
        //   preferredSize: Size.fromHeight(isLandscape ? 60.0 : 60.0),
        //   child: AppBar(
        //     leading: IconButton(
        //       onPressed: () {
        //         Navigator.push(
        //           context,
        //           MaterialPageRoute(
        //             builder: (context) => const ProfileScreen(),
        //           ),
        //         );
        //       },
        //       icon: const Icon(Icons.person),
        //       iconSize: 48.0, // Aquí defines el tamaño en píxeles
        //     ),
        //     actions: [
        //       IconButton(
        //         onPressed: () {
        //           Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //               builder: (context) => const AchievementsScreen(),
        //             ),
        //           );
        //         },
        //         icon: Image.asset(
        //           'assets/achievement.png', // Asegúrate que el path sea correcto
        //           width: 52, // Puedes ajustar el tamaño
        //           height: 52,
        //         ),
        //       ),
        //
        //     ],
        //     //backgroundColor: Color3,
        //   ),
        // ),
        body: SafeArea(
          child: SingleChildScrollView(

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
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfileScreen(),
                                ),
                              );
                            },
                            icon: const Icon(Icons.person),
                            iconSize: 52.0, // Aquí defines el tamaño en píxeles
                          ),
                        ),
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 2),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const AchievementsScreen(),
                                ),
                              );
                            },
                            icon: Image.asset(
                              'assets/achievement.png', // Asegúrate que el path sea correcto
                              width: 52, // Puedes ajustar el tamaño
                              height: 52,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Center(
                    child: isLandscape
                    // Diseño para orientación horizontal
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Animación a la izquierda
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: Lottie.asset(
                            'assets/FootWalk.json',
                            fit: BoxFit.contain,
                            controller: _controller,
                            onLoaded: (composition) {
                              _controller
                                ..duration = composition.duration
                                ..repeat();
                            },
                          ),
                        ),
                        // Contador de pasos a la derecha
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _steps,
                              style: TextStyle(
                                fontSize: _steps.length < 6 ? 60 : 25,
                                fontWeight: FontWeight.bold,
                                color: Color2,
                              ),
                            ),
                            Text('Pasos'),
                          ],
                        ),
                      ],
                    )
                    // Diseño para orientación vertical (original)
                        : Column(
                      children: [
                        // Imagen de fondo
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Lottie.asset(
                              'assets/FootWalk.json',
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
                        Text(
                          _steps,
                          style: TextStyle(
                            fontSize: _steps.length < 6 ? 60 : 25,
                            fontWeight: FontWeight.bold,
                            color: Color2,
                          ),
                        ),
                        Text('Pasos'),
                      ],
                    ),
                  ),
                ],
              )

          ),
        )


    );
  }
}
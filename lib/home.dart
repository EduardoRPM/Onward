
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:onward/screens/achievements_screen.dart';
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
    initPlatformState();
  }

  void onStepCount(StepCount event) {
    print(event);
    setState(() {
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
    // if (Platform.isAndroid) {
    //   bool granted = await _checkActivityRecognitionPermission();
    //   if (!granted) {
    //     // Mostrar mensaje al usuario
    //   }
    // } Lo estoy probando con iphone

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
    return Scaffold(
      appBar: AppBar(

        leading: const Icon(Icons.person),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AchievementsScreen(),
                ),
              );
            },
            icon: const Icon(Icons.gamepad),
          ),


        ],

        backgroundColor: Color2,

      ),
      body: Center(
        child: Column(
          children: [
            // Imagen de fondo
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width, // 80% del ancho de pantalla
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
                  fontSize: _steps.length < 10 ? 60 : 25,
                  fontWeight: FontWeight.bold,
                  color: Color2,
                ),
            ),
            Text('Pasos'),
            // Positioned(
            //   left: 0,
            //   right: 0,
            //   bottom: 0,
            //   child: MiniPlayer(audioPlayer: _audioPlayer),
            // ),

          ],
        ),
      ),

    );
  }
}

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';
import 'package:onward/screens/achievements_screen.dart';
import 'package:onward/screens/profile_screen.dart';
import 'package:onward/services/StepService.dart';
import 'package:onward/utils/singleton.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';
import 'package:intl/intl.dart';

import 'constantes.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late final Stream<StepCount> _stepCountStream;
  late final Stream<PedestrianStatus> _pedestrianStatusStream;
  late final AnimationController _controller;
  late final AudioPlayer _audioPlayer;
  int _currentSteps = 0; // Pasos detectados por el sensor en tiempo real
  int _dailyStepCountFromFirebase = 0; // Pasos cargados de Firebase para hoy
  int _lastSavedSteps = 0;
  String get _stepsDisplay => (_dailyStepCountFromFirebase + _currentSteps).toString();
  String _steps = '0'; // Inicializar en '0'
  List<Map<String, dynamic>> _dailyStepsHistory = []; // Para el historial diario

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    _initPlatformState();
    _loadInitialDailySteps(); // Cargar los pasos iniciales de Firebase
    _loadDailyStepsHistory(); // Cargar el historial diario (solo el día actual por ahora)
  }

  Future<void> _loadInitialDailySteps() async {
    final userId = StepData().userId;
    print('Home screen loaded with userId: $userId'); // <--- Agregar esta línea
    if (userId.isEmpty) return;

    final steps = await StepService().getDailySteps(userId);
    setState(() {
      _dailyStepCountFromFirebase = steps;

      _steps = _stepsDisplay;
    });
  }

  Future<void> _loadDailyStepsHistory() async {
    final userId = StepData().userId;
    if (userId.isEmpty) return;

    final steps = await StepService().getDailySteps(userId);
    setState(() {
      _dailyStepsHistory = [
        {'date': DateFormat('yyyy-MM-dd').format(DateTime.now()), 'steps': steps}
      ];
    });
  }

  Future<void> _initPlatformState() async {
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    // _pedestrianStatusStream.listen(_onPedestrianStatusChanged, onError: _onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(_onStepCount, onError: _onStepCountError);
  }

  void _onStepCount(StepCount event) {
    if (!mounted) return;
    setState(() {
      _currentSteps = event.steps;
      _steps = _stepsDisplay;
    });

    final userId = StepData().userId;
    if (userId.isNotEmpty) {
      if ((event.steps - _lastSavedSteps) >= 10) {
        StepService().saveSteps(userId, event.steps);
        _lastSavedSteps = event.steps;
        // Recargar los pasos diarios de Firebase para la UI
        _loadInitialDailySteps();
        // También podrías optar por actualizar _dailyStepCountFromFirebase directamente
      }
    }
  }

  // void _onPedestrianStatusChanged(PedestrianStatus event) {
  //   setState(() {
  //     _status = event.status;
  //   });
  // }
  //
  // void _onPedestrianStatusError(dynamic error) {
  //   setState(() {
  //     _status = 'Pedestrian Status not available';
  //   });
  //   debugPrint('Pedestrian status error: $error');
  // }

  void _onStepCountError(dynamic error) {
    setState(() {
      _steps = 'Step Count not available';
    });
    debugPrint('Step count error: $error');
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              _buildBody(context, isLandscape),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildIconButton(
            icon: const Icon(Icons.person, size: 52.0),
            onPressed: () => _navigateTo(context, const ProfileScreen()),
          ),
          _buildIconButton(
            icon: Image.asset('assets/achievement.png', width: 52, height: 52),
            border: true,
            onPressed: () => _navigateTo(context, const AchievementsScreen()),
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton({required Widget icon, required VoidCallback onPressed, bool border = false}) {
    return Container(
      width: 52,
      height: 52,
      decoration: border
          ? BoxDecoration(
        border: Border.all(color: Colors.black, width: 2),
        shape: BoxShape.circle,
      )
          : const BoxDecoration(color: Colors.transparent),
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
      ),
    );
  }

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  Widget _buildBody(BuildContext context, bool isLandscape) {
    final lottieAnimation = Lottie.asset(
      'assets/FootWalk.json',
      fit: BoxFit.contain,
      controller: _controller,
      onLoaded: (composition) {
        _controller
          ..duration = composition.duration
          ..repeat();
      },
    );

    Widget _buildStepsHistory() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _dailyStepsHistory.map((entry) {
          return ListTile(
            title: Text('${entry['date']}'),
            subtitle: Text('${entry['steps']} pasos'),
          );
        }).toList(),
      );
    }

    final stepsText = Column(
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
        const Text('Pasos'),
      ],
    );

    return Center(
      child: isLandscape
          ? Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width * 0.5, child: lottieAnimation),
          stepsText,
        ],
      )
          : Column(
        children: [
          SizedBox(width: MediaQuery.of(context).size.width, child: lottieAnimation),
          stepsText,
          const SizedBox(height: 20),
          _buildStepsHistory(),
        ],
      ),
    );
  }
}
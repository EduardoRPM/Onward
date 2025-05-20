import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:onward/screens/achievements_screen.dart';
import 'package:onward/screens/profile_screen.dart';
import 'package:onward/services/StepService.dart';
import 'package:onward/utils/singleton.dart';
import 'package:pedometer/pedometer.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'constantes.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  StreamSubscription<String>? _achievementSubscription;
  late final Stream<StepCount> _stepCountStream;
  late final Stream<PedestrianStatus> _pedestrianStatusStream;
  late final AnimationController _controller;

  StreamSubscription<StepCount>? _stepCountSubscription;
  int _baseSteps = -1;                   // valor inicial aún no capturado
  int _lastSavedLocal = 0;


  String _currentDate = '';


  int _currentSteps = 0; // Pasos detectados por el sensor en tiempo real
  int _dailyStepCountFromFirebase = 0; // Pasos cargados de Firebase para hoy
  int _lastSavedSteps = 0;
  String get _stepsDisplay => (_dailyStepCountFromFirebase + _currentSteps).toString();
  String _steps = '0'; // Inicializar en '0'
  List<Map<String, dynamic>> _dailyStepsHistory = []; // Para el historial diario

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final stepService = Provider.of<StepService>(context, listen: false);

    // Escucha solo una vez para evitar múltiples suscripciones
    _achievementSubscription?.cancel();
    _achievementSubscription = stepService.achievementStream.listen((message) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          backgroundColor: Color5,
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
          title: Row(
            mainAxisSize: MainAxisSize.min, // <-- Hace el Row lo más compacto posible
            children: [
              const SizedBox(width: 10),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown, // Escala el texto hacia abajo si es necesario
                  child: Text(
                    "¡Logro desbloqueado!",
                    style: TextStyle(
                      color: Color2,
                      fontWeight: FontWeight.bold,
                      fontSize: 100, // Muy grande, pero FittedBox lo ajustará si es necesario
                    ),
                  ),
                ),
              ),

            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset(
                'assets/LottieAchievement.json',
                width: 120,
                height: 120,
                repeat: true,
              ),
              const SizedBox(height: 18),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Color2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color1,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              ),
              icon: Icon(Icons.check_circle_outline, color: Color5),
              label: Text(
                "¡Genial!",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      );
    });



  }


  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);

    _loadInitialDailySteps(); // Cargar pasos iniciales de Firebase
    // _loadDailyStepsHistory(); // Cargar historial de pasos
    _startListeningToSteps(); // Iniciar escucha de pasos del sensor

  }

  void _startListeningToSteps() {
    // Obtiene el stream de pasos
    _stepCountSubscription = Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: (error) {
        print('Error al escuchar pasos: $error');
      },
      onDone: () {
        print('Stream de pasos cerrado');
      },
      cancelOnError: true,
    );
  }


  Future<void> _loadInitialDailySteps() async {
    final userId = StepData().userId;
    if (userId.isEmpty) return;

    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);
    final stepService = Provider.of<StepService>(context, listen: false);
    final steps = await stepService.getDailySteps(userId);


    // final steps = await StepService().getDailySteps(userId);

    setState(() {
      _dailyStepCountFromFirebase = steps;
      _currentDate = today;
      _baseSteps = -1;      // para que en el primer evento del sensor fije bien el offset
      _lastSavedLocal = 0;  // también reinicia el umbral local
      _steps = (_dailyStepCountFromFirebase).toString();
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

  // Future<void> _initPlatformState() async {
  //   _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
  //   // _pedestrianStatusStream.listen(_onPedestrianStatusChanged, onError: _onPedestrianStatusError);
  //
  //   _stepCountStream = Pedometer.stepCountStream;
  //   _stepCountStream.listen(_onStepCount, onError: _onStepCountError);
  // }


  void _onStepCount(StepCount event) {
    if (!mounted) return;

    final now = DateTime.now();
    final today = DateFormat('yyyy-MM-dd').format(now);

    if (today != _currentDate) {
      _loadInitialDailySteps();
      return;
    }

    if (_baseSteps < 0) _baseSteps = event.steps;
    final newSteps = event.steps - _baseSteps;

    setState(() {
      _currentSteps = newSteps;
      _steps = (_dailyStepCountFromFirebase + _currentSteps).toString();
    });

    if ((newSteps - _lastSavedLocal) >= 10) {
      final totalToday = _dailyStepCountFromFirebase + newSteps;

      // Usa la instancia de Provider
      final stepService = Provider.of<StepService>(context, listen: false);
      stepService.saveSteps(StepData().userId, totalToday);

      _lastSavedLocal = newSteps;
    }

  }

  //Mostrar el cumplimiento del logro
  // void _checkAchievements(BuildContext context) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("¡Subiste de nivel!"),
  //         content: Text("Has alcanzado el $nivel en el logro $logro."),
  //         actions: [
  //           TextButton(
  //             child: const Text("OK"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }


  // void _showStepsSavedDialog(BuildContext context, int totalSteps) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: const Text("¡Pasos guardados!"),
  //         content: Text("Has alcanzado $totalSteps pasos hoy."),
  //         actions: [
  //           TextButton(
  //             child: const Text("OK"),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }


  // void _onStepCount(StepCount event) {
  //   if (!mounted) return;
  //   setState(() {
  //     _currentSteps = event.steps;
  //     _steps = _stepsDisplay;
  //   });
  //
  //   final userId = StepData().userId;
  //   if (userId.isNotEmpty) {
  //     if ((event.steps - _lastSavedSteps) >= 10) {
  //       StepService().saveSteps(userId, event.steps);
  //       _lastSavedSteps = event.steps;
  //       // Recargar los pasos diarios de Firebase para la UI
  //       _loadInitialDailySteps();
  //       // También podrías optar por actualizar _dailyStepCountFromFirebase directamente
  //     }
  //   }
  // }

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
    _controller.dispose();
    super.dispose();
    _stepCountSubscription?.cancel();
    _achievementSubscription?.cancel();
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

    // Widget _buildStepsHistory() {
    //   return Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: _dailyStepsHistory.map((entry) {
    //       return ListTile(
    //         title: Text('${entry['date']}'),
    //         subtitle: Text('${entry['steps']} pasos'),
    //       );
    //     }).toList(),
    //   );
    // }

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
          // _buildStepsHistory(),
        ],
      ),
    );
  }
}




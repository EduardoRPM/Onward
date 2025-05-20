import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:onward/services/StepService.dart';
import 'package:onward/welcome.dart';
import 'package:provider/provider.dart';

import 'notifiers/AchievementsNotifier.dart';
import 'notifiers/step_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Solo modo vertical hacia arriba
  ]);

  runApp(
    MultiProvider(
      providers: [
        Provider<StepService>(
          create: (_) => StepService(),
          dispose: (_, service) => service.dispose(),
        ),
        ChangeNotifierProvider<AchievementsNotifier>(
          create: (_) => AchievementsNotifier(''), // userId vacío al iniciar
        ),

      ],

      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const Welcome(), // Start with the welcome screen
    );

    //   MaterialApp(
    //   debugShowCheckedModeBanner: false,
    //   title: 'My App',
    //   home: FirebaseAuth.instance.currentUser == null ? const Welcome() : const Home(),
    //   routes: {
    //     '/welcome': (context) => const Welcome(),
    //     // '/login': (context) => const LoginScreen(),
    //     '/register': (context) => const RegisterScreen(),
    //     '/home': (context) => const Home(),
    //   },
    // );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:onward/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  runApp(const MyApp());
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

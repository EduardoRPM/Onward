import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onward/screens/logIn.dart';
import 'package:onward/welcome.dart';
import 'home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
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

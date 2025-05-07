import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider()];

    void onSignedIn() {
      Navigator.pushReplacementNamed(context, '/home');
    }

    return SignInScreen(
      providers: providers,
      actions: [
        AuthStateChangeAction<UserCreated>((context, state) {
          onSignedIn();
        }),
        AuthStateChangeAction<SignedIn>((context, state) {
          onSignedIn();
        }),
      ],
    );
  }
}

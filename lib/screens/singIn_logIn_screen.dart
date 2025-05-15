import 'package:cloud_firestore/cloud_firestore.dart'; // Importa FirebaseFirestore
import 'package:intl/intl.dart'; // Importa DateFormat
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:onward/home.dart';

import '../services/auth_service.dart';
import '../utils/singleton.dart';

class SinginLoginScreen extends StatefulWidget {
  final bool isLogin;

  const SinginLoginScreen({super.key, this.isLogin = true});

  @override
  State<SinginLoginScreen> createState() => _LoginState();
}

class _LoginState extends State<SinginLoginScreen> {
  final _formKey = GlobalKey<FormState>(); //Es una llave única que le permite a Flutter acceder al estado interno del widget <Form>, como validar campos, resetear el formulario, o guardar valores.
  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  late bool _isLogin;
  String? _errorMessage;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Inicializa _firestore

  @override
  void initState() {
    super.initState();
    _isLogin = widget.isLogin;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        UserCredential? userCredential;
        if (_isLogin) { // Si estamos en modo de inicio de sesiónn
          userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          );
        } else { // Si estamos en modo de registro
          await AuthService().registrarUsuario(
            nombre: _nameController.text.trim(),
            mail: _emailController.text.trim(),
            username: _usernameController.text.trim(),
            password: _passwordController.text.trim(),
          );
          // Después del registro, también podrías querer loguear al usuario directamente
          userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
        }

        if (userCredential?.user != null && mounted) {
          // Forzar la carga de datos frescos de Firestore y actualizar SharedPreferences
          await UserDataService().cargarDatosUsuario(forceReload: true);
          StepData().userId = userCredential!.user!.uid; // Actualiza el userId aquí

          // Crear registro inicial de pasos para el nuevo usuario
          final now = DateTime.now();
          final formattedDate = DateFormat('yyyy-MM-dd').format(now);
          final stepsDocRef = _firestore
              .collection('Usuarios')
              .doc(userCredential.user!.uid) // Usar el UID del nuevo usuario
              .collection('Pasos')
              .doc(formattedDate);

          await stepsDocRef.set({'date': now, 'steps': 0});

          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const Home()),
                (route) => false, // Remove all previous routes
          );
        }
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message;
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'An unexpected error occurred';
        });
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isLogin ? 'Login' : 'Register'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // App logo or icon
                Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Colors.blue.shade700,
                ),
                const SizedBox(height: 32),

                // Title
                Text(
                  _isLogin ? 'Welcome Back' : 'Create Account',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Name field (only for registration)
                if (!_isLogin) ...[
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: Icon(Icons.person_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Username field (only for registration)
                  TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      prefixIcon: Icon(Icons.alternate_email),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a username';
                      }
                      if (value.contains(' ')) {
                        return 'Username cannot contain spaces';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Password field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm password field (only for registration)
                if (!_isLogin) ...[
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                ],

                // Error message
                if (_errorMessage != null) ...[
                  Text(
                    _errorMessage!,
                    style: TextStyle(color: Theme.of(context).colorScheme.error),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],

                // Submit button
                ElevatedButton(
                  onPressed: _isLoading ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(_isLogin ? 'Login' : 'Register'),
                ),
                const SizedBox(height: 16),

                // Toggle between login and register
                TextButton(
                  onPressed: () {
                    setState(() {
                      _isLogin = !_isLogin;
                      _errorMessage = null;
                    });
                  },
                  child: Text(
                    _isLogin
                        ? 'Don\'t have an account? Register'
                        : 'Already have an account? Login',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
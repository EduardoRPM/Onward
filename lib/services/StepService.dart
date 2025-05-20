// services/step_service.dart

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'AchievementService.dart';

class StepService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Notificador de eventos de logro desbloqueado
  final StreamController<String> _achievementController = StreamController<String>.broadcast();
  Stream<String> get achievementStream => _achievementController.stream;

  StepService();

  Future<void> saveSteps(String userId, int steps) async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);

    try {
      final stepsDocRef = _firestore
          .collection('Usuarios')
          .doc(userId)
          .collection('Pasos')
          .doc(formattedDate);

      await stepsDocRef.set({
        'date': now,
        'steps': steps,
      });
      print('Pasos guardados para el día: $formattedDate');
      // await _achievementService.checkAndUnlockAchievements(userId, steps);
      await _checkAchievements(userId, steps, formattedDate);

    } catch (e) {
      print('Error al guardar los pasos: $e');
    }
  }


  Future<void> _checkAchievements(String userId, int steps, String date) async {
    final docRef = _firestore
        .collection('Usuarios')
        .doc(userId)
        .collection('Logros')
        .doc('FirstStep');

    try {
      final doc = await docRef.get();
      final currentLevel = doc.data()?['nivel'] ?? 0;

      if (!doc.exists && steps >= 10) {
        await docRef.set({
          'title': 'First Step',
          'descripcion': 'Begin your walking journey',
          'nivel': 1,
          'unlockedAt': FieldValue.serverTimestamp(),
        });
        print('Logro First Step desbloqueado: nivel 1');
        _achievementController.add('¡Has desbloqueado el logro "First Step"!'); // <--- Notifica

      } else if (steps >= 30 && currentLevel < 2) {
        await docRef.update({
          'nivel': 2,
          'unlockedAt': FieldValue.serverTimestamp(),
        });
        print('Logro First Step actualizado a nivel 2');
        _achievementController.add('¡Logro "First Step" actualizado a nivel 2!'); // <--- Notifica
      }
      else if (steps >= 50 && currentLevel < 3) {
        await docRef.update({
          'nivel': 3,
          'unlockedAt': FieldValue.serverTimestamp(),
        });
        print('Logro First Step actualizado a nivel 3');
        _achievementController.add('¡Logro "First Step" actualizado a nivel 3!'); // <--- Notifica
      }

    } catch (e) {
      print('Error al procesar logro First Step: $e');
    }

    // Agrega más logros aquí
  }




  Future<int> getDailySteps(String userId) async {
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd').format(now);

    try {
      final stepsSnapshot = await _firestore
          .collection('Usuarios')
          .doc(userId)
          .collection('Pasos')
          .doc(formattedDate)
          .get();

      if (stepsSnapshot.exists) {
        final data = stepsSnapshot.data() as Map<String, dynamic>?;
        return data?['steps'] as int? ?? 0;
      } else {
        print('No data found for user $userId on $formattedDate, returning 0.'); // <-- Agregar esta línea
        return 0;
      }
    } catch (e) {
      print('Error al obtener los pasos diarios: $e');
      return 0;
    }
  }

  void dispose() {
    _achievementController.close();
  }

  Future<List<Map<String, dynamic>>> getAllSteps(String userId) async {
    List<Map<String, dynamic>> allStepsData = [];
    try {
      final stepsCollection = await _firestore
          .collection('Usuarios')
          .doc(userId)
          .collection('Pasos')
          .get();

      for (var doc in stepsCollection.docs) {
        final data = doc.data();
        if (data.containsKey('steps') && data.containsKey('date')) {
          allStepsData.add({
            'date': DateFormat('yyyy-MM-dd').format((data['date'] as Timestamp).toDate()),
            'steps': data['steps'],
          });
        }
      }
    } catch (e) {
      print('Error al obtener todo el historial de pasos: $e');
    }
    return allStepsData;
  }
}

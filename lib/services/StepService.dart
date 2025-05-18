// services/step_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../notifiers/step_notifier.dart';

class StepService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final StepNotifier stepNotifier;

  StepService(this.stepNotifier);

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

      // Verificar y notificar logros
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
      int newLevel = currentLevel;

      if (!doc.exists && steps >= 10) {
        newLevel = 1;
        await docRef.set({
          'title': 'First Step',
          'descripcion': 'Begin your walking journey',
          'nivel': newLevel,
          'unlockedAt': FieldValue.serverTimestamp(),
        });
        print('Logro First Step desbloqueado: nivel $newLevel');
      } else if (steps >= 30 && currentLevel < 2) {
        newLevel = 2;
        await docRef.update({
          'nivel': newLevel,
          'unlockedAt': FieldValue.serverTimestamp(),
        });
        print('Logro First Step actualizado a nivel $newLevel');
      }

      // 🔔 Notifica si hay nuevo nivel
      if (newLevel > currentLevel) {
        stepNotifier.updateLevel(newLevel);
      }

    } catch (e) {
      print('Error al procesar logro First Step: $e');
    }
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
        print('No hay pasos registrados para $formattedDate');
        return 0;
      }
    } catch (e) {
      print('Error al obtener los pasos diarios: $e');
      return 0;
    }
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
            'date': DateFormat('yyyy-MM-dd')
                .format((data['date'] as Timestamp).toDate()),
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

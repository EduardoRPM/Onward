import 'package:cloud_firestore/cloud_firestore.dart';

class AchievementService {
  final FirebaseFirestore _firestore;

  AchievementService(this._firestore);

  Future<void> checkAndUnlockAchievements(String userId, int steps) async {
    final logrosCollection = _firestore
        .collection('Usuarios')
        .doc(userId)
        .collection('Logros');

    final docRef = logrosCollection.doc('first_step');
    final doc = await docRef.get();

    if (steps >= 10) {
      if (!doc.exists) {
        // Crear el logro nivel 1
        await docRef.set({
          'title': 'First Step',
          'descripcion': 'Begin your walking journey',
          'nivel': 1,
          'unlockedAt': FieldValue.serverTimestamp(),
        });
        print('Logro First Step desbloqueado: nivel 1');
      } else {
        // Si ya existe, actualizar nivel si pasos >= 30 y nivel actual < 2
        final currentLevel = doc.data()?['nivel'] ?? 0;
        if (steps >= 30 && currentLevel < 2) {
          await docRef.update({
            'nivel': 2,
            'unlockedAt': FieldValue.serverTimestamp(),
          });
          print('Logro First Step actualizado a nivel 2');
        }
      }
    }
  }
}




















// import '../models/achievement.dart';
//
// class AchievementService {
//   /// Retorna: par de (lista actualizada de logros, y niveles recién completados).
//   (List<Achievement> updatedAchievements, Map<String, List<int>> newlyCompletedLevels)
//   evaluateAchievements({
//     required List<Achievement> achievements,
//     required Map<String, dynamic> userStats,
//   }) {
//     Map<String, List<int>> newlyCompleted = {};
//
//     final updatedAchievements = achievements.map((achievement) {
//       final updatedLevels = achievement.levels.map((level) {
//         final wasCompleted = level.completed;
//         final isCompleted = _checkLevelCompletion(
//           achievementId: achievement.id,
//           level: level.level,
//           userStats: userStats,
//         );
//
//         // Detectar si se completó AHORA
//         if (!wasCompleted && isCompleted) {
//           newlyCompleted.putIfAbsent(achievement.id, () => []).add(level.level);
//         }
//
//         return AchievementLevel(
//           level: level.level,
//           description: level.description,
//           completed: isCompleted,
//         );
//       }).toList();
//
//       return Achievement(
//         id: achievement.id,
//         title: achievement.title,
//         description: achievement.description,
//         icon: achievement.icon,
//         levels: updatedLevels,
//       );
//     }).toList();
//
//     return (updatedAchievements, newlyCompleted);
//   }
//
//   /// Lógica de verificación
//   bool _checkLevelCompletion({
//     required String achievementId,
//     required int level,
//     required Map<String, dynamic> userStats,
//   }) {
//     switch (achievementId) {
//       case 'explorer':
//         final steps = userStats['steps'] ?? 0;
//         if (level == 1) return steps >= 10;
//         if (level == 2) return steps >= 50;
//         if (level == 3) return steps >= 120;
//         return false;
//
//       case 'first-step':
//         return userStats['steps'] >= 1;
//
//       case 'streak-master':
//         final streak = userStats['streak'] ?? 0;
//         if (level == 1) return streak >= 3;
//         if (level == 2) return streak >= 7;
//         return false;
//
//       default:
//         return false;
//     }
//   }
//
//   Future<void> _checkAchievements(String userId, int steps, String date) async {
//     if (steps >= 10) {
//       print('🎉 Logro alcanzado: ¡10 pasos completados!');
//       //
//       // final logroRef = _firestore
//       //     .collection('Usuarios')
//       //     .doc(userId)
//       //     .collection('Logros')
//       //     .doc('10_pasos');
//       //
//       // await logroRef.set({
//       //   'logro': '10 pasos',
//       //   'fecha': DateTime.now(),
//       //   'completado': true,
//       // });
//     }
//
//     // Aquí puedes seguir agregando más logros:
//     // if (steps >= 100) { ... }
//   }
//
// }
//
//

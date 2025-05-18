const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const firestore = admin.firestore();

// Definiciones de logros y niveles
const achievementDefinitions = [
  {
    id: "explorer",
    title: "Explorer",
    description: "Reach total step milestones",
    levels: [10, 20, 30], // pasos totales para niveles 1,2,3
  }
];

exports.onStepsCreated = functions.firestore
  .document("Usuarios/{userId}/pasos/{stepId}")
  .onCreate(async (snapshot, context) => {
    const userId = context.params.userId;
    const newStepData = snapshot.data();
    console.log(`Nuevo paso creado para el usuario ${userId}:`, newStepData);

    try {
      // Leer todos los registros de pasos
      const stepsSnapshot = await firestore
        .collection("Usuarios")
        .doc(userId)
        .collection("pasos")
        .orderBy("date")
        .get();

      const userSteps = stepsSnapshot.docs.map(doc => ({
        ...doc.data(),
        date: doc.data().date instanceof admin.firestore.Timestamp ? doc.data().date.toDate() : null,
          }));
      // Referencia al documento de usuario
      const userDocRef = firestore.collection("Usuarios").doc(userId);
      const userDoc = await userDocRef.get();
      const userData = userDoc.data() || {};
      const completedAchievements = userData.completedAchievements || {};
      const updatedAchievements = { ...completedAchievements };

      // Helper para marcar logros
      function _updateAchievement(id, condition) {
        if (condition && !updatedAchievements[id]) {
          updatedAchievements[id] = admin.firestore.FieldValue.serverTimestamp();
        }
      }

      // Logros First Step (pasos en el día)
      achievementDefinitions
        .find(a => a.id === "first-step")
        .levels.forEach((threshold, idx) => {
          const levelKey = `first-step-${idx + 1}`;
          const met = userSteps.some(s => isSameDay(s.date, new Date()) && (s.count || 0) >= threshold);
          _updateAchievement(levelKey, met);
        });

      // Logros Explorer (pasos totales)
      const totalSteps = userSteps.reduce((sum, s) => sum + (s.count || 0), 0);
      achievementDefinitions
        .find(a => a.id === "explorer")
        .levels.forEach((threshold, idx) => {
          const levelKey = `explorer-${idx + 1}`;
          _updateAchievement(levelKey, totalSteps >= threshold);
        });

      // Logros Streak Master (racha diaria)
      const streak = calculateStreak(userSteps.map(s => s.date));
      achievementDefinitions
        .find(a => a.id === "streak-master")
        .levels.forEach((threshold, idx) => {
          const levelKey = `streak-master-${idx + 1}`;
          _updateAchievement(levelKey, streak >= threshold);
        });

      // Logros Day & Night Walker
      const times = { day: [6, 18], evening: [18, 22], night: [22, 6] };
      Object.entries(times).forEach(([period, [start, end]], idx) => {
        const levelKey = `day-night-${idx + 1}`;
        const met = userSteps.some(s => isWalkedAtTime(s.date, start, end));
        _updateAchievement(levelKey, met);
      });

      // Actualizar si hay nuevos logros
      const newOnes = Object.keys(updatedAchievements).filter(k => !completedAchievements[k]);
      if (newOnes.length) {
        await userDocRef.update({ completedAchievements: updatedAchievements });
        console.log(`Nuevos logros para ${userId}:`, newOnes);
      }
    } catch (error) {
      console.error("Error al procesar logros:", error);
    }
  });

// Funciones auxiliares

function isSameDay(d1, d2) {
  return d1 && d2 && d1.getDate() === d2.getDate() && d1.getMonth() === d2.getMonth() && d1.getFullYear() === d2.getFullYear();
}

function isWalkedAtTime(date, startHour, endHour) {
  if (!date) return false;
  const h = date.getHours();
  if (startHour < endHour) return h >= startHour && h < endHour;
  return h >= startHour || h < endHour;
}

function calculateStreak(dates) {
  const uniqueDays = [...new Set(dates.filter(d => d).map(d => d.toISOString().slice(0, 10)))];
  uniqueDays.sort();
  let streak = 0;
  let today = new Date(); today.setHours(0, 0, 0, 0);
  while (uniqueDays.includes(today.toISOString().slice(0, 10))) {
    streak++;
    today = new Date(today.getTime() - 86400000);
  }
  return streak;
}

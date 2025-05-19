import 'package:flutter/material.dart';

class StepNotifier extends ChangeNotifier {
  int _level = 0;
  String? _achievementTitle;
  String? _achievementDescription;

  int get level => _level;
  String? get achievementTitle => _achievementTitle;
  String? get achievementDescription => _achievementDescription;

  void updateAchievement(int newLevel, String title, String description) {
    if (newLevel > _level) {
      _level = newLevel;
      _achievementTitle = title;
      _achievementDescription = description;
      notifyListeners();
    }
  }

  // Opcional: para limpiar después de mostrar
  void clearAchievement() {
    _achievementTitle = null;
    _achievementDescription = null;
    notifyListeners();
  }
}

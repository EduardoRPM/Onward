import 'package:flutter/material.dart';

class StepNotifier extends ChangeNotifier {
  int _currentLevel = 0;
  int get currentLevel => _currentLevel;

  void updateLevel(int newLevel) {
    if (newLevel > _currentLevel) {
      _currentLevel = newLevel;
      notifyListeners(); // Notifica a la UI que hay un nuevo nivel
    }
  }
}

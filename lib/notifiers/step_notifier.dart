import 'package:flutter/cupertino.dart';

class StepNotifier extends ChangeNotifier {
  int _currentLevel = 0;

  int get currentLevel => _currentLevel;

  void updateSteps(int steps) {
    int newLevel = (steps / 1000).floor();

    if (newLevel > _currentLevel) {
      _currentLevel = newLevel;
      notifyListeners(); // Notifica que el nivel subió
    }
  }
}

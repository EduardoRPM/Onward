// step_data.dart
class StepData {
  // Singleton: instancia única
  static final StepData _instance = StepData._internal();

  // Acceso al singleton
  factory StepData() => _instance;

  // Constructor privado
  StepData._internal();

  // Variable para almacenar pasos
  int _steps = 0;

  int get steps => _steps;

  set steps(int value) {
    _steps = value;
  }
}

import 'dart:async';
import 'package:pedometer/pedometer.dart';

class PedometerService {
  final StreamController<int> _stepCountController = StreamController<int>.broadcast();

  Stream<int> get stepCountStream => _stepCountController.stream;

  void startListening() {
    Pedometer.stepCountStream.listen(
          (StepCount event) {
        _stepCountController.add(event.steps);
      },
      onError: (error) {
        print('Pedometer error: $error');
      },
    );
  }

  void dispose() {
    _stepCountController.close();
  }
}

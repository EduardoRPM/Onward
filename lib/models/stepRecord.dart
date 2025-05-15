// models/step_record.dart

class StepRecord {
  final String date; // formato 'yyyy-MM-dd'
  final int steps;

  StepRecord({required this.date, required this.steps});

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'steps': steps,
    };
  }

  factory StepRecord.fromMap(Map<String, dynamic> map) {
    return StepRecord(
      date: map['date'],
      steps: map['steps'],
    );
  }
}

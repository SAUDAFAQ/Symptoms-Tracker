import '../../domain/entities/symptom.dart';

class SymptomModel extends Symptom {
  const SymptomModel({
    required super.id,
    required super.name,
    required super.severity,
    required super.date,
  });

  factory SymptomModel.fromJson(Map<String, dynamic> json) {
    return SymptomModel(
      id: json['id'] as String,
      name: json['name'] as String,
      severity: json['severity'] as int,
      date: DateTime.parse(json['date'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'severity': severity,
      'date': date.toIso8601String(),
    };
  }

  factory SymptomModel.fromEntity(Symptom symptom) {
    return SymptomModel(
      id: symptom.id,
      name: symptom.name,
      severity: symptom.severity,
      date: symptom.date,
    );
  }
}

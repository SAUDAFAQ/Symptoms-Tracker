import 'package:equatable/equatable.dart';

class Symptom extends Equatable {
  final String id;
  final String name;
  final int severity; // 1-5 scale
  final DateTime date;

  const Symptom({
    required this.id,
    required this.name,
    required this.severity,
    required this.date,
  });

  @override
  List<Object> get props => [id, name, severity, date];
}

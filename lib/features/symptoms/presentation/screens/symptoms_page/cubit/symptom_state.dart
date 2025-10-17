import 'package:equatable/equatable.dart';
import '../../../../domain/entities/symptom.dart';

abstract class SymptomState extends Equatable {
  const SymptomState();

  @override
  List<Object> get props => [];
}

class SymptomInitial extends SymptomState {}

class SymptomLoading extends SymptomState {}

class SymptomLoaded extends SymptomState {
  final List<Symptom> symptoms;
  final DateTime selectedDate;

  const SymptomLoaded({
    required this.symptoms,
    required this.selectedDate,
  });

  @override
  List<Object> get props => [symptoms, selectedDate];
}

class SymptomError extends SymptomState {
  final String message;

  const SymptomError(this.message);

  @override
  List<Object> get props => [message];
}

class SymptomAdded extends SymptomState {
  final Symptom symptom;

  const SymptomAdded(this.symptom);

  @override
  List<Object> get props => [symptom];
}

class SymptomDeleted extends SymptomState {
  final String symptomId;

  const SymptomDeleted(this.symptomId);

  @override
  List<Object> get props => [symptomId];
}

class SymptomValidationError extends SymptomState {
  final String message;

  const SymptomValidationError(this.message);

  @override
  List<Object> get props => [message];
}

class SymptomSaveSuccess extends SymptomState {
  final String message;

  const SymptomSaveSuccess(this.message);

  @override
  List<Object> get props => [message];
}

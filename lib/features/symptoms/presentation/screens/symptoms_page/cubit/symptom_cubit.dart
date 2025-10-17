import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/symptom.dart';
import '../../../../domain/repositories/symptom_repository.dart';
import 'symptom_state.dart';

class SymptomCubit extends Cubit<SymptomState> {
  final SymptomRepository repository;

  SymptomCubit({required this.repository}) : super(SymptomInitial());

  Future<void> loadSymptoms() async {
    emit(SymptomLoading());
    try {
      final symptoms = await repository.getSymptoms();
      emit(SymptomLoaded(
        symptoms: symptoms,
        selectedDate: DateTime.now(),
      ));
    } catch (e) {
      emit(SymptomError('Failed to load symptoms: ${e.toString()}'));
    }
  }

  Future<void> loadSymptomsByDate(DateTime date) async {
    emit(SymptomLoading());
    try {
      final symptoms = await repository.getSymptomsByDate(date);
      emit(SymptomLoaded(
        symptoms: symptoms,
        selectedDate: date,
      ));
    } catch (e) {
      emit(SymptomError('Failed to load symptoms: ${e.toString()}'));
    }
  }

  Future<void> saveSymptoms({
    required Map<String, bool> selectedSymptoms,
    required Map<String, String> symptomSeverity,
    required DateTime date,
  }) async {
    // Validate if any symptoms are selected
    bool hasSelectedSymptoms = selectedSymptoms.values.any((isSelected) => isSelected);
    
    if (!hasSelectedSymptoms) {
      emit(SymptomValidationError('Please select at least one skin or hair condition'));
      return;
    }

    try {
      emit(SymptomLoading());
      
      // Count symptoms to save
      int symptomsToSave = 0;
      for (String symptom in selectedSymptoms.keys) {
        if (selectedSymptoms[symptom] == true) {
          symptomsToSave++;
        }
      }

      // Save all selected symptoms
      int counter = 0;
      for (String symptom in selectedSymptoms.keys) {
        if (selectedSymptoms[symptom] == true) {
          final severity = _getSeverityValue(symptomSeverity[symptom]!);
          final symptomEntity = Symptom(
            id: '${DateTime.now().millisecondsSinceEpoch}_${symptom}_${counter++}',
            name: _getSymptomName(symptom),
            severity: severity,
            date: date,
          );
          
          await repository.addSymptom(symptomEntity);
        }
      }

      // Emit success state
      emit(SymptomSaveSuccess(
        symptomsToSave == 1 
          ? 'Symptom added successfully!' 
          : '$symptomsToSave symptoms added successfully!'
      ));
      
      // Reload symptoms for the selected date
      await loadSymptomsByDate(date);
    } catch (e) {
      emit(SymptomError('Failed to save symptoms: ${e.toString()}'));
    }
  }

  Future<void> deleteSymptom(String id) async {
    try {
      await repository.deleteSymptom(id);
      emit(SymptomDeleted(id));
      
      // Reload all symptoms to refresh the list
      await loadSymptoms();
    } catch (e) {
      emit(SymptomError('Failed to delete symptom: ${e.toString()}'));
    }
  }

  // Helper methods
  int _getSeverityValue(String severity) {
    switch (severity) {
      case 'None': return 1;
      case 'Low': return 2;
      case 'Medium': return 3;
      case 'High': return 4;
      case 'Severe': return 5;
      default: return 1;
    }
  }

  String _getSymptomName(String key) {
    switch (key) {
      case 'dry': return 'Skin Dryness';
      case 'itchy': return 'Itchiness';
      case 'hair_loss': return 'Hair Loss';
      default: return key;
    }
  }
}

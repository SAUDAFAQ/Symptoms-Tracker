import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/symptom_model.dart';

abstract class SymptomLocalDataSource {
  Future<List<SymptomModel>> getSymptoms();
  Future<List<SymptomModel>> getSymptomsByDate(DateTime date);
  Future<void> addSymptom(SymptomModel symptom);
  Future<void> updateSymptom(SymptomModel symptom);
  Future<void> deleteSymptom(String id);
}

class SymptomLocalDataSourceImpl implements SymptomLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String _symptomsKey = 'symptoms';

  SymptomLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<SymptomModel>> getSymptoms() async {
    final symptomsJson = sharedPreferences.getStringList(_symptomsKey) ?? [];
    return symptomsJson
        .map((json) => SymptomModel.fromJson(jsonDecode(json)))
        .toList();
  }

  @override
  Future<List<SymptomModel>> getSymptomsByDate(DateTime date) async {
    final allSymptoms = await getSymptoms();
    return allSymptoms.where((symptom) {
      return symptom.date.year == date.year &&
          symptom.date.month == date.month &&
          symptom.date.day == date.day;
    }).toList();
  }

  @override
  Future<void> addSymptom(SymptomModel symptom) async {
    final symptoms = await getSymptoms();
    symptoms.add(symptom);
    await _saveSymptoms(symptoms);
  }

  @override
  Future<void> updateSymptom(SymptomModel symptom) async {
    final symptoms = await getSymptoms();
    final index = symptoms.indexWhere((s) => s.id == symptom.id);
    if (index != -1) {
      symptoms[index] = symptom;
      await _saveSymptoms(symptoms);
    }
  }

  @override
  Future<void> deleteSymptom(String id) async {
    final symptoms = await getSymptoms();
    symptoms.removeWhere((s) => s.id == id);
    await _saveSymptoms(symptoms);
  }

  Future<void> _saveSymptoms(List<SymptomModel> symptoms) async {
    final symptomsJson = symptoms
        .map((symptom) => jsonEncode(symptom.toJson()))
        .toList();
    await sharedPreferences.setStringList(_symptomsKey, symptomsJson);
  }
}

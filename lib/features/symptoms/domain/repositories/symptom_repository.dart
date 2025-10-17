import '../entities/symptom.dart';

abstract class SymptomRepository {
  Future<List<Symptom>> getSymptoms();
  Future<List<Symptom>> getSymptomsByDate(DateTime date);
  Future<void> addSymptom(Symptom symptom);
  Future<void> updateSymptom(Symptom symptom);
  Future<void> deleteSymptom(String id);
}

import '../../domain/entities/symptom.dart';
import '../../domain/repositories/symptom_repository.dart';
import '../datasources/symptom_local_datasource.dart';
import '../models/symptom_model.dart';

class SymptomRepositoryImpl implements SymptomRepository {
  final SymptomLocalDataSource localDataSource;

  SymptomRepositoryImpl({required this.localDataSource});

  @override
  Future<List<Symptom>> getSymptoms() async {
    final symptoms = await localDataSource.getSymptoms();
    return symptoms;
  }

  @override
  Future<List<Symptom>> getSymptomsByDate(DateTime date) async {
    final symptoms = await localDataSource.getSymptomsByDate(date);
    return symptoms;
  }

  @override
  Future<void> addSymptom(Symptom symptom) async {
    final symptomModel = SymptomModel.fromEntity(symptom);
    await localDataSource.addSymptom(symptomModel);
  }

  @override
  Future<void> updateSymptom(Symptom symptom) async {
    final symptomModel = SymptomModel.fromEntity(symptom);
    await localDataSource.updateSymptom(symptomModel);
  }

  @override
  Future<void> deleteSymptom(String id) async {
    await localDataSource.deleteSymptom(id);
  }
}

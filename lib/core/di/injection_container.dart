import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/symptoms/data/datasources/symptom_local_datasource.dart';
import '../../features/symptoms/data/repositories/symptom_repository_impl.dart';
import '../../features/symptoms/domain/repositories/symptom_repository.dart';
import '../../features/symptoms/presentation/cubit/symptom_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Data sources
  sl.registerLazySingleton<SymptomLocalDataSource>(
    () => SymptomLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Repository
  sl.registerLazySingleton<SymptomRepository>(
    () => SymptomRepositoryImpl(localDataSource: sl()),
  );

  // Cubit
  sl.registerFactory(() => SymptomCubit(repository: sl()));
}

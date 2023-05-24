import 'package:cleanarch_project/core/platform/network_info.dart';
import 'package:cleanarch_project/core/util/input_converter.dart';
import 'package:cleanarch_project/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:cleanarch_project/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:cleanarch_project/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:cleanarch_project/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:cleanarch_project/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:cleanarch_project/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - NumberTrivia
  initFeatures();
  //! Core
  initCore();
  //! External Deps
  await initExternalDeps();
}

void initFeatures() {
  sl.registerFactory(() => NumberTriviaBloc(
      getConcreteNumberTrivia: sl(),
      getRandomNumberTrivia: sl(),
      inputConverter: sl()));

  //! UseCases
  sl.registerLazySingleton(() => GetConcreteNumberTrivia(sl()));
  sl.registerLazySingleton(() => GetRandomNumberTrivia(sl()));

  //! Repositories
  sl.registerLazySingleton<NumberTriviaRepository>(() =>
      NumberTriviaRepositoryImpl(
          remoteDataSource: sl(), localDataSource: sl(), networkInfo: sl()));

  //! Datasources
  sl.registerLazySingleton<NumberTriviaRemoteDataSource>(
      () => NumberTriviaRemoteDataSourceImpl(client: sl()));
  sl.registerLazySingleton<NumberTriviaLocalDataSource>(
      () => NumberTriviaLocalDataSourceImpl(sharedPreferences: sl()));
}

void initCore() {
  sl.registerLazySingleton(() => InputConverter());
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}

Future<void> initExternalDeps() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => http.Client());
  sl.registerLazySingleton(() => InternetConnectionChecker());
}

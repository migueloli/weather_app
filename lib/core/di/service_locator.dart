import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:weather_app/core/config/env_config.dart';
import 'package:weather_app/core/network/api_client.dart';
import 'package:weather_app/core/network/api_key_interceptor.dart';
import 'package:weather_app/core/network/connectivity_service.dart';
import 'package:weather_app/core/network/dio_api_client.dart';
import 'package:weather_app/data/datasources/city_local_data_source_impl.dart';
import 'package:weather_app/data/datasources/city_remote_data_source_impl.dart';
import 'package:weather_app/data/datasources/contracts/city_local_data_source.dart';
import 'package:weather_app/data/datasources/contracts/city_remote_data_source.dart';
import 'package:weather_app/data/datasources/contracts/weather_local_data_source.dart';
import 'package:weather_app/data/datasources/contracts/weather_remote_data_source.dart';
import 'package:weather_app/data/datasources/weather_local_data_source_impl.dart';
import 'package:weather_app/data/datasources/weather_remote_data_source_impl.dart';
import 'package:weather_app/data/repositories/city_repository.dart';
import 'package:weather_app/data/repositories/local_city_repository.dart';
import 'package:weather_app/data/repositories/weather_repository.dart';
import 'package:weather_app/domain/repositories/city_repository_interface.dart';
import 'package:weather_app/domain/repositories/local_city_repository_interface.dart';
import 'package:weather_app/domain/repositories/weather_repository_interface.dart';
import 'package:weather_app/domain/use_cases/get_saved_cities_use_case.dart';
import 'package:weather_app/domain/use_cases/get_weather_updated_timestamp_use_case.dart';
import 'package:weather_app/domain/use_cases/get_weather_use_case.dart';
import 'package:weather_app/domain/use_cases/remove_saved_city_use_case.dart';
import 'package:weather_app/domain/use_cases/save_city_use_case.dart';
import 'package:weather_app/domain/use_cases/search_cities_use_case.dart';
import 'package:weather_app/objectbox.g.dart';
import 'package:weather_app/presentation/city_search/bloc/city_search_bloc.dart';
import 'package:weather_app/presentation/home/bloc/home_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencies() async {
  // Register ObjectBox Store asynchronously & wait for completion
  final store = await _initObjectBox();
  getIt.registerSingleton<Store>(store);

  // Register API Client
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.weatherApiBaseUrl,
        headers: {'Content-Type': 'application/json'},
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.add(const ApiKeyInterceptor());
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(requestBody: true, responseBody: true),
      );
    }
    return dio;
  });

  getIt.registerLazySingleton<ApiClient>(
    () => DioApiClient(dioClient: getIt()),
  );

  getIt.registerLazySingleton<ConnectivityService>(
    ConnectivityService.new,
    dispose: (param) => param.dispose(),
  );

  // Register datasources
  getIt.registerLazySingleton<CityRemoteDataSource>(
    () => CityRemoteDataSourceImpl(apiClient: getIt()),
  );

  getIt.registerLazySingleton<WeatherRemoteDataSource>(
    () => WeatherRemoteDataSourceImpl(apiClient: getIt()),
  );

  getIt.registerLazySingleton<WeatherLocalDataSource>(
    () => WeatherLocalDataSourceImpl(store: getIt()),
  );

  getIt.registerLazySingleton<CityLocalDataSource>(
    () => CityLocalDataSourceImpl(store: getIt()),
  );

  // Register Repository Implementations
  getIt.registerLazySingleton<CityRepositoryInterface>(
    () => CityRepository(remoteDataSource: getIt()),
  );

  getIt.registerLazySingleton<LocalCityRepositoryInterface>(
    () => LocalCityRepository(localDataSource: getIt()),
  );

  getIt.registerLazySingleton<WeatherRepositoryInterface>(
    () =>
        WeatherRepository(remoteDataSource: getIt(), localDataSource: getIt()),
  );

  // Register Use Cases
  getIt.registerLazySingleton<GetWeatherUseCase>(
    () => GetWeatherUseCase(getIt()),
  );

  getIt.registerLazySingleton<GetWeatherUpdatedTimestampUseCase>(
    () => GetWeatherUpdatedTimestampUseCase(getIt()),
  );

  getIt.registerLazySingleton<SearchCitiesUseCase>(
    () => SearchCitiesUseCase(getIt()),
  );

  getIt.registerLazySingleton(
    () => RemoveSavedCityUseCase(localCityRepository: getIt()),
  );

  getIt.registerLazySingleton(
    () => SaveCityUseCase(localCityRepository: getIt()),
  );

  getIt.registerFactory(
    () => GetSavedCitiesUseCase(localCityRepository: getIt()),
  );

  // Register BLoCs
  getIt.registerFactory(
    () => CitySearchBloc(
      searchCitiesUseCase: getIt(),
      saveCityUseCase: getIt(),
      removeSavedCityUseCase: getIt(),
      getSavedCitiesUseCase: getIt(),
    ),
  );

  getIt.registerFactory(
    () => HomeBloc(
      getSavedCitiesUseCase: getIt(),
      removeSavedCityUseCase: getIt(),
      getWeatherUseCase: getIt(),
    ),
  );
}

Future<Store> _initObjectBox() async {
  final docsDir = await getApplicationDocumentsDirectory();
  final directory = p.join(docsDir.path, 'weather_app_db');
  return openStore(directory: directory);
}

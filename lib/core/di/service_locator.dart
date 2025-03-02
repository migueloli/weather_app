import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:get_it/get_it.dart';
import 'package:weather_app/core/config/env_config.dart';
import 'package:weather_app/core/network/api_client.dart';
import 'package:weather_app/core/network/api_key_interceptor.dart';
import 'package:weather_app/core/network/dio_api_client.dart';
import 'package:weather_app/data/repositories/city_repository.dart';
import 'package:weather_app/data/services/geocoding_service.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // API
  getIt.registerLazySingleton(() {
    final dio = Dio(
      BaseOptions(
        baseUrl: EnvConfig.weatherApiBaseUrl,
        headers: {'Content-Type': 'application/json'},
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
      ),
    );

    dio.interceptors.add(ApiKeyInterceptor());
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

  // Services
  getIt.registerLazySingleton<GeocodingService>(
    () => GeocodingService(apiClient: getIt()),
  );

  // Repositories
  getIt.registerLazySingleton<CityRepository>(
    () => CityRepository(geocodingService: getIt()),
  );
}

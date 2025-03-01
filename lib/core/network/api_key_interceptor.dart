import 'package:dio/dio.dart';
import 'package:weather_app/core/config/env_config.dart';

class ApiKeyInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final apiKey = EnvConfig.weatherApiKey;

    options.queryParameters = {'appid': apiKey, ...options.queryParameters};

    handler.next(options);
  }
}

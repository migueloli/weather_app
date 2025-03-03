import 'package:dio/dio.dart';
import 'package:weather_app/core/error/error_handler.dart';
import 'package:weather_app/core/network/api_client.dart';

class DioApiClient implements ApiClient {
  const DioApiClient({required Dio dioClient}) : _dio = dioClient;

  final Dio _dio;

  // GET Request
  @override
  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // POST Request
  @override
  Future<dynamic> post(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PUT Request
  @override
  Future<dynamic> put(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // DELETE Request
  @override
  Future<dynamic> delete(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // PATCH Request
  @override
  Future<dynamic> patch(
    String endpoint, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Map<String, dynamic>? headers,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: Options(headers: headers),
      );

      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling method
  Exception _handleError(dynamic error) {
    return ErrorHandler.handleError(error);
  }
}

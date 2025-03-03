import 'dart:io';

import 'package:dio/dio.dart';
import 'package:weather_app/core/exception/api_exception.dart';
import 'package:weather_app/core/exception/app_exception_type.dart';
import 'package:weather_app/core/exception/network_exception.dart';
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
    Options? options,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
        options: _mergeOptions(headers, options),
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
    Options? options,
  }) async {
    try {
      final response = await _dio.post(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(headers, options),
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
    Options? options,
  }) async {
    try {
      final response = await _dio.put(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(headers, options),
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
    Options? options,
  }) async {
    try {
      final response = await _dio.delete(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(headers, options),
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
    Options? options,
  }) async {
    try {
      final response = await _dio.patch(
        endpoint,
        data: data,
        queryParameters: queryParameters,
        options: _mergeOptions(headers, options),
      );

      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Helper method to merge headers into options
  Options? _mergeOptions(Map<String, dynamic>? headers, Options? options) {
    if (headers == null && options == null) {
      return null;
    }

    final mergedOptions = options ?? Options();
    if (headers != null) {
      mergedOptions.headers = {...?mergedOptions.headers, ...headers};
    }

    return mergedOptions;
  }

  // Error handling method
  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const NetworkException();

        case DioExceptionType.connectionError:
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return const NetworkException();
          }
          return const ApiException(
            statusCode: 0,
            message: 'Unknown error occurred',
            type: AppExceptionType.unknown,
          );

        case DioExceptionType.badCertificate:
        case DioExceptionType.badResponse:
          final response = error.response;
          final statusCode = response?.statusCode ?? 500;
          final message =
              response?.data is Map
                  ? response?.data['message'] ?? 'Server error'
                  : 'Server error';

          return ApiException(
            statusCode: statusCode,
            message: message.toString(),
          );

        case DioExceptionType.cancel:
          return const ApiException(
            statusCode: 0,
            message: 'Request was cancelled',
            type: AppExceptionType.unknown,
          );
      }
    }

    // Fallback for any other type of error
    return ApiException(
      statusCode: 0,
      message: error.toString(),
      type: AppExceptionType.unknown,
    );
  }
}

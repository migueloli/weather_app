import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:weather_app/core/error/api_exception.dart';
import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/error/app_exception_type.dart';
import 'package:weather_app/core/error/network_exception.dart';

abstract class ErrorHandler {
  const ErrorHandler._();

  static AppException handleError(dynamic error, [StackTrace? stackTrace]) {
    _logError(error, stackTrace);

    if (error is AppException) {
      return error;
    }

    if (error is DioException) {
      return _handleDioError(error);
    }

    if (error is FormatException) {
      return const ApiException(
        statusCode: 0,
        message: 'Invalid data format received',
        type: AppExceptionType.dataFormatting,
      );
    }

    return ApiException(
      statusCode: 0,
      message: error.toString(),
      type: AppExceptionType.unknown,
    );
  }

  static AppException _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
          message:
              'Connection timed out. Please check your internet connection.',
        );

      case DioExceptionType.connectionError:
        return const NetworkException();

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode ?? 500;
        final data = error.response?.data;
        String message = 'Server error';

        if (data is Map<String, dynamic>) {
          message = data['message'] ?? data['error'] ?? message;
        }

        return ApiException(
          statusCode: statusCode,
          message: message,
          type: _getExceptionTypeFromStatusCode(statusCode),
        );

      case DioExceptionType.cancel:
        return const ApiException(
          statusCode: 0,
          message: 'Request was cancelled',
          type: AppExceptionType.cancelled,
        );

      default:
        return const ApiException(
          statusCode: 0,
          message: 'An unexpected error occurred',
          type: AppExceptionType.unknown,
        );
    }
  }

  static AppExceptionType _getExceptionTypeFromStatusCode(int statusCode) {
    if (statusCode >= 400 && statusCode < 500) {
      return statusCode == 401 || statusCode == 403
          ? AppExceptionType.authorization
          : AppExceptionType.client;
    }
    return AppExceptionType.serverError;
  }

  static void _logError(dynamic error, [StackTrace? stackTrace]) {
    // In a real app, you might want to use a logging service
    // e.g. Crashlytics, Sentry...
    debugPrint('ERROR: $error');
    if (stackTrace != null) {
      debugPrint('STACK TRACE: $stackTrace');
    }
  }
}

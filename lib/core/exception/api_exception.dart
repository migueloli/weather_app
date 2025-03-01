import 'package:weather_app/core/exception/app_exception.dart';
import 'package:weather_app/core/exception/app_exception_type.dart';

class ApiException extends AppException {
  const ApiException({
    required this.statusCode,
    required this.message,
    AppExceptionType type = AppExceptionType.serverError,
  }) : super(type);

  final String message;
  final int statusCode;

  @override
  String toString() => 'ApiException: $statusCode - $message';
}

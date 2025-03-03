import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/error/app_exception_type.dart';

class ApiException extends AppException {
  const ApiException({
    required this.statusCode,
    required super.message,
    super.type = AppExceptionType.serverError,
  });

  final int statusCode;

  @override
  String toString() => 'ApiException($type): $statusCode - $message';
}

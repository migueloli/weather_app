import 'package:weather_app/core/error/app_exception_type.dart';

abstract class AppException implements Exception {
  const AppException({required this.message, required this.type});

  final String message;
  final AppExceptionType type;

  @override
  String toString() => 'AppException($type): $message';
}

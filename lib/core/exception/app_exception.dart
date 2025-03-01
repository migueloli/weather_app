import 'package:weather_app/core/exception/app_exception_type.dart';

abstract class AppException implements Exception {
  const AppException(this.type);

  final AppExceptionType type;

  @override
  String toString() => 'AppException: $type';
}

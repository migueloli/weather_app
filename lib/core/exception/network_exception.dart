import 'package:weather_app/core/exception/app_exception.dart';
import 'package:weather_app/core/exception/app_exception_type.dart';

class NetworkException extends AppException {
  const NetworkException({
    AppExceptionType type = AppExceptionType.networkConnection,
  }) : super(type);

  @override
  String toString() => 'No internet connection available';
}

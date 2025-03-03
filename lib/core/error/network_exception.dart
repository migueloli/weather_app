import 'package:weather_app/core/error/app_exception.dart';
import 'package:weather_app/core/error/app_exception_type.dart';

class NetworkException extends AppException {
  const NetworkException({
    super.message = 'No internet connection available',
    super.type = AppExceptionType.networkConnection,
  });

  @override
  String toString() => 'NetworkException($type): $message';
}

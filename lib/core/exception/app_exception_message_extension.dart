import 'package:weather_app/core/exception/app_exception.dart';
import 'package:weather_app/core/exception/app_exception_type.dart';

extension AppExceptionMessageExtension on AppException {
  String get message => switch (type) {
    AppExceptionType.networkConnection => 'No internet connection available',
    AppExceptionType.serverError =>
      'Something went wrong. Please try again later.',
    AppExceptionType.unknown => 'Something went wrong. Please try again later.',
  };
}

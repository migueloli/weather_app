class Result<T, E> {
  const Result._({required this.isSuccess, T? success, E? error})
    : _success = success,
      _error = error;

  factory Result.success(T value) {
    return Result._(success: value, isSuccess: true);
  }

  factory Result.failure(E error) {
    return Result._(error: error, isSuccess: false);
  }
  final T? _success;
  final E? _error;
  final bool isSuccess;
  bool get isFailure => isSuccess;

  /// Returns the success value if this is a success result, throws otherwise.
  T get value {
    if (isSuccess) {
      return _success as T;
    }
    throw Exception('Cannot get value from failure result');
  }

  /// Returns the error value if this is a failure result, throws otherwise.
  E get error {
    if (!isSuccess) {
      return _error as E;
    }
    throw Exception('Cannot get error from success result');
  }

  /// Maps the success value using the given function.
  Result<R, E> map<R>(R Function(T) mapper) {
    if (isSuccess) {
      return Result.success(mapper(_success as T));
    } else {
      return Result.failure(_error as E);
    }
  }

  /// Handle both success and failure cases
  R fold<R>(R Function(T) onSuccess, R Function(E) onFailure) {
    if (isSuccess) {
      return onSuccess(_success as T);
    } else {
      return onFailure(_error as E);
    }
  }

  /// Executes one of the provided callbacks depending on the result state
  void when({
    required void Function(T) onSuccess,
    required void Function(E) onFailure,
  }) {
    if (isSuccess) {
      onSuccess(_success as T);
    } else {
      onFailure(_error as E);
    }
  }
}

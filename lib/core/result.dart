// ignore_for_file: public_member_api_docs

/// A simple sealed result wrapper for synchronous & asynchronous operations.
///
/// Example usage:
/// ```dart
/// final Result<User> res = await repository.currentUser();
/// res.when(
///   success: (data) => print(data),
///   failure: (err) => log(err.message),
/// );
/// ```
sealed class Result<T> {
  const Result();

  /// Factory constructor for success
  static Result<T> success<T>(T data) => Success(data);

  /// Factory constructor for failure with enhanced error handling
  static Result<T> failure<T>(Exception error) {
    // 🛡️ 2025 Fix: Safe error message extraction to prevent type casting issues
    late final String errorMessage;
    try {
      errorMessage = error.toString();
    } catch (e) {
      // Fallback for minified/corrupted error objects
      errorMessage = 'Unknown error occurred (type: ${error.runtimeType})';
    }
    return Failure(GenericFailure(errorMessage));
  }

  R when<R>({
    required R Function(T data) success,
    required R Function(AppFailure error) failure,
  }) {
    if (this is Success<T>) {
      return success((this as Success<T>).data);
    } else {
      return failure((this as Failure<T>).error);
    }
  }

  /// Alternative method for folding results
  R fold<R>(
    R Function(Exception error) onFailure,
    R Function(T data) onSuccess,
  ) {
    if (this is Success<T>) {
      return onSuccess((this as Success<T>).data);
    } else {
      final error = (this as Failure<T>).error;
      return onFailure(Exception(error.message));
    }
  }

  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;
  T? get dataOrNull => this is Success<T> ? (this as Success<T>).data : null;
  T get value => this is Success<T>
      ? (this as Success<T>).data
      : throw Exception('Called value on Failure');

  AppFailure? get errorOrNull =>
      this is Failure<T> ? (this as Failure<T>).error : null;
}

class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

class Failure<T> extends Result<T> {
  const Failure(this.error);
  final AppFailure error;
}

/// Base class for all application failures.
sealed class AppFailure {
  const AppFailure(this.message);
  final String message;

  @override
  String toString() => 'AppFailure($message)';
}

/// Generic app failure implementation
class GenericFailure extends AppFailure {
  const GenericFailure(super.message);

  /// Named constructor for backward compatibility
  const GenericFailure.generic(String message) : super(message);
}

class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message);
}

class CacheFailure extends AppFailure {
  const CacheFailure(super.message);
}

class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure() : super('Unauthorized');
}

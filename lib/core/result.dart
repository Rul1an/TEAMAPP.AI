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

  bool get isSuccess => this is Success<T>;
  T? get dataOrNull => this is Success<T> ? (this as Success<T>).data : null;
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

class NetworkFailure extends AppFailure {
  const NetworkFailure(super.message);
}

class CacheFailure extends AppFailure {
  const CacheFailure(super.message);
}

class UnauthorizedFailure extends AppFailure {
  const UnauthorizedFailure() : super('Unauthorized');
}

class PlaylistGenerationFailure extends AppFailure {
  const PlaylistGenerationFailure(super.message);
}

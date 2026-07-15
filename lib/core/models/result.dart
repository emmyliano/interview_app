sealed class Result<T> {}

class Success<T> implements Result<T> {
  const Success(this.value);

  final T value;
}

class Failure<T> implements Result<T> {
  const Failure(this.message);

  final String message;
}

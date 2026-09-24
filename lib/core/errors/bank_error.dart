sealed class BankError implements Exception {
  const BankError({
    required this.message,
  });

  final String message;
}

final class NetworkError extends BankError {
  const NetworkError({
    super.message = 'Unable to connect. Please check your internet connection.',
  });
}

final class AuthenticationError extends BankError {
  const AuthenticationError({
    super.message = 'Your session has expired. Please log in again.',
  });
}

final class ValidationError extends BankError {
  const ValidationError({
    required super.message,
  });
}

final class ServerError extends BankError {
  const ServerError({
    super.message = 'Something went wrong on the server. Please try again.',
  });
}

final class UnknownError extends BankError {
  const UnknownError({
    super.message = 'Something went wrong. Please try again.',
  });
}
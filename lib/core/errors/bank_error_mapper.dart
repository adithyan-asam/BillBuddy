import 'package:dio/dio.dart';

import 'bank_error.dart';

class BankErrorMapper {
  const BankErrorMapper();

  BankError map(
    Object error, {
    String? requestPath,
  }) {
    if (error is DioException) {
      return _mapDioException(
        error,
        requestPath: requestPath,
      );
    }

    if (error is BankError) {
      return error;
    }

    return const UnknownError();
  }

  BankError _mapDioException(
    DioException error, {
    String? requestPath,
  }) {
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.connectionError) {
      return const NetworkError();
    }

    final statusCode = error.response?.statusCode;

    if (statusCode == 401) {
      if (requestPath == '/auth/login') {
        return const ValidationError(
          message: 'Invalid email or password.',
        );
      }

      return const AuthenticationError();
    }

    if (statusCode == 400 || statusCode == 422) {
      final message = _extractMessage(error);

      return ValidationError(
        message: message ?? 'Please check the information you entered.',
      );
    }

    if (statusCode != null && statusCode >= 500) {
      return const ServerError();
    }

    return const UnknownError();
  }

  String? _extractMessage(DioException error) {
    final data = error.response?.data;

    if (data is Map) {
      final message = data['message'];

      if (message is String && message.isNotEmpty) {
        return message;
      }
    }

    return null;
  }
}
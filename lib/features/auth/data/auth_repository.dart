import 'package:dio/dio.dart';

import 'package:billbuddy/core/errors/bank_error.dart';
import 'package:billbuddy/core/errors/bank_error_mapper.dart';
import 'package:billbuddy/core/network/dio_client.dart';
import 'package:billbuddy/features/auth/domain/session.dart';
import 'package:billbuddy/features/auth/domain/user.dart';

class AuthRepository {
  AuthRepository(this._dioClient);

  final DioClient _dioClient;
  final BankErrorMapper _errorMapper = const BankErrorMapper();

  Future<Session> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final data = response.data['data'] as Map<String, Object?>;

      return Session.fromJson(data);
    } on DioException catch (error) {
      throw _errorMapper.map(error, requestPath: '/auth/login');
    }
  }

  Future<Session> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dioClient.dio.post(
        '/auth/signup',
        data: {'name': name, 'email': email, 'password': password},
      );

      final data = response.data['data'] as Map<String, Object?>;

      return Session.fromJson(data);
    } on DioException catch (error) {
      throw _errorMapper.map(error, requestPath: '/auth/signup');
    }
  }

  Future<User> getCurrentUser() async {
    try {
      final response = await _dioClient.dio.get('/auth/me');

      final data = response.data['data'] as Map<String, Object?>;

      return User.fromJson(data['user'] as Map<String, Object?>);
    } on DioException catch (error) {
      throw _errorMapper.map(error, requestPath: '/auth/me');
    }
  }

  Future<void> logout() async {
    // JWT logout is handled locally for now.
  }
}

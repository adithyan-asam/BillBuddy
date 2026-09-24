import 'package:dio/dio.dart';
import 'package:billbuddy/core/network/auth_interceptor.dart';
import 'package:billbuddy/core/security/secure_storage.dart';

class DioClient {
  DioClient(this._storage) {
    dio.interceptors.add(
      AuthInterceptor(_storage),
    );
  }

  final SecureStorage _storage;
  
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.84.115.228:5000/api',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  );
}
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:billbuddy/features/auth/domain/session.dart';
import 'package:billbuddy/features/auth/domain/user.dart';

class SecureStorage {
  SecureStorage();

  final FlutterSecureStorage _storage =
      const FlutterSecureStorage();

  static const _userKey = 'auth_user';
  static const _tokenKey = 'auth_token';

  Future<void> saveSession(Session session) async {
    final userJson = jsonEncode({
      'id': session.user.id,
      'name': session.user.name,
      'email': session.user.email,
    });

    await _storage.write(
      key: _userKey,
      value: userJson,
    );

    await _storage.write(
      key: _tokenKey,
      value: session.token,
    );
  }

  Future<User?> readUser() async {
    final json = await _storage.read(
      key: _userKey,
    );

    if (json == null) {
      return null;
    }

    final data =
        jsonDecode(json) as Map<String, Object?>;

    return User.fromJson(data);
  }

  Future<String?> readToken() async {
    return _storage.read(
      key: _tokenKey,
    );
  }

  Future<void> deleteSession() async {
    await _storage.delete(key: _userKey);
    await _storage.delete(key: _tokenKey);
  }
}
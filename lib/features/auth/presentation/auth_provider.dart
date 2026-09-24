import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:billbuddy/core/network/dio_client.dart';
import 'package:billbuddy/core/security/secure_storage.dart';
import 'package:billbuddy/features/auth/data/auth_repository.dart';
import 'package:billbuddy/features/auth/domain/user.dart';
import 'package:billbuddy/core/errors/bank_error.dart';

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

final dioClientProvider = Provider<DioClient>((ref) {
  final storage = ref.read(secureStorageProvider);

  return DioClient(storage);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dioClient = ref.read(dioClientProvider);

  return AuthRepository(dioClient);
});

class AuthNotifier extends AsyncNotifier<User?> {
  @override
  Future<User?> build() async {
    final storage = ref.read(secureStorageProvider);
    final repository = ref.read(authRepositoryProvider);

    final token = await storage.readToken();

    if (token == null) {
      return null;
    }

    try {
      return await repository.getCurrentUser();
    } catch (error) {
      if (error is AuthenticationError) {
        await storage.deleteSession();
        return null;
      }

      rethrow;
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(authRepositoryProvider);
      final storage = ref.read(secureStorageProvider);

      final session = await repository.login(email: email, password: password);

      await storage.saveSession(session);

      state = AsyncData(session.user);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();

    try {
      final repository = ref.read(authRepositoryProvider);
      final storage = ref.read(secureStorageProvider);

      final session = await repository.signup(
        name: name,
        email: email,
        password: password,
      );

      await storage.saveSession(session);

      state = AsyncData(session.user);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }

  Future<void> logout() async {
    state = const AsyncLoading();

    try {
      final storage = ref.read(secureStorageProvider);

      await storage.deleteSession();

      state = const AsyncData(null);
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
    }
  }
}

final authProvider = AsyncNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);

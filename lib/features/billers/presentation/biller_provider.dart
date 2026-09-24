import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:billbuddy/features/auth/presentation/auth_provider.dart';
import 'package:billbuddy/features/billers/data/biller_repository.dart';
import 'package:billbuddy/features/billers/domain/biller.dart';

final billerRepositoryProvider = Provider<BillerRepository>((ref) {
  final dioClient = ref.read(dioClientProvider);

  return BillerRepository(dioClient);
});

final billersProvider =
    FutureProvider<List<Biller>>((ref) async {
  final repository = ref.read(billerRepositoryProvider);

  return repository.getBillers();
});
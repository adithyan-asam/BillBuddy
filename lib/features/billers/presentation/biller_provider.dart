import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:billbuddy/features/billers/data/biller_repository.dart';
import 'package:billbuddy/features/billers/domain/biller.dart';

final billerRepositoryProvider = Provider<BillerRepository>((ref) {
  return BillerRepository();
});

final billersProvider =
    FutureProvider<List<Biller>>((ref) async {
  final repository = ref.read(billerRepositoryProvider);

  return repository.getBillers();
});
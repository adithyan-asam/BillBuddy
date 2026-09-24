import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:billbuddy/features/billers/data/bill_repository.dart';
import 'package:billbuddy/features/billers/domain/bill.dart';

final billRepositoryProvider = Provider<BillRepository>((ref) {
  return BillRepository();
});

final billProvider = FutureProvider.family<Bill?, String>(
  (ref, savedBillerId) async {
    final repository = ref.read(
      billRepositoryProvider,
    );

    return repository.fetchBill(
      savedBillerId: savedBillerId,
    );
  },
);
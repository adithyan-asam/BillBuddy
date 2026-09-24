import 'package:billbuddy/features/billers/domain/bill.dart';

class BillRepository {
  Future<Bill?> fetchBill({
    required String savedBillerId,
  }) async {
    // Simulate a network request.
    await Future<void>.delayed(
      const Duration(seconds: 1),
    );

    // Mock bill returned by the server.
    return Bill(
      id: 'bill_001',
      savedBillerId: savedBillerId,
      amount: 1240.00,
      dueDate: DateTime(2026, 9, 28),
      billingPeriod: 'August 2026',
      isDue: true,
    );
  }
}
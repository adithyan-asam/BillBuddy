import 'package:dio/dio.dart';
import 'package:billbuddy/core/errors/bank_error_mapper.dart';
import 'package:billbuddy/core/network/dio_client.dart';
import 'package:billbuddy/features/billers/domain/bill.dart';

class BillRepository {
  BillRepository(this._dioClient);

  final DioClient _dioClient;
  final BankErrorMapper _errorMapper = const BankErrorMapper();

  Future<Bill?> fetchBill({
    required String savedBillerId,
  }) async {
    try {
      final response = await _dioClient.dio.get(
        '/my-billers/$savedBillerId/bill',
      );

      final data = response.data['data'];

      if (data == null) {
        return null;
      }

      final json = data as Map<String, Object?>;

      return Bill(
        id: json['_id'] as String,
        savedBillerId: json['savedBillerId'] as String,
        amount: (json['amount'] as num).toDouble(),
        dueDate: DateTime.parse(
          json['dueDate'] as String,
        ),
        billingPeriod: json['billingPeriod'] as String,
        isDue: json['isDue'] as bool,
      );
    } on DioException catch (error) {
      throw _errorMapper.map(
        error,
        requestPath: '/my-billers/$savedBillerId/bill',
      );
    }
  }
}
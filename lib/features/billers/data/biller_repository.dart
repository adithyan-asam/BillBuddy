import 'package:dio/dio.dart';

import 'package:billbuddy/core/errors/bank_error_mapper.dart';
import 'package:billbuddy/core/network/dio_client.dart';
import 'package:billbuddy/features/billers/domain/biller.dart';

class BillerRepository {
  BillerRepository(this._dioClient);

  final DioClient _dioClient;
  final BankErrorMapper _errorMapper =
      const BankErrorMapper();

  Future<List<Biller>> getBillers() async {
    try {
      final response = await _dioClient.dio.get(
        '/billers',
      );

      final data = response.data['data'] as List<Object?>;

      return data
          .map(
            (biller) => Biller.fromJson(
              biller as Map<String, Object?>,
            ),
          )
          .toList();
    } on DioException catch (error) {
      throw _errorMapper.map(
        error,
        requestPath: '/billers',
      );
    }
  }
}
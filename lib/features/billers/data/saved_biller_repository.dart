import 'package:dio/dio.dart';
import 'package:billbuddy/core/errors/bank_error_mapper.dart';
import 'package:billbuddy/core/network/dio_client.dart';
import 'package:billbuddy/features/billers/domain/saved_biller.dart';

class SavedBillerRepository {
  SavedBillerRepository(this._dioClient);

  final DioClient _dioClient;
  final BankErrorMapper _errorMapper = const BankErrorMapper();

  Future<List<SavedBiller>> getSavedBillers() async {
    try {
      final response = await _dioClient.dio.get('/my-billers');

      final data = response.data['data'] as List<Object?>;

      return data.map((item) {
        final json = item as Map<String, Object?>;

        return SavedBiller(
          id: json['_id'] as String,
          billerId: json['billerId'] as String,
          nickname: json['nickname'] as String,
          fields: Map<String, String>.from(
            json['fields'] as Map,
          ),
        );
      }).toList();
    } on DioException catch (error) {
      throw _errorMapper.map(
        error,
        requestPath: '/my-billers',
      );
    }
  }

  Future<SavedBiller> addBiller(
    SavedBiller savedBiller,
  ) async {
    try {
      final response = await _dioClient.dio.post(
        '/my-billers',
        data: {
          'billerId': savedBiller.billerId,
          'nickname': savedBiller.nickname,
          'fields': savedBiller.fields,
        },
      );

      final data = response.data['data'] as Map<String, Object?>;

      return SavedBiller(
        id: data['_id'] as String,
        billerId: data['billerId'] as String,
        nickname: data['nickname'] as String,
        fields: Map<String, String>.from(
          data['fields'] as Map,
        ),
      );
    } on DioException catch (error) {
      throw _errorMapper.map(
        error,
        requestPath: '/my-billers',
      );
    }
  }
}
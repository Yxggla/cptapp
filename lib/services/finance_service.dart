import 'package:dio/dio.dart';
import 'package:cptapp/services/dio_client.dart';
import 'package:cptapp/models/finance_request.dart';
import 'package:cptapp/models/finance_item.dart';

class FinanceService {
  final DioClient _dioClient;

  FinanceService(this._dioClient);

  Future<List<FinanceItem>> fetchFinanceData(FinanceRequest request) async {
    try {
      var response = await _dioClient.dio.get(
        '/bill/getBills',
        queryParameters: request.toJson(),
      );

      if (response.statusCode == 200) {
        List<FinanceItem> financeItems = (response.data['data'] as List)
            .map((item) => FinanceItem.fromJson(item))
            .toList();
        return financeItems;
      }
      return [];
    } catch (e) {
      print('获取财务数据异常: $e');
      return [];
    }
  }
}

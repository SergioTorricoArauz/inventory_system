import 'package:inventory_system/core/network/api_client.dart';
import '../models/sale_model.dart';

abstract class ReportsRemoteDataSource {
  Future<List<SaleModel>> getSales();
}

class ReportsRemoteDataSourceImpl implements ReportsRemoteDataSource {
  final ApiClient client;

  ReportsRemoteDataSourceImpl(this.client);

  @override
  Future<List<SaleModel>> getSales() async {
    try {
      print('=== API GET SALES DEBUG ===');
      print('Endpoint: GET /Sales');

      final response = await client.get('/Sales');

      print('Response Data: ${response.data}');
      print('==========================');

      final List data = response.data as List;
      return data.map((e) => SaleModel.fromJson(e)).toList();
    } catch (e) {
      print('Error fetching sales: $e');
      rethrow;
    }
  }
}

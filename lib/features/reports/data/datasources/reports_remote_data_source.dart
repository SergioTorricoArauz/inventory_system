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
      final response = await client.get('/Sales');

      final List data = response.data as List;
      return data.map((e) => SaleModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}

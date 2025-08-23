import 'package:inventory_system/core/network/api_client.dart';
import '../models/scan_model.dart';
import '../models/sale_request_model.dart';

abstract class ScanRemoteDataSource {
  Future<void> addScan(ScanModel scan);
  Future<List<ScanModel>> getScans();
  Future<void> createSale(SaleRequestModel saleRequest);
}

class ScanRemoteDataSourceImpl implements ScanRemoteDataSource {
  final ApiClient client;
  ScanRemoteDataSourceImpl(this.client);

  @override
  Future<void> addScan(ScanModel scan) async {
    await client.post('/Scans', scan.toJson());
  }

  @override
  Future<List<ScanModel>> getScans() async {
    final response = await client.get('/Scans');
    final List data = response.data as List;
    return data.map((e) => ScanModel.fromJson(e)).toList();
  }

  @override
  Future<void> createSale(SaleRequestModel saleRequest) async {
    try {
      print('=== API CREATE SALE DEBUG ===');
      print('Endpoint: POST /Sales');
      print('Request Data: ${saleRequest.toJson()}');

      await client.post('/Sales', saleRequest.toJson());

      print('Sale created successfully');
      print('============================');
    } catch (e) {
      print('Error creating sale: $e');
      rethrow;
    }
  }
}

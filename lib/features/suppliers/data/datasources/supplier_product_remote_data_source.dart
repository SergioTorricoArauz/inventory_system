import '../../../../core/network/api_client.dart';
import '../models/supplier_product_model.dart';

abstract class SupplierProductRemoteDataSource {
  Future<List<SupplierProductModel>> getSupplierProducts(String supplierId);
  Future<SupplierProductModel> getSupplierProduct(
    String supplierId,
    String productId,
  );
  Future<List<SupplierProductModel>> getPreferredSupplierProducts(
    String productId,
  );
  Future<SupplierProductModel> createSupplierProduct(
    SupplierProductModel supplierProduct,
  );
  Future<void> deleteSupplierProduct(String supplierId, String productId);
}

class SupplierProductRemoteDataSourceImpl
    implements SupplierProductRemoteDataSource {
  final ApiClient apiClient;

  SupplierProductRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<SupplierProductModel>> getSupplierProducts(
    String supplierId,
  ) async {
    try {
      final response = await apiClient.get(
        '/SupplierProducts/supplier/$supplierId',
      );
      final List<dynamic> jsonList = response.data as List<dynamic>;
      return jsonList
          .map((json) => SupplierProductModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error fetching supplier products: $e');
    }
  }

  @override
  Future<SupplierProductModel> getSupplierProduct(
    String supplierId,
    String productId,
  ) async {
    try {
      final response = await apiClient.get(
        '/SupplierProducts/supplier/$supplierId/product/$productId',
      );
      return SupplierProductModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error fetching supplier product: $e');
    }
  }

  @override
  Future<List<SupplierProductModel>> getPreferredSupplierProducts(
    String productId,
  ) async {
    try {
      final response = await apiClient.get(
        '/SupplierProducts/product/$productId/preferred',
      );
      final List<dynamic> jsonList = response.data as List<dynamic>;
      return jsonList
          .map((json) => SupplierProductModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Error fetching preferred supplier products: $e');
    }
  }

  @override
  Future<SupplierProductModel> createSupplierProduct(
    SupplierProductModel supplierProduct,
  ) async {
    try {
      final response = await apiClient.post(
        '/SupplierProducts',
        supplierProduct.toJson(),
      );
      return SupplierProductModel.fromJson(response.data);
    } catch (e) {
      throw Exception('Error creating supplier product: $e');
    }
  }

  @override
  Future<void> deleteSupplierProduct(
    String supplierId,
    String productId,
  ) async {
    try {
      await apiClient.delete(
        '/SupplierProducts/supplier/$supplierId/product/$productId',
      );
    } catch (e) {
      throw Exception('Error deleting supplier product: $e');
    }
  }
}

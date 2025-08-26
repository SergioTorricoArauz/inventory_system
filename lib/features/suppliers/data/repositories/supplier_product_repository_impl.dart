import '../../domain/entities/supplier_product.dart';
import '../../domain/repositories/supplier_product_repository.dart';
import '../datasources/supplier_product_remote_data_source.dart';
import '../models/supplier_product_model.dart';

class SupplierProductRepositoryImpl implements SupplierProductRepository {
  final SupplierProductRemoteDataSource remoteDataSource;

  SupplierProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<SupplierProduct>> getSupplierProducts(String supplierId) async {
    try {
      final supplierProducts = await remoteDataSource.getSupplierProducts(
        supplierId,
      );
      return supplierProducts;
    } catch (e) {
      throw Exception('Failed to get supplier products: $e');
    }
  }

  @override
  Future<SupplierProduct> getSupplierProduct(
    String supplierId,
    String productId,
  ) async {
    try {
      final supplierProduct = await remoteDataSource.getSupplierProduct(
        supplierId,
        productId,
      );
      return supplierProduct;
    } catch (e) {
      throw Exception('Failed to get supplier product: $e');
    }
  }

  @override
  Future<List<SupplierProduct>> getPreferredSupplierProducts(
    String productId,
  ) async {
    try {
      final supplierProducts = await remoteDataSource
          .getPreferredSupplierProducts(productId);
      return supplierProducts;
    } catch (e) {
      throw Exception('Failed to get preferred supplier products: $e');
    }
  }

  @override
  Future<SupplierProduct> createSupplierProduct(
    SupplierProduct supplierProduct,
  ) async {
    try {
      final model = SupplierProductModel.fromEntity(supplierProduct);
      final createdSupplierProduct = await remoteDataSource
          .createSupplierProduct(model);
      return createdSupplierProduct;
    } catch (e) {
      throw Exception('Failed to create supplier product: $e');
    }
  }

  @override
  Future<void> deleteSupplierProduct(
    String supplierId,
    String productId,
  ) async {
    try {
      await remoteDataSource.deleteSupplierProduct(supplierId, productId);
    } catch (e) {
      throw Exception('Failed to delete supplier product: $e');
    }
  }
}

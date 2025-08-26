import '../entities/supplier_product.dart';

abstract class SupplierProductRepository {
  Future<List<SupplierProduct>> getSupplierProducts(String supplierId);
  Future<SupplierProduct> getSupplierProduct(
    String supplierId,
    String productId,
  );
  Future<List<SupplierProduct>> getPreferredSupplierProducts(String productId);
  Future<SupplierProduct> createSupplierProduct(
    SupplierProduct supplierProduct,
  );
  Future<void> deleteSupplierProduct(String supplierId, String productId);
}

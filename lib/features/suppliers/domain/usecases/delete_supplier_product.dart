import '../repositories/supplier_product_repository.dart';

class DeleteSupplierProduct {
  final SupplierProductRepository repository;

  DeleteSupplierProduct({required this.repository});

  Future<void> call(String supplierId, String productId) async {
    return await repository.deleteSupplierProduct(supplierId, productId);
  }
}

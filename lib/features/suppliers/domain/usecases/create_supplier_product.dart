import '../entities/supplier_product.dart';
import '../repositories/supplier_product_repository.dart';

class CreateSupplierProduct {
  final SupplierProductRepository repository;

  CreateSupplierProduct({required this.repository});

  Future<SupplierProduct> call(SupplierProduct supplierProduct) async {
    return await repository.createSupplierProduct(supplierProduct);
  }
}

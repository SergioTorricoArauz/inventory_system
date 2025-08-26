import '../entities/supplier_product.dart';
import '../repositories/supplier_product_repository.dart';

class GetSupplierProducts {
  final SupplierProductRepository repository;

  GetSupplierProducts({required this.repository});

  Future<List<SupplierProduct>> call(String supplierId) async {
    return await repository.getSupplierProducts(supplierId);
  }
}

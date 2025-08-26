import '../repositories/supplier_product_repository.dart';

class GetSupplierProductCount {
  final SupplierProductRepository repository;

  GetSupplierProductCount({required this.repository});

  Future<int> call(String supplierId) async {
    return await repository.getSupplierProductCount(supplierId);
  }
}

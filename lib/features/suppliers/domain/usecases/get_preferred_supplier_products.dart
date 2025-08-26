import '../entities/supplier_product.dart';
import '../repositories/supplier_product_repository.dart';

class GetPreferredSupplierProducts {
  final SupplierProductRepository repository;

  GetPreferredSupplierProducts({required this.repository});

  Future<List<SupplierProduct>> call(String productId) async {
    return await repository.getPreferredSupplierProducts(productId);
  }
}

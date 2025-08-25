import '../entities/supplier.dart';
import '../repositories/supplier_repository.dart';

class GetSuppliers {
  final SupplierRepository repository;

  GetSuppliers(this.repository);

  Future<List<Supplier>> call() async {
    return await repository.getSuppliers();
  }
}

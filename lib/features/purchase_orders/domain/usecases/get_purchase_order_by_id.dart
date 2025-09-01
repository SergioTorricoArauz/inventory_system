import '../entities/purchase_order.dart';
import '../repositories/purchase_order_repository.dart';

class GetPurchaseOrderByIdUseCase {
  final PurchaseOrderRepository repository;

  GetPurchaseOrderByIdUseCase(this.repository);

  Future<PurchaseOrder> call(String id) async {
    return await repository.getPurchaseOrderById(id);
  }
}

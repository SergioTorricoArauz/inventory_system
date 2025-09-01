import '../entities/purchase_order.dart';
import '../repositories/purchase_order_repository.dart';

class UpdatePurchaseOrderUseCase {
  final PurchaseOrderRepository repository;

  UpdatePurchaseOrderUseCase(this.repository);

  Future<PurchaseOrder> call(
    String id,
    PurchaseOrderStatus status,
    String notes,
  ) async {
    return await repository.updatePurchaseOrderStatus(id, status, notes);
  }
}

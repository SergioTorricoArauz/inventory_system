import '../entities/purchase_order.dart';
import '../repositories/purchase_order_repository.dart';

class CancelPurchaseOrderUseCase {
  final PurchaseOrderRepository repository;

  CancelPurchaseOrderUseCase(this.repository);

  Future<PurchaseOrder> call(String id) async {
    return await repository.updatePurchaseOrderStatus(
      id,
      PurchaseOrderStatus.cancelled,
      'Orden cancelada por el usuario',
    );
  }
}

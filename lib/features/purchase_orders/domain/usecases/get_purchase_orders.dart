import '../entities/purchase_order.dart';
import '../repositories/purchase_order_repository.dart';

class GetPurchaseOrdersUseCase {
  final PurchaseOrderRepository repository;

  GetPurchaseOrdersUseCase(this.repository);

  Future<List<PurchaseOrder>> call({PurchaseOrderStatus? status}) async {
    return await repository.getPurchaseOrders(status: status);
  }
}

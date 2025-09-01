import '../entities/purchase_order.dart';
import '../repositories/purchase_order_repository.dart';

class CreatePurchaseOrderUseCase {
  final PurchaseOrderRepository repository;

  CreatePurchaseOrderUseCase(this.repository);

  Future<PurchaseOrder> call(PurchaseOrder purchaseOrder) async {
    // Este método necesitaría ser implementado en el repositorio
    throw UnimplementedError(
      'CreatePurchaseOrder no implementado en el repositorio',
    );
  }
}

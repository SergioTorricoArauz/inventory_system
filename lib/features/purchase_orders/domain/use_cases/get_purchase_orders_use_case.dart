import '../entities/purchase_order.dart';
import '../repositories/purchase_order_repository.dart';

class GetPurchaseOrdersUseCase {
  final PurchaseOrderRepository repository;

  GetPurchaseOrdersUseCase(this.repository);

  Future<List<PurchaseOrder>> call({
    PurchaseOrderStatus? status,
    String? searchQuery,
  }) async {
    final orders = await repository.getPurchaseOrders(status: status);

    if (searchQuery == null || searchQuery.isEmpty) {
      return orders;
    }

    // Filtrar por término de búsqueda
    return orders
        .where(
          (order) =>
              order.id.toLowerCase().contains(searchQuery.toLowerCase()) ||
              order.supplierName.toLowerCase().contains(
                searchQuery.toLowerCase(),
              ),
        )
        .toList();
  }
}

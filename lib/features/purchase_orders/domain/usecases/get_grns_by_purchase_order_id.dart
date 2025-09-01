import '../entities/good_receipt_note.dart';
import '../repositories/purchase_order_repository.dart';

class GetGrnsByPurchaseOrderIdUseCase {
  final PurchaseOrderRepository repository;

  GetGrnsByPurchaseOrderIdUseCase(this.repository);

  Future<List<GoodReceiptNote>> call(String purchaseOrderId) async {
    return await repository.getGrnsByPurchaseOrderId(purchaseOrderId);
  }
}

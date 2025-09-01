import '../entities/purchase_order.dart';
import '../entities/good_receipt_note.dart';

abstract class PurchaseOrderRepository {
  Future<List<PurchaseOrder>> getPurchaseOrders({PurchaseOrderStatus? status});
  Future<PurchaseOrder> getPurchaseOrderById(String id);
  Future<PurchaseOrder> updatePurchaseOrderStatus(
    String id,
    PurchaseOrderStatus status,
    String notes,
  );
  Future<List<GoodReceiptNote>> getGrnsByPurchaseOrderId(
    String purchaseOrderId,
  );
  Future<GoodReceiptNote> createGrn(
    String purchaseOrderId,
    GoodReceiptNote grn,
  );
}

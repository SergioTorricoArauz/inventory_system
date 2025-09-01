import '../entities/good_receipt_note.dart';
import '../repositories/purchase_order_repository.dart';

class CreateGrnUseCase {
  final PurchaseOrderRepository repository;

  CreateGrnUseCase(this.repository);

  Future<GoodReceiptNote> call(
    String purchaseOrderId,
    GoodReceiptNote grn,
  ) async {
    return await repository.createGrn(purchaseOrderId, grn);
  }
}

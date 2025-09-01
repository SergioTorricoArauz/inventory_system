import '../entities/good_receipt_note.dart';
import '../repositories/purchase_order_repository.dart';

class CreateGrnUseCase {
  final PurchaseOrderRepository repository;

  CreateGrnUseCase(this.repository);

  Future<GoodReceiptNote> call(GoodReceiptNote grn) async {
    return await repository.createGrn(grn.purchaseOrderId, grn);
  }
}

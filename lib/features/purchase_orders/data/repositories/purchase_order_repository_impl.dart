import '../../domain/entities/purchase_order.dart';
import '../../domain/entities/good_receipt_note.dart';
import '../../domain/repositories/purchase_order_repository.dart';
import '../datasources/purchase_order_remote_data_source.dart';
import '../models/good_receipt_note_model.dart';
import '../models/grn_line_model.dart';

class PurchaseOrderRepositoryImpl implements PurchaseOrderRepository {
  final PurchaseOrderRemoteDataSource remoteDataSource;

  PurchaseOrderRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<PurchaseOrder>> getPurchaseOrders({
    PurchaseOrderStatus? status,
  }) async {
    final models = await remoteDataSource.getPurchaseOrders(
      status: status?.value,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<PurchaseOrder> getPurchaseOrderById(String id) async {
    final model = await remoteDataSource.getPurchaseOrderById(id);
    return model.toEntity();
  }

  @override
  Future<PurchaseOrder> updatePurchaseOrderStatus(
    String id,
    PurchaseOrderStatus status,
    String notes,
  ) async {
    final model = await remoteDataSource.updatePurchaseOrderStatus(
      id,
      status.value,
      notes,
    );
    return model.toEntity();
  }

  @override
  Future<List<GoodReceiptNote>> getGrnsByPurchaseOrderId(
    String purchaseOrderId,
  ) async {
    final models = await remoteDataSource.getGrnsByPurchaseOrderId(
      purchaseOrderId,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<GoodReceiptNote> createGrn(
    String purchaseOrderId,
    GoodReceiptNote grn,
  ) async {
    final grnModel = GoodReceiptNoteModel(
      id: grn.id,
      purchaseOrderId: grn.purchaseOrderId,
      referenceNumber: grn.referenceNumber,
      notes: grn.notes,
      receivedBy: grn.receivedBy,
      receivedAt: grn.receivedAt.toIso8601String(),
      branchId: grn.branchId,
      lines: grn.lines
          .map(
            (line) => GrnLineModel(
              id: line.id,
              grnId: line.grnId,
              purchaseOrderLineId: line.purchaseOrderLineId,
              productId: line.productId,
              productName: line.productName,
              qtyReceived: line.qtyReceived,
              unitCost: line.unitCost,
              currency: line.currency,
            ),
          )
          .toList(),
    );

    final model = await remoteDataSource.createGrn(purchaseOrderId, grnModel);
    return model.toEntity();
  }
}

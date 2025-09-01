import '../models/purchase_order_model.dart';
import '../models/good_receipt_note_model.dart';
import '../../../../core/network/api_client.dart';

abstract class PurchaseOrderRemoteDataSource {
  Future<List<PurchaseOrderModel>> getPurchaseOrders({int? status});
  Future<PurchaseOrderModel> getPurchaseOrderById(String id);
  Future<PurchaseOrderModel> updatePurchaseOrderStatus(
    String id,
    int status,
    String notes,
  );
  Future<List<GoodReceiptNoteModel>> getGrnsByPurchaseOrderId(
    String purchaseOrderId,
  );
  Future<GoodReceiptNoteModel> createGrn(
    String purchaseOrderId,
    GoodReceiptNoteModel grn,
  );
}

class PurchaseOrderRemoteDataSourceImpl
    implements PurchaseOrderRemoteDataSource {
  final ApiClient _apiClient;

  PurchaseOrderRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<PurchaseOrderModel>> getPurchaseOrders({int? status}) async {
    String endpoint = '/PurchaseOrders';

    // Si se especifica un status, usar el endpoint específico
    if (status != null) {
      endpoint = '/PurchaseOrders/status/$status';
    }

    final response = await _apiClient.get(endpoint);

    return (response.data as List)
        .map((json) => PurchaseOrderModel.fromJson(json))
        .toList();
  }

  @override
  Future<PurchaseOrderModel> getPurchaseOrderById(String id) async {
    final response = await _apiClient.get('/PurchaseOrders/$id');
    return PurchaseOrderModel.fromJson(response.data);
  }

  @override
  Future<PurchaseOrderModel> updatePurchaseOrderStatus(
    String id,
    int status,
    String notes,
  ) async {
    final response = await _apiClient.put('/PurchaseOrders/$id/status', {
      'status': status,
      'notes': notes,
    });
    return PurchaseOrderModel.fromJson(response.data);
  }

  @override
  Future<List<GoodReceiptNoteModel>> getGrnsByPurchaseOrderId(
    String purchaseOrderId,
  ) async {
    final response = await _apiClient.get(
      '/GoodsReceipts/purchase-order/$purchaseOrderId',
    );
    return (response.data as List)
        .map((json) => GoodReceiptNoteModel.fromJson(json))
        .toList();
  }

  @override
  Future<GoodReceiptNoteModel> createGrn(
    String purchaseOrderId,
    GoodReceiptNoteModel grn,
  ) async {
    final response = await _apiClient.post(
      '/PurchaseOrders/$purchaseOrderId/grns',
      grn.toJson(),
    );
    return GoodReceiptNoteModel.fromJson(response.data);
  }
}

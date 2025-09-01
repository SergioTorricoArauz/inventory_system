import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/purchase_order.dart';
import '../../domain/entities/good_receipt_note.dart';
import '../../domain/entities/grn_line.dart';
import '../../domain/use_cases/create_grn_use_case.dart';
import '../../domain/usecases/get_grns_by_purchase_order_id.dart';
import 'grn_state.dart';

class GrnCubit extends Cubit<GrnState> {
  final CreateGrnUseCase _createGrnUseCase;
  final GetGrnsByPurchaseOrderIdUseCase _getGrnsByPurchaseOrderId;

  GrnCubit({
    required CreateGrnUseCase createGrnUseCase,
    required GetGrnsByPurchaseOrderIdUseCase getGrnsByPurchaseOrderId,
  }) : _createGrnUseCase = createGrnUseCase,
       _getGrnsByPurchaseOrderId = getGrnsByPurchaseOrderId,
       super(GrnInitial());

  // Cargar lista de GRNs por purchase order ID
  Future<void> loadGrnsByPurchaseOrderId(String purchaseOrderId) async {
    try {
      emit(GrnLoading());

      final grns = await _getGrnsByPurchaseOrderId.call(purchaseOrderId);

      emit(GrnListLoaded(grns));
    } catch (e) {
      emit(GrnError('Error al cargar recepciones: ${e.toString()}'));
    }
  }

  void initializeGrn(PurchaseOrder purchaseOrder) {
    try {
      emit(GrnLoading());

      // Crear GRN inicial con todas las líneas
      final grnLines = purchaseOrder.lines
          .map(
            (line) => GrnLine(
              id: '',
              grnId: '',
              purchaseOrderLineId: line.id,
              productId: line.productId,
              productName: line.productName,
              qtyReceived: 0,
              unitCost: line.unitCost,
              currency: line.currency,
            ),
          )
          .toList();

      final grn = GoodReceiptNote(
        id: '',
        purchaseOrderId: purchaseOrder.id,
        referenceNumber: '',
        notes: '',
        receivedBy: '',
        receivedAt: DateTime.now(),
        branchId: '',
        lines: grnLines,
      );

      emit(GrnInProgress(grn: grn, canSave: false));
    } catch (e) {
      emit(GrnError('Error al inicializar recepción: ${e.toString()}'));
    }
  }

  void updateLineQuantity(String purchaseOrderLineId, int quantity) {
    final currentState = state;
    if (currentState is! GrnInProgress) return;

    try {
      // Actualizar la línea específica
      final updatedLines = currentState.grn.lines.map((line) {
        if (line.purchaseOrderLineId == purchaseOrderLineId) {
          return GrnLine(
            id: line.id,
            grnId: line.grnId,
            purchaseOrderLineId: line.purchaseOrderLineId,
            productId: line.productId,
            productName: line.productName,
            qtyReceived: quantity,
            unitCost: line.unitCost,
            currency: line.currency,
          );
        }
        return line;
      }).toList();

      // Verificar si se puede guardar (al menos una cantidad > 0)
      final canSave = updatedLines.any((line) => line.qtyReceived > 0);

      final updatedGrn = GoodReceiptNote(
        id: currentState.grn.id,
        purchaseOrderId: currentState.grn.purchaseOrderId,
        referenceNumber: currentState.grn.referenceNumber,
        notes: currentState.grn.notes,
        receivedBy: currentState.grn.receivedBy,
        receivedAt: currentState.grn.receivedAt,
        branchId: currentState.grn.branchId,
        lines: updatedLines,
      );

      emit(GrnInProgress(grn: updatedGrn, canSave: canSave));
    } catch (e) {
      emit(GrnError('Error al actualizar cantidad: ${e.toString()}'));
    }
  }

  void updateNotes(String notes) {
    final currentState = state;
    if (currentState is! GrnInProgress) return;

    try {
      final updatedGrn = GoodReceiptNote(
        id: currentState.grn.id,
        purchaseOrderId: currentState.grn.purchaseOrderId,
        referenceNumber: currentState.grn.referenceNumber,
        notes: notes,
        receivedBy: currentState.grn.receivedBy,
        receivedAt: currentState.grn.receivedAt,
        branchId: currentState.grn.branchId,
        lines: currentState.grn.lines,
      );

      emit(GrnInProgress(grn: updatedGrn, canSave: currentState.canSave));
    } catch (e) {
      emit(GrnError('Error al actualizar notas: ${e.toString()}'));
    }
  }

  Future<void> saveGrn() async {
    final currentState = state;
    if (currentState is! GrnInProgress || !currentState.canSave) return;

    try {
      emit(GrnSaving());

      final savedGrn = await _createGrnUseCase.call(currentState.grn);

      emit(GrnSaved(savedGrn));
    } catch (e) {
      emit(GrnError('Error al guardar recepción: ${e.toString()}'));
    }
  }
}

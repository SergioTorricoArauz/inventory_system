import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/good_receipt_note.dart';
import '../../domain/entities/grn_line.dart';
import '../../domain/entities/purchase_order_line.dart';
import '../../domain/usecases/create_grn.dart';
import 'grn_state.dart';

class GrnCubit extends Cubit<GrnState> {
  final CreateGrnUseCase createGrnUseCase;

  GrnCubit({required this.createGrnUseCase}) : super(GrnInitial());

  void startNewReceipt() {
    emit(const GrnInProgress(items: [], referenceNumber: '', notes: ''));
  }

  void addItemToReceipt(PurchaseOrderLine line, int quantity) {
    if (state is GrnInProgress) {
      final currentState = state as GrnInProgress;
      final existingItemIndex = currentState.items.indexWhere(
        (item) => item.line.id == line.id,
      );

      List<GrnReceiptItem> updatedItems;
      if (existingItemIndex >= 0) {
        // Actualizar cantidad existente
        updatedItems = List.from(currentState.items);
        updatedItems[existingItemIndex] = GrnReceiptItem(
          line: line,
          qtyToReceive: quantity,
        );
      } else {
        // Agregar nuevo item
        updatedItems = [
          ...currentState.items,
          GrnReceiptItem(line: line, qtyToReceive: quantity),
        ];
      }

      emit(
        GrnInProgress(
          items: updatedItems,
          referenceNumber: currentState.referenceNumber,
          notes: currentState.notes,
        ),
      );
    }
  }

  void removeItemFromReceipt(String lineId) {
    if (state is GrnInProgress) {
      final currentState = state as GrnInProgress;
      final updatedItems = currentState.items
          .where((item) => item.line.id != lineId)
          .toList();

      emit(
        GrnInProgress(
          items: updatedItems,
          referenceNumber: currentState.referenceNumber,
          notes: currentState.notes,
        ),
      );
    }
  }

  void updateReferenceNumber(String referenceNumber) {
    if (state is GrnInProgress) {
      final currentState = state as GrnInProgress;
      emit(
        GrnInProgress(
          items: currentState.items,
          referenceNumber: referenceNumber,
          notes: currentState.notes,
        ),
      );
    }
  }

  void updateNotes(String notes) {
    if (state is GrnInProgress) {
      final currentState = state as GrnInProgress;
      emit(
        GrnInProgress(
          items: currentState.items,
          referenceNumber: currentState.referenceNumber,
          notes: notes,
        ),
      );
    }
  }

  void clearReceipt() {
    emit(const GrnInProgress(items: [], referenceNumber: '', notes: ''));
  }

  Future<void> confirmReceipt(
    String purchaseOrderId,
    String branchId,
    String receivedBy,
  ) async {
    if (state is GrnInProgress) {
      final currentState = state as GrnInProgress;
      if (currentState.items.isEmpty) {
        emit(const GrnError('No hay productos para recibir'));
        return;
      }

      emit(GrnCreating());

      try {
        final grn = GoodReceiptNote(
          id: '', // Se genera en el backend
          purchaseOrderId: purchaseOrderId,
          referenceNumber: currentState.referenceNumber,
          notes: currentState.notes,
          receivedBy: receivedBy,
          receivedAt: DateTime.now(),
          branchId: branchId,
          lines: currentState.items
              .map(
                (item) => GrnLine(
                  id: '', // Se genera en el backend
                  grnId: '', // Se asigna en el backend
                  purchaseOrderLineId: item.line.id,
                  productId: item.line.productId,
                  productName: item.line.productName,
                  qtyReceived: item.qtyToReceive,
                  unitCost: item.line.unitCost,
                  currency: item.line.currency,
                ),
              )
              .toList(),
        );

        final createdGrn = await createGrnUseCase(purchaseOrderId, grn);
        emit(GrnCreated(createdGrn));
      } catch (e) {
        emit(GrnError(e.toString()));
        // Volver al estado anterior para permitir reintento
        emit(currentState);
      }
    }
  }
}

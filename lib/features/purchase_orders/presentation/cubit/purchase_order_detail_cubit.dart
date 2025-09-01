import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/use_cases/get_purchase_order_by_id_use_case.dart';
import '../../domain/use_cases/cancel_purchase_order_use_case.dart';
import 'purchase_order_detail_state.dart';

class PurchaseOrderDetailCubit extends Cubit<PurchaseOrderDetailState> {
  final GetPurchaseOrderByIdUseCase _getPurchaseOrderById;
  final CancelPurchaseOrderUseCase _cancelPurchaseOrder;

  PurchaseOrderDetailCubit({
    required GetPurchaseOrderByIdUseCase getPurchaseOrderById,
    required CancelPurchaseOrderUseCase cancelPurchaseOrder,
  }) : _getPurchaseOrderById = getPurchaseOrderById,
       _cancelPurchaseOrder = cancelPurchaseOrder,
       super(PurchaseOrderDetailInitial());

  Future<void> loadPurchaseOrder(String id) async {
    try {
      emit(PurchaseOrderDetailLoading());

      final purchaseOrder = await _getPurchaseOrderById.call(id);

      emit(PurchaseOrderDetailLoaded(purchaseOrder));
    } catch (e) {
      emit(PurchaseOrderDetailError('Error al cargar orden: ${e.toString()}'));
    }
  }

  Future<void> cancelPurchaseOrder(String id) async {
    try {
      final currentState = state;
      if (currentState is! PurchaseOrderDetailLoaded) return;

      emit(PurchaseOrderDetailLoading());

      await _cancelPurchaseOrder.call(id);

      // Recargar la orden actualizada
      await loadPurchaseOrder(id);
    } catch (e) {
      emit(
        PurchaseOrderDetailError('Error al cancelar orden: ${e.toString()}'),
      );
    }
  }
}

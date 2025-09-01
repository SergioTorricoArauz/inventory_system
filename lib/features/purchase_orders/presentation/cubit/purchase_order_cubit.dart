import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/purchase_order.dart';
import '../../domain/use_cases/get_purchase_orders_use_case.dart';
import 'purchase_order_state.dart';

class PurchaseOrderCubit extends Cubit<PurchaseOrderState> {
  final GetPurchaseOrdersUseCase _getPurchaseOrders;

  PurchaseOrderCubit({required GetPurchaseOrdersUseCase getPurchaseOrders})
    : _getPurchaseOrders = getPurchaseOrders,
      super(PurchaseOrderInitial());

  Future<void> loadPurchaseOrders({
    PurchaseOrderStatus? status,
    String? searchQuery,
  }) async {
    try {
      emit(PurchaseOrderLoading());

      final purchaseOrders = await _getPurchaseOrders.call(
        status: status,
        searchQuery: searchQuery,
      );

      emit(PurchaseOrderLoaded(purchaseOrders));
    } catch (e) {
      emit(PurchaseOrderError('Error al cargar órdenes: ${e.toString()}'));
    }
  }

  Future<void> refreshPurchaseOrders({
    PurchaseOrderStatus? status,
    String? searchQuery,
  }) async {
    try {
      final purchaseOrders = await _getPurchaseOrders.call(
        status: status,
        searchQuery: searchQuery,
      );

      emit(PurchaseOrderLoaded(purchaseOrders));
    } catch (e) {
      emit(PurchaseOrderError('Error al actualizar órdenes: ${e.toString()}'));
    }
  }
}

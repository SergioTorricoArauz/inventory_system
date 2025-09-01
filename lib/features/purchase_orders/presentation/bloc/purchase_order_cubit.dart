import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/purchase_order.dart';
import '../../domain/usecases/get_purchase_orders.dart';
import '../../domain/usecases/get_purchase_order_by_id.dart';
import 'purchase_order_state.dart';

class PurchaseOrderCubit extends Cubit<PurchaseOrderState> {
  final GetPurchaseOrdersUseCase getPurchaseOrdersUseCase;
  final GetPurchaseOrderByIdUseCase getPurchaseOrderByIdUseCase;

  PurchaseOrderCubit({
    required this.getPurchaseOrdersUseCase,
    required this.getPurchaseOrderByIdUseCase,
  }) : super(PurchaseOrderInitial());

  Future<void> loadPurchaseOrders({PurchaseOrderStatus? status}) async {
    emit(PurchaseOrderLoading());
    try {
      final purchaseOrders = await getPurchaseOrdersUseCase(status: status);
      emit(PurchaseOrderLoaded(purchaseOrders));
    } catch (e) {
      emit(PurchaseOrderError(e.toString()));
    }
  }

  Future<void> refreshPurchaseOrders({PurchaseOrderStatus? status}) async {
    try {
      final purchaseOrders = await getPurchaseOrdersUseCase(status: status);
      emit(PurchaseOrderLoaded(purchaseOrders));
    } catch (e) {
      emit(PurchaseOrderError(e.toString()));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_purchase_order_by_id.dart';
import '../../domain/usecases/get_grns_by_purchase_order_id.dart';
import 'purchase_order_detail_state.dart';

class PurchaseOrderDetailCubit extends Cubit<PurchaseOrderDetailState> {
  final GetPurchaseOrderByIdUseCase getPurchaseOrderByIdUseCase;
  final GetGrnsByPurchaseOrderIdUseCase getGrnsByPurchaseOrderIdUseCase;

  PurchaseOrderDetailCubit({
    required this.getPurchaseOrderByIdUseCase,
    required this.getGrnsByPurchaseOrderIdUseCase,
  }) : super(PurchaseOrderDetailInitial());

  Future<void> loadPurchaseOrderDetail(String id) async {
    emit(PurchaseOrderDetailLoading());
    try {
      final purchaseOrder = await getPurchaseOrderByIdUseCase(id);
      final grns = await getGrnsByPurchaseOrderIdUseCase(id);
      emit(PurchaseOrderDetailLoaded(purchaseOrder, grns));
    } catch (e) {
      emit(PurchaseOrderDetailError(e.toString()));
    }
  }

  Future<void> refreshPurchaseOrderDetail(String id) async {
    try {
      final purchaseOrder = await getPurchaseOrderByIdUseCase(id);
      final grns = await getGrnsByPurchaseOrderIdUseCase(id);
      emit(PurchaseOrderDetailLoaded(purchaseOrder, grns));
    } catch (e) {
      emit(PurchaseOrderDetailError(e.toString()));
    }
  }
}

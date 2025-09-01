import 'package:equatable/equatable.dart';
import '../../domain/entities/purchase_order.dart';
import '../../domain/entities/good_receipt_note.dart';

abstract class PurchaseOrderDetailState extends Equatable {
  const PurchaseOrderDetailState();

  @override
  List<Object> get props => [];
}

class PurchaseOrderDetailInitial extends PurchaseOrderDetailState {}

class PurchaseOrderDetailLoading extends PurchaseOrderDetailState {}

class PurchaseOrderDetailLoaded extends PurchaseOrderDetailState {
  final PurchaseOrder purchaseOrder;
  final List<GoodReceiptNote> grns;

  const PurchaseOrderDetailLoaded(this.purchaseOrder, this.grns);

  @override
  List<Object> get props => [purchaseOrder, grns];
}

class PurchaseOrderDetailError extends PurchaseOrderDetailState {
  final String message;

  const PurchaseOrderDetailError(this.message);

  @override
  List<Object> get props => [message];
}

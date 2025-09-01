import 'package:equatable/equatable.dart';
import '../../domain/entities/purchase_order.dart';

abstract class PurchaseOrderDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PurchaseOrderDetailInitial extends PurchaseOrderDetailState {}

class PurchaseOrderDetailLoading extends PurchaseOrderDetailState {}

class PurchaseOrderDetailLoaded extends PurchaseOrderDetailState {
  final PurchaseOrder purchaseOrder;

  PurchaseOrderDetailLoaded(this.purchaseOrder);

  @override
  List<Object?> get props => [purchaseOrder];
}

class PurchaseOrderDetailError extends PurchaseOrderDetailState {
  final String message;

  PurchaseOrderDetailError(this.message);

  @override
  List<Object?> get props => [message];
}

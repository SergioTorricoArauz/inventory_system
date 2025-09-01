import 'package:equatable/equatable.dart';
import '../../domain/entities/purchase_order.dart';

abstract class PurchaseOrderState extends Equatable {
  const PurchaseOrderState();

  @override
  List<Object> get props => [];
}

class PurchaseOrderInitial extends PurchaseOrderState {}

class PurchaseOrderLoading extends PurchaseOrderState {}

class PurchaseOrderLoaded extends PurchaseOrderState {
  final List<PurchaseOrder> purchaseOrders;

  const PurchaseOrderLoaded(this.purchaseOrders);

  @override
  List<Object> get props => [purchaseOrders];
}

class PurchaseOrderError extends PurchaseOrderState {
  final String message;

  const PurchaseOrderError(this.message);

  @override
  List<Object> get props => [message];
}

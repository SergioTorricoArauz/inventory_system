import 'package:equatable/equatable.dart';
import '../../domain/entities/good_receipt_note.dart';
import '../../domain/entities/purchase_order_line.dart';

abstract class GrnState extends Equatable {
  const GrnState();

  @override
  List<Object> get props => [];
}

class GrnInitial extends GrnState {}

class GrnInProgress extends GrnState {
  final List<GrnReceiptItem> items;
  final String referenceNumber;
  final String notes;

  const GrnInProgress({
    required this.items,
    required this.referenceNumber,
    required this.notes,
  });

  @override
  List<Object> get props => [items, referenceNumber, notes];
}

class GrnCreating extends GrnState {}

class GrnCreated extends GrnState {
  final GoodReceiptNote grn;

  const GrnCreated(this.grn);

  @override
  List<Object> get props => [grn];
}

class GrnError extends GrnState {
  final String message;

  const GrnError(this.message);

  @override
  List<Object> get props => [message];
}

// Clase auxiliar para manejar items en la recepción temporal
class GrnReceiptItem extends Equatable {
  final PurchaseOrderLine line;
  final int qtyToReceive;

  const GrnReceiptItem({required this.line, required this.qtyToReceive});

  @override
  List<Object> get props => [line, qtyToReceive];
}

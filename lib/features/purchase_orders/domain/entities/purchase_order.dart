import 'package:equatable/equatable.dart';
import 'purchase_order_line.dart';

enum PurchaseOrderStatus {
  ordered(1, 'Ordenada'),
  received(2, 'Recibida'),
  cancelled(3, 'Cancelada'),
  finalized(4, 'Finalizada');

  const PurchaseOrderStatus(this.value, this.displayName);
  final int value;
  final String displayName;

  static PurchaseOrderStatus fromValue(int value) {
    return values.firstWhere((status) => status.value == value);
  }
}

class PurchaseOrder extends Equatable {
  final String id;
  final String supplierId;
  final String supplierName;
  final PurchaseOrderStatus status;
  final String statusText;
  final DateTime expectedDate;
  final String notes;
  final double subtotal;
  final double taxes;
  final double total;
  final String createdBy;
  final DateTime createdAt;
  final List<PurchaseOrderLine> lines;

  const PurchaseOrder({
    required this.id,
    required this.supplierId,
    required this.supplierName,
    required this.status,
    required this.statusText,
    required this.expectedDate,
    required this.notes,
    required this.subtotal,
    required this.taxes,
    required this.total,
    required this.createdBy,
    required this.createdAt,
    required this.lines,
  });

  bool get canReceive =>
      status == PurchaseOrderStatus.ordered ||
      status == PurchaseOrderStatus.received;
  bool get isReadOnly =>
      status == PurchaseOrderStatus.cancelled ||
      status == PurchaseOrderStatus.finalized;

  @override
  List<Object?> get props => [
    id,
    supplierId,
    supplierName,
    status,
    statusText,
    expectedDate,
    notes,
    subtotal,
    taxes,
    total,
    createdBy,
    createdAt,
    lines,
  ];
}

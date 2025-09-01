import 'package:equatable/equatable.dart';
import 'grn_line.dart';

class GoodReceiptNote extends Equatable {
  final String id;
  final String purchaseOrderId;
  final String referenceNumber;
  final String notes;
  final String receivedBy;
  final DateTime receivedAt;
  final String branchId;
  final List<GrnLine> lines;

  const GoodReceiptNote({
    required this.id,
    required this.purchaseOrderId,
    required this.referenceNumber,
    required this.notes,
    required this.receivedBy,
    required this.receivedAt,
    required this.branchId,
    required this.lines,
  });

  int get totalUnits =>
      lines.fold<int>(0, (sum, line) => sum + line.qtyReceived);

  @override
  List<Object?> get props => [
    id,
    purchaseOrderId,
    referenceNumber,
    notes,
    receivedBy,
    receivedAt,
    branchId,
    lines,
  ];
}

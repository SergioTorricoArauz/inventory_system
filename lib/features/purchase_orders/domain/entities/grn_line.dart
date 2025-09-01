import 'package:equatable/equatable.dart';

class GrnLine extends Equatable {
  final String id;
  final String grnId;
  final String purchaseOrderLineId;
  final String productId;
  final String productName;
  final int qtyReceived;
  final int unitCost;
  final String currency;

  const GrnLine({
    required this.id,
    required this.grnId,
    required this.purchaseOrderLineId,
    required this.productId,
    required this.productName,
    required this.qtyReceived,
    required this.unitCost,
    required this.currency,
  });

  @override
  List<Object?> get props => [
    id,
    grnId,
    purchaseOrderLineId,
    productId,
    productName,
    qtyReceived,
    unitCost,
    currency,
  ];
}

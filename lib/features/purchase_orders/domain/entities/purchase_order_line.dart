import 'package:equatable/equatable.dart';

enum LineStatus {
  pending('Pendiente'),
  partial('Parcial'),
  complete('Completa');

  const LineStatus(this.displayName);
  final String displayName;
}

class PurchaseOrderLine extends Equatable {
  final String id;
  final String poid;
  final String productId;
  final String productName;
  final String? productBarcode;
  final int qtyOrdered;
  final int unitCost;
  final String currency;
  final int lineTotal;

  const PurchaseOrderLine({
    required this.id,
    required this.poid,
    required this.productId,
    required this.productName,
    this.productBarcode,
    required this.qtyOrdered,
    required this.unitCost,
    required this.currency,
    required this.lineTotal,
  });

  int get qtyReceived {
    // Este valor se calculará desde las recepciones (GRN)
    // Por ahora retornamos 0, pero se debería obtener de la API
    return 0;
  }

  int get qtyPending => qtyOrdered - qtyReceived;

  LineStatus get status {
    if (qtyReceived == 0) return LineStatus.pending;
    if (qtyReceived < qtyOrdered) return LineStatus.partial;
    return LineStatus.complete;
  }

  @override
  List<Object?> get props => [
    id,
    poid,
    productId,
    productName,
    productBarcode,
    qtyOrdered,
    unitCost,
    currency,
    lineTotal,
  ];
}

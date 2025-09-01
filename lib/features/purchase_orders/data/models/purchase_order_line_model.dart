import 'package:equatable/equatable.dart';
import '../../domain/entities/purchase_order_line.dart';

class PurchaseOrderLineModel extends Equatable {
  final String id;
  final String poId;
  final String productId;
  final String? productName;
  final String? productBarcode;
  final int qtyOrdered;
  final int unitCost;
  final String currency;
  final int lineTotal;

  const PurchaseOrderLineModel({
    required this.id,
    required this.poId,
    required this.productId,
    this.productName,
    this.productBarcode,
    required this.qtyOrdered,
    required this.unitCost,
    required this.currency,
    required this.lineTotal,
  });

  factory PurchaseOrderLineModel.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderLineModel(
      id: json['id']?.toString() ?? '',
      poId: json['poId']?.toString() ?? '',
      productId: json['productId']?.toString() ?? '',
      productName: json['productName']?.toString(),
      productBarcode: json['productBarcode']?.toString(),
      qtyOrdered: (json['qtyOrdered'] as num).toInt(),
      unitCost: (json['unitCost'] as num).toInt(),
      currency: json['currency']?.toString() ?? '',
      lineTotal: (json['lineTotal'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'poId': poId,
      'productId': productId,
      'productName': productName,
      'productBarcode': productBarcode,
      'qtyOrdered': qtyOrdered,
      'unitCost': unitCost,
      'currency': currency,
      'lineTotal': lineTotal,
    };
  }

  PurchaseOrderLine toEntity() {
    return PurchaseOrderLine(
      id: id,
      poid: poId,
      productId: productId,
      productName: productName ?? 'Producto sin nombre',
      productBarcode: productBarcode,
      qtyOrdered: qtyOrdered,
      unitCost: unitCost,
      currency: currency,
      lineTotal: lineTotal,
    );
  }

  @override
  List<Object?> get props => [
    id,
    poId,
    productId,
    productName,
    productBarcode,
    qtyOrdered,
    unitCost,
    currency,
    lineTotal,
  ];
}

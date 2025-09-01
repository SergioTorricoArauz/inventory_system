import 'package:equatable/equatable.dart';
import '../../domain/entities/grn_line.dart';

class GrnLineModel extends Equatable {
  final String id;
  final String grnId;
  final String purchaseOrderLineId;
  final String productId;
  final String productName;
  final int qtyReceived;
  final int unitCost;
  final String currency;

  const GrnLineModel({
    required this.id,
    required this.grnId,
    required this.purchaseOrderLineId,
    required this.productId,
    required this.productName,
    required this.qtyReceived,
    required this.unitCost,
    required this.currency,
  });

  factory GrnLineModel.fromJson(Map<String, dynamic> json) {
    return GrnLineModel(
      id: json['id'] as String,
      grnId: json['grnId'] as String,
      purchaseOrderLineId: json['purchaseOrderLineId'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      qtyReceived: json['qtyReceived'] as int,
      unitCost: json['unitCost'] as int,
      currency: json['currency'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'grnId': grnId,
      'purchaseOrderLineId': purchaseOrderLineId,
      'productId': productId,
      'productName': productName,
      'qtyReceived': qtyReceived,
      'unitCost': unitCost,
      'currency': currency,
    };
  }

  GrnLine toEntity() {
    return GrnLine(
      id: id,
      grnId: grnId,
      purchaseOrderLineId: purchaseOrderLineId,
      productId: productId,
      productName: productName,
      qtyReceived: qtyReceived,
      unitCost: unitCost,
      currency: currency,
    );
  }

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

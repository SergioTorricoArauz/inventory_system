import 'package:equatable/equatable.dart';
import '../../domain/entities/sale.dart';

class SaleModel extends Equatable {
  final String id;
  final String saleDate;
  final String clientId;
  final String sellerId;
  final String notes;
  final List<SaleDetailModel> details;

  const SaleModel({
    required this.id,
    required this.saleDate,
    required this.clientId,
    required this.sellerId,
    required this.notes,
    required this.details,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'] ?? '',
      saleDate: json['saleDate'] ?? '',
      clientId: json['clientId'] ?? '',
      sellerId: json['sellerId'] ?? '',
      notes: json['notes'] ?? '',
      details:
          (json['details'] as List<dynamic>?)
              ?.map((detail) => SaleDetailModel.fromJson(detail))
              .toList() ??
          [],
    );
  }

  Sale toEntity() {
    return Sale(
      id: id,
      saleDate: DateTime.tryParse(saleDate) ?? DateTime.now(),
      clientId: clientId,
      sellerId: sellerId,
      notes: notes,
      details: details.map((detail) => detail.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [id, saleDate, clientId, sellerId, notes, details];
}

class SaleDetailModel extends Equatable {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  const SaleDetailModel({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  factory SaleDetailModel.fromJson(Map<String, dynamic> json) {
    return SaleDetailModel(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      subtotal: (json['subtotal'] ?? 0).toDouble(),
    );
  }

  SaleDetail toEntity() {
    return SaleDetail(
      productId: productId,
      productName: productName,
      quantity: quantity,
      unitPrice: unitPrice,
      subtotal: subtotal,
    );
  }

  @override
  List<Object?> get props => [
    productId,
    productName,
    quantity,
    unitPrice,
    subtotal,
  ];
}

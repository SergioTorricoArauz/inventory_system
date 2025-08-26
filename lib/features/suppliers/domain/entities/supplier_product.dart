import 'package:equatable/equatable.dart';

class SupplierProduct extends Equatable {
  final String supplierId;
  final String productId;
  final String supplierSku;
  final double lastCost;
  final String currency;
  final int minOrderQty;
  final int leadTimeDays;
  final bool preferred;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? supplierName;
  final String? productName;
  final String? productBarcode;

  const SupplierProduct({
    required this.supplierId,
    required this.productId,
    required this.supplierSku,
    required this.lastCost,
    required this.currency,
    required this.minOrderQty,
    required this.leadTimeDays,
    required this.preferred,
    required this.createdAt,
    required this.updatedAt,
    this.supplierName,
    this.productName,
    this.productBarcode,
  });

  SupplierProduct copyWith({
    String? supplierId,
    String? productId,
    String? supplierSku,
    double? lastCost,
    String? currency,
    int? minOrderQty,
    int? leadTimeDays,
    bool? preferred,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? supplierName,
    String? productName,
    String? productBarcode,
  }) {
    return SupplierProduct(
      supplierId: supplierId ?? this.supplierId,
      productId: productId ?? this.productId,
      supplierSku: supplierSku ?? this.supplierSku,
      lastCost: lastCost ?? this.lastCost,
      currency: currency ?? this.currency,
      minOrderQty: minOrderQty ?? this.minOrderQty,
      leadTimeDays: leadTimeDays ?? this.leadTimeDays,
      preferred: preferred ?? this.preferred,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      supplierName: supplierName ?? this.supplierName,
      productName: productName ?? this.productName,
      productBarcode: productBarcode ?? this.productBarcode,
    );
  }

  @override
  List<Object?> get props => [
    supplierId,
    productId,
    supplierSku,
    lastCost,
    currency,
    minOrderQty,
    leadTimeDays,
    preferred,
    createdAt,
    updatedAt,
    supplierName,
    productName,
    productBarcode,
  ];
}

import '../../domain/entities/supplier_product.dart';

class SupplierProductModel extends SupplierProduct {
  const SupplierProductModel({
    required super.supplierId,
    required super.productId,
    required super.supplierSku,
    required super.lastCost,
    required super.currency,
    required super.minOrderQty,
    required super.leadTimeDays,
    required super.preferred,
    required super.createdAt,
    required super.updatedAt,
    super.supplierName,
    super.productName,
    super.productBarcode,
  });

  factory SupplierProductModel.fromJson(Map<String, dynamic> json) {
    return SupplierProductModel(
      supplierId: json['supplierId'] as String,
      productId: json['productId'] as String,
      supplierSku: json['supplierSku'] as String,
      lastCost: (json['lastCost'] as num).toDouble(),
      currency: json['currency'] as String,
      minOrderQty: json['minOrderQty'] as int,
      leadTimeDays: json['leadTimeDays'] as int,
      preferred: json['preferred'] as bool,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      supplierName: json['supplierName'] as String?,
      productName: json['productName'] as String?,
      productBarcode: json['productBarcode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supplierId': supplierId,
      'productId': productId,
      'supplierSku': supplierSku,
      'lastCost': lastCost,
      'currency': currency,
      'minOrderQty': minOrderQty,
      'leadTimeDays': leadTimeDays,
      'preferred': preferred,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (supplierName != null) 'supplierName': supplierName,
      if (productName != null) 'productName': productName,
      if (productBarcode != null) 'productBarcode': productBarcode,
    };
  }

  factory SupplierProductModel.fromEntity(SupplierProduct entity) {
    return SupplierProductModel(
      supplierId: entity.supplierId,
      productId: entity.productId,
      supplierSku: entity.supplierSku,
      lastCost: entity.lastCost,
      currency: entity.currency,
      minOrderQty: entity.minOrderQty,
      leadTimeDays: entity.leadTimeDays,
      preferred: entity.preferred,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      supplierName: entity.supplierName,
      productName: entity.productName,
      productBarcode: entity.productBarcode,
    );
  }
}

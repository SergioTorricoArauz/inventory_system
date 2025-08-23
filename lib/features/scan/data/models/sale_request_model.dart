import 'package:equatable/equatable.dart';
import '../../domain/entities/sale_item.dart';

class SaleRequestModel extends Equatable {
  final String sellerId;
  final String notes;
  final List<SaleDetailModel> details;

  const SaleRequestModel({
    required this.sellerId,
    required this.notes,
    required this.details,
  });

  factory SaleRequestModel.fromEntity(SaleRequest saleRequest) {
    return SaleRequestModel(
      sellerId: saleRequest.sellerId,
      notes: saleRequest.notes,
      details: saleRequest.details
          .map((item) => SaleDetailModel.fromEntity(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sellerId': sellerId,
      'notes': notes,
      'details': details.map((detail) => detail.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [sellerId, notes, details];
}

class SaleDetailModel extends Equatable {
  final String productId;
  final int quantity;

  const SaleDetailModel({required this.productId, required this.quantity});

  factory SaleDetailModel.fromEntity(SaleItem saleItem) {
    return SaleDetailModel(
      productId: saleItem.productId,
      quantity: saleItem.quantity,
    );
  }

  Map<String, dynamic> toJson() {
    return {'productId': productId, 'quantity': quantity};
  }

  @override
  List<Object?> get props => [productId, quantity];
}

import 'package:equatable/equatable.dart';

class Sale extends Equatable {
  final String id;
  final DateTime saleDate;
  final String clientId;
  final String sellerId;
  final String notes;
  final List<SaleDetail> details;

  const Sale({
    required this.id,
    required this.saleDate,
    required this.clientId,
    required this.sellerId,
    required this.notes,
    required this.details,
  });

  double get totalAmount {
    return details.fold(0.0, (sum, detail) => sum + detail.subtotal);
  }

  int get totalItems {
    return details.fold(0, (sum, detail) => sum + detail.quantity);
  }

  @override
  List<Object?> get props => [id, saleDate, clientId, sellerId, notes, details];
}

class SaleDetail extends Equatable {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;
  final double subtotal;

  const SaleDetail({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });

  @override
  List<Object?> get props => [
    productId,
    productName,
    quantity,
    unitPrice,
    subtotal,
  ];
}

import 'package:equatable/equatable.dart';

class SaleItem extends Equatable {
  final String productId;
  final String productName;
  final int quantity;
  final double unitPrice;

  const SaleItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  double get subtotal => quantity * unitPrice;

  SaleItem copyWith({
    String? productId,
    String? productName,
    int? quantity,
    double? unitPrice,
  }) {
    return SaleItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
    );
  }

  @override
  List<Object?> get props => [productId, productName, quantity, unitPrice];
}

class SaleRequest extends Equatable {
  final String sellerId;
  final String notes;
  final List<SaleItem> details;

  const SaleRequest({
    required this.sellerId,
    required this.notes,
    required this.details,
  });

  double get totalAmount =>
      details.fold(0.0, (sum, item) => sum + item.subtotal);

  @override
  List<Object?> get props => [sellerId, notes, details];
}

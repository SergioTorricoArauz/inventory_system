import 'package:equatable/equatable.dart';

class Product extends Equatable {
  final String id;
  final String barcode;
  final String name;
  final double price;
  final int stockQuantity;
  final String categoryId;

  const Product({
    required this.id,
    required this.barcode,
    required this.name,
    required this.price,
    required this.stockQuantity,
    required this.categoryId,
  });

  @override
  List<Object?> get props => [
    id,
    barcode,
    name,
    price,
    stockQuantity,
    categoryId,
  ];
}

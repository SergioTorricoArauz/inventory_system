import 'package:equatable/equatable.dart';
import '../../domain/entities/product.dart';

class ProductModel extends Equatable {
  final String id;
  final String barcode;
  final String name;
  final double price;
  final int stockQuantity;
  final String categoryId;

  const ProductModel({
    required this.id,
    required this.barcode,
    required this.name,
    required this.price,
    required this.stockQuantity,
    required this.categoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json['id'] ?? '',
    barcode: json['barcode'] ?? '',
    name: json['name'] ?? '',
    price: (json['price'] ?? 0).toDouble(),
    stockQuantity: json['stockQuantity'] ?? 0,
    categoryId:
        json['categoryId'] ?? '', // El backend devuelve 'categoryId' en GET
  );

  Map<String, dynamic> toJson() => {
    'barcode': barcode,
    'name': name,
    'price': price,
    'stockQuantity': stockQuantity,
    'idCategory': categoryId, // El backend espera 'idCategory'
  };

  Product toEntity() => Product(
    id: id,
    barcode: barcode,
    name: name,
    price: price,
    stockQuantity: stockQuantity,
    categoryId: categoryId,
  );

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

import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductByBarcode {
  final ProductRepository repository;

  GetProductByBarcode({required this.repository});

  Future<Product?> call(String barcode) async {
    if (barcode.isEmpty) {
      throw ArgumentError('El código de barras no puede estar vacío');
    }

    try {
      return await repository.getProductByBarcode(barcode);
    } catch (e) {
      rethrow;
    }
  }
}

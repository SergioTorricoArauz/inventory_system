import '../entities/product.dart';
import '../repositories/product_repository.dart';

class CreateProductUseCase {
  final ProductRepository repository;

  CreateProductUseCase(this.repository);

  Future<void> call(Product product) async {
    await repository.createProduct(product);
  }
}

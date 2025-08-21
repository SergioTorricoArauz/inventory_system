import '../entities/product.dart';
import '../repositories/product_repository.dart';

class GetProductByIdUseCase {
  final ProductRepository repository;

  GetProductByIdUseCase(this.repository);

  Future<Product> call(String id) async {
    final product = await repository.getProductById(id);

    return product;
  }
}

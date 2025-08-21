import '../repositories/product_repository.dart';

class DeleteProductUseCase {
  final ProductRepository repository;

  DeleteProductUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteProduct(id);
  }
}

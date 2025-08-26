import '../entities/product.dart';
import '../repositories/product_repository.dart';

class SearchProductsByName {
  final ProductRepository repository;

  SearchProductsByName(this.repository);

  Future<List<Product>> call(String searchTerm) async {
    final allProducts = await repository.getProducts();

    if (searchTerm.trim().isEmpty) {
      return allProducts;
    }

    // Filtrar productos que contengan el término de búsqueda en el nombre
    return allProducts.where((product) {
      return product.name.toLowerCase().contains(searchTerm.toLowerCase());
    }).toList();
  }
}

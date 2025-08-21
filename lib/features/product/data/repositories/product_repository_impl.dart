import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Product>> getProducts() async {
    final models = await remoteDataSource.getProducts();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Product> getProductById(String id) async {
    final model = await remoteDataSource.getProductById(id);
    return model.toEntity();
  }

  @override
  Future<void> createProduct(Product product) async {
    final model = ProductModel(
      id: product.id,
      barcode: product.barcode,
      name: product.name,
      price: product.price,
      stockQuantity: product.stockQuantity,
      categoryId: product.categoryId,
    );
    await remoteDataSource.createProduct(model);
  }

  @override
  Future<void> updateProduct(Product product) async {
    final model = ProductModel(
      id: product.id,
      barcode: product.barcode,
      name: product.name,
      price: product.price,
      stockQuantity: product.stockQuantity,
      categoryId: product.categoryId,
    );
    await remoteDataSource.updateProduct(model);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await remoteDataSource.deleteProduct(id);
  }

  @override
  Future<Product?> getProductByBarcode(String barcode) async {
    final model = await remoteDataSource.getProductByBarcode(barcode);
    return model?.toEntity();
  }
}

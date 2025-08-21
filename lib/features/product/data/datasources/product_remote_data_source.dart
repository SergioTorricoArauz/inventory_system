import 'package:inventory_system/core/network/api_client.dart';
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProductById(String id);
  Future<ProductModel?> getProductByBarcode(String barcode);
  Future<void> createProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final ApiClient client;

  ProductRemoteDataSourceImpl(this.client);

  @override
  Future<List<ProductModel>> getProducts() async {
    final response = await client.get('/Products');
    final List data = response.data as List;
    return data.map((e) => ProductModel.fromJson(e)).toList();
  }

  @override
  Future<ProductModel> getProductById(String id) async {
    final response = await client.get('/Products/$id');

    return ProductModel.fromJson(response.data);
  }

  @override
  Future<ProductModel?> getProductByBarcode(String barcode) async {
    try {
      final response = await client.get('/Scans/barcode/$barcode');

      // Basado en la respuesta de Swagger, el producto está en responseData['product']
      final responseData = response.data;
      if (responseData != null && responseData['product'] != null) {
        return ProductModel.fromJson(responseData['product']);
      }
      return null;
    } catch (e) {
      return null; // Producto no encontrado
    }
  }

  @override
  Future<void> createProduct(ProductModel product) async {
    final jsonData = product.toJson();

    await client.post('/Products', jsonData);
  }

  @override
  Future<void> updateProduct(ProductModel product) async {
    final updateData = {
      'barcode': product.barcode,
      'name': product.name,
      'price': product.price,
      'stockQuantity': product.stockQuantity,
      'categoryId': product.categoryId, // Backend espera 'categoryId'
    };

    await client.put('/Products/${product.id}', updateData);
  }

  @override
  Future<void> deleteProduct(String id) async {
    await client.delete('/Products/$id');
  }
}

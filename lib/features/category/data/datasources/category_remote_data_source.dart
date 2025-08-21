import 'package:inventory_system/core/network/api_client.dart';
import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
  Future<CategoryModel> getCategoryById(String id);
  Future<void> createCategory(CategoryModel category);
  Future<void> updateCategory(CategoryModel category);
  Future<void> deleteCategory(String id);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiClient client;

  CategoryRemoteDataSourceImpl(this.client);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await client.get('/Categories');
    final List data = response.data as List;
    return data.map((e) => CategoryModel.fromJson(e)).toList();
  }

  @override
  Future<CategoryModel> getCategoryById(String id) async {
    final response = await client.get('/Categories/$id');
    return CategoryModel.fromJson(response.data);
  }

  @override
  Future<void> createCategory(CategoryModel category) async {
    await client.post('/Categories', category.toJson());
  }

  @override
  Future<void> updateCategory(CategoryModel category) async {
    final updateData = {
      'name': category.name,
      'description': category.description,
    };
    await client.put('/Categories/${category.id}', updateData);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await client.delete('/Categories/$id');
  }
}

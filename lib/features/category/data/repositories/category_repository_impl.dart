import '../../domain/entities/category.dart';
import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_data_source.dart';
import '../models/category_model.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Category>> getCategories() async {
    final models = await remoteDataSource.getCategories();
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Category> getCategoryById(String id) async {
    final model = await remoteDataSource.getCategoryById(id);
    return model.toEntity();
  }

  @override
  Future<void> createCategory(Category category) async {
    final model = CategoryModel(
      id: category.id,
      name: category.name,
      description: category.description,
    );
    await remoteDataSource.createCategory(model);
  }

  @override
  Future<void> updateCategory(Category category) async {
    final model = CategoryModel(
      id: category.id,
      name: category.name,
      description: category.description,
    );
    await remoteDataSource.updateCategory(model);
  }

  @override
  Future<void> deleteCategory(String id) async {
    await remoteDataSource.deleteCategory(id);
  }
}

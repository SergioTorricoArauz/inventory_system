import '../entities/category.dart';
import '../repositories/category_repository.dart';

class GetCategoryByIdUseCase {
  final CategoryRepository repository;

  GetCategoryByIdUseCase(this.repository);

  Future<Category> call(String id) async {
    return await repository.getCategoryById(id);
  }
}

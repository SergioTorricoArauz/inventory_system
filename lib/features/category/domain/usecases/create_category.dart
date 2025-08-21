import '../entities/category.dart';
import '../repositories/category_repository.dart';

class CreateCategoryUseCase {
  final CategoryRepository repository;

  CreateCategoryUseCase(this.repository);

  Future<void> call(Category category) async {
    await repository.createCategory(category);
  }
}

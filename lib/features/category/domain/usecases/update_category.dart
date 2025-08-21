import '../entities/category.dart';
import '../repositories/category_repository.dart';

class UpdateCategoryUseCase {
  final CategoryRepository repository;

  UpdateCategoryUseCase(this.repository);

  Future<void> call(Category category) async {
    return await repository.updateCategory(category);
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/get_category_by_id.dart';
import '../../domain/usecases/update_category.dart';

part 'category_edit_state.dart';

class CategoryEditCubit extends Cubit<CategoryEditState> {
  final GetCategoryByIdUseCase getCategoryById;
  final UpdateCategoryUseCase updateCategory;

  CategoryEditCubit({
    required this.getCategoryById,
    required this.updateCategory,
  }) : super(CategoryEditInitial());

  Future<void> loadCategory(String id) async {
    emit(CategoryEditLoading());
    try {
      final category = await getCategoryById(id);
      emit(CategoryEditLoaded(category: category));
    } catch (e) {
      emit(CategoryEditError(message: e.toString()));
    }
  }

  Future<void> saveCategory(Category category) async {
    emit(CategoryEditSaving());
    try {
      await updateCategory(category);
      emit(CategoryEditSuccess());
    } catch (e) {
      emit(CategoryEditError(message: e.toString()));
    }
  }

  void resetToLoaded(Category category) {
    emit(CategoryEditLoaded(category: category));
  }
}

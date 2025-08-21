import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/get_categories.dart';
import '../../domain/usecases/delete_category.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final GetCategoriesUseCase getCategories;
  final DeleteCategoryUseCase deleteCategory;

  CategoryCubit({required this.getCategories, required this.deleteCategory})
    : super(CategoryInitial());

  Future<void> loadCategories() async {
    emit(CategoryLoading());
    try {
      final categories = await getCategories();
      emit(CategoryLoaded(categories: categories));
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }

  Future<void> deleteCategoryById(String id) async {
    // Mantener el estado actual mientras se elimina
    final currentState = state;
    if (currentState is CategoryLoaded) {
      emit(
        CategoryDeleting(categories: currentState.categories, deletingId: id),
      );
      try {
        await deleteCategory(id);
        // Recargar la lista después de eliminar
        await loadCategories();
        emit(CategoryDeleteSuccess());
      } catch (e) {
        emit(
          CategoryDeleteError(
            categories: currentState.categories,
            message: e.toString(),
          ),
        );
      }
    }
  }
}

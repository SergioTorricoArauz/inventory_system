import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/category.dart';
import '../../domain/usecases/create_category.dart';

part 'category_create_state.dart';

class CategoryCreateCubit extends Cubit<CategoryCreateState> {
  final CreateCategoryUseCase createCategory;

  CategoryCreateCubit({required this.createCategory})
    : super(CategoryCreateInitial());

  Future<void> createNewCategory({
    required String name,
    required String description,
  }) async {
    emit(CategoryCreateLoading());

    try {
      final category = Category(
        id: '', // El servidor generará el ID
        name: name,
        description: description,
      );

      await createCategory(category);
      emit(CategoryCreateSuccess());
    } catch (e) {
      emit(CategoryCreateError(message: e.toString()));
    }
  }

  void resetState() {
    emit(CategoryCreateInitial());
  }
}

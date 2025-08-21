part of 'category_edit_cubit.dart';

abstract class CategoryEditState extends Equatable {
  const CategoryEditState();
  @override
  List<Object?> get props => [];
}

class CategoryEditInitial extends CategoryEditState {}

class CategoryEditLoading extends CategoryEditState {}

class CategoryEditLoaded extends CategoryEditState {
  final Category category;
  const CategoryEditLoaded({required this.category});

  @override
  List<Object?> get props => [category];
}

class CategoryEditSaving extends CategoryEditState {}

class CategoryEditSuccess extends CategoryEditState {}

class CategoryEditError extends CategoryEditState {
  final String message;
  const CategoryEditError({required this.message});

  @override
  List<Object?> get props => [message];
}

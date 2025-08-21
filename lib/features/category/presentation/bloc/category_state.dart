part of 'category_cubit.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();
  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  const CategoryLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

class CategoryDeleting extends CategoryState {
  final List<Category> categories;
  final String deletingId;
  const CategoryDeleting({required this.categories, required this.deletingId});

  @override
  List<Object?> get props => [categories, deletingId];
}

class CategoryDeleteSuccess extends CategoryState {}

class CategoryDeleteError extends CategoryState {
  final List<Category> categories;
  final String message;
  const CategoryDeleteError({required this.categories, required this.message});

  @override
  List<Object?> get props => [categories, message];
}

class CategoryError extends CategoryState {
  final String message;
  const CategoryError({required this.message});

  @override
  List<Object?> get props => [message];
}

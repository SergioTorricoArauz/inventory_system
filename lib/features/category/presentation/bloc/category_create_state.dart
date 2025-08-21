part of 'category_create_cubit.dart';

abstract class CategoryCreateState extends Equatable {
  const CategoryCreateState();
  @override
  List<Object?> get props => [];
}

class CategoryCreateInitial extends CategoryCreateState {}

class CategoryCreateLoading extends CategoryCreateState {}

class CategoryCreateSuccess extends CategoryCreateState {}

class CategoryCreateError extends CategoryCreateState {
  final String message;
  const CategoryCreateError({required this.message});

  @override
  List<Object?> get props => [message];
}

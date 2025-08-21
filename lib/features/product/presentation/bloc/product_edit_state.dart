part of 'product_edit_cubit.dart';

abstract class ProductEditState extends Equatable {
  const ProductEditState();
  @override
  List<Object?> get props => [];
}

class ProductEditInitial extends ProductEditState {}

class ProductEditLoading extends ProductEditState {}

class ProductEditLoaded extends ProductEditState {
  final Product product;
  const ProductEditLoaded({required this.product});

  @override
  List<Object?> get props => [product];
}

class ProductEditUpdating extends ProductEditState {}

class ProductEditSuccess extends ProductEditState {}

class ProductEditError extends ProductEditState {
  final String message;
  const ProductEditError({required this.message});

  @override
  List<Object?> get props => [message];
}

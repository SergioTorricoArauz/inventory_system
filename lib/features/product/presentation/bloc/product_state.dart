part of 'product_cubit.dart';

abstract class ProductState extends Equatable {
  const ProductState();
  @override
  List<Object?> get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  const ProductLoaded({required this.products});

  @override
  List<Object?> get props => [products];
}

class ProductDeleting extends ProductState {
  final List<Product> products;
  final String deletingId;
  const ProductDeleting({required this.products, required this.deletingId});

  @override
  List<Object?> get props => [products, deletingId];
}

class ProductDeleteSuccess extends ProductState {}

class ProductDeleteError extends ProductState {
  final List<Product> products;
  final String message;
  const ProductDeleteError({required this.products, required this.message});

  @override
  List<Object?> get props => [products, message];
}

class ProductError extends ProductState {
  final String message;
  const ProductError({required this.message});

  @override
  List<Object?> get props => [message];
}

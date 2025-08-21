part of 'product_create_cubit.dart';

abstract class ProductCreateState extends Equatable {
  const ProductCreateState();
  @override
  List<Object?> get props => [];
}

class ProductCreateInitial extends ProductCreateState {}

class ProductCreateLoading extends ProductCreateState {}

class ProductCreateSuccess extends ProductCreateState {}

class ProductCreateError extends ProductCreateState {
  final String message;
  const ProductCreateError({required this.message});

  @override
  List<Object?> get props => [message];
}

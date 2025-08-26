import 'package:equatable/equatable.dart';
import '../../domain/entities/supplier_product.dart';

abstract class SupplierProductState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SupplierProductInitial extends SupplierProductState {}

class SupplierProductLoading extends SupplierProductState {}

class SupplierProductLoaded extends SupplierProductState {
  final List<SupplierProduct> supplierProducts;

  SupplierProductLoaded({required this.supplierProducts});

  @override
  List<Object?> get props => [supplierProducts];
}

class SupplierProductError extends SupplierProductState {
  final String message;

  SupplierProductError({required this.message});

  @override
  List<Object?> get props => [message];
}

class SupplierProductCreated extends SupplierProductState {
  final SupplierProduct supplierProduct;

  SupplierProductCreated({required this.supplierProduct});

  @override
  List<Object?> get props => [supplierProduct];
}

class SupplierProductDeleted extends SupplierProductState {}

class PreferredSupplierProductsLoaded extends SupplierProductState {
  final List<SupplierProduct> preferredSupplierProducts;

  PreferredSupplierProductsLoaded({required this.preferredSupplierProducts});

  @override
  List<Object?> get props => [preferredSupplierProducts];
}

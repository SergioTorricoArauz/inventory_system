import 'package:equatable/equatable.dart';
import '../../domain/entities/supplier.dart';

abstract class SupplierState extends Equatable {
  const SupplierState();

  @override
  List<Object> get props => [];
}

class SupplierInitial extends SupplierState {}

class SupplierLoading extends SupplierState {}

class SupplierError extends SupplierState {
  final String message;

  const SupplierError({required this.message});

  @override
  List<Object> get props => [message];
}

class SuppliersLoaded extends SupplierState {
  final List<Supplier> suppliers;

  const SuppliersLoaded({required this.suppliers});

  @override
  List<Object> get props => [suppliers];
}

class SupplierContactsLoaded extends SupplierState {
  final List<SupplierContact> contacts;

  const SupplierContactsLoaded({required this.contacts});

  @override
  List<Object> get props => [contacts];
}

class SupplierCreated extends SupplierState {
  final Supplier supplier;

  const SupplierCreated({required this.supplier});

  @override
  List<Object> get props => [supplier];
}

class SupplierContactCreated extends SupplierState {
  final SupplierContact contact;

  const SupplierContactCreated({required this.contact});

  @override
  List<Object> get props => [contact];
}

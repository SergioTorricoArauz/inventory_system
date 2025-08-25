import 'package:equatable/equatable.dart';

class Supplier extends Equatable {
  final String id;
  final String name;
  final String nitTaxId;
  final String address;
  final String paymentTerms;
  final String currency;
  final bool isActive;
  final DateTime createdAt;
  final List<SupplierContact> contacts;

  const Supplier({
    required this.id,
    required this.name,
    required this.nitTaxId,
    required this.address,
    required this.paymentTerms,
    required this.currency,
    required this.isActive,
    required this.createdAt,
    required this.contacts,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    nitTaxId,
    address,
    paymentTerms,
    currency,
    isActive,
    createdAt,
    contacts,
  ];
}

class SupplierContact extends Equatable {
  final String id;
  final String supplierId;
  final String name;
  final String email;
  final String phone;
  final String role;

  const SupplierContact({
    required this.id,
    required this.supplierId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });

  @override
  List<Object?> get props => [id, supplierId, name, email, phone, role];
}

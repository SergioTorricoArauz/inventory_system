import 'package:equatable/equatable.dart';
import '../../domain/entities/supplier.dart';

class SupplierModel extends Equatable {
  final String id;
  final String name;
  final String nitTaxId;
  final String address;
  final String paymentTerms;
  final String currency;
  final bool isActive;
  final String createdAt;
  final List<SupplierContactModel> contacts;

  const SupplierModel({
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

  factory SupplierModel.fromJson(Map<String, dynamic> json) {
    return SupplierModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      nitTaxId: json['nitTaxId'] ?? '',
      address: json['address'] ?? '',
      paymentTerms: json['paymentTerms'] ?? '',
      currency: json['currency'] ?? '',
      isActive: json['isActive'] ?? true,
      createdAt: json['createdAt'] ?? '',
      contacts:
          (json['contacts'] as List<dynamic>?)
              ?.map((contact) => SupplierContactModel.fromJson(contact))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nitTaxId': nitTaxId,
      'address': address,
      'paymentTerms': paymentTerms,
      'currency': currency,
      'isActive': isActive,
    };
  }

  Supplier toEntity() {
    return Supplier(
      id: id,
      name: name,
      nitTaxId: nitTaxId,
      address: address,
      paymentTerms: paymentTerms,
      currency: currency,
      isActive: isActive,
      createdAt: DateTime.tryParse(createdAt) ?? DateTime.now(),
      contacts: contacts.map((contact) => contact.toEntity()).toList(),
    );
  }

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

class SupplierContactModel extends Equatable {
  final String id;
  final String supplierId;
  final String name;
  final String email;
  final String phone;
  final String role;

  const SupplierContactModel({
    required this.id,
    required this.supplierId,
    required this.name,
    required this.email,
    required this.phone,
    required this.role,
  });

  factory SupplierContactModel.fromJson(Map<String, dynamic> json) {
    return SupplierContactModel(
      id: json['id'] ?? '',
      supplierId: json['supplierId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'supplierId': supplierId,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role,
    };
  }

  SupplierContact toEntity() {
    return SupplierContact(
      id: id,
      supplierId: supplierId,
      name: name,
      email: email,
      phone: phone,
      role: role,
    );
  }

  @override
  List<Object?> get props => [id, supplierId, name, email, phone, role];
}

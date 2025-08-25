import '../../domain/entities/supplier.dart';
import '../../domain/repositories/supplier_repository.dart';
import '../datasources/supplier_remote_data_source.dart';
import '../models/supplier_model.dart';

class SupplierRepositoryImpl implements SupplierRepository {
  final SupplierRemoteDataSource remoteDataSource;

  SupplierRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Supplier>> getSuppliers() async {
    final supplierModels = await remoteDataSource.getSuppliers();
    return supplierModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Supplier> createSupplier(Supplier supplier) async {
    final supplierModel = SupplierModel(
      id: '',
      name: supplier.name,
      nitTaxId: supplier.nitTaxId,
      address: supplier.address,
      paymentTerms: supplier.paymentTerms,
      currency: supplier.currency,
      isActive: supplier.isActive,
      createdAt: supplier.createdAt.toIso8601String(),
      contacts: [],
    );

    final createdModel = await remoteDataSource.createSupplier(supplierModel);
    return createdModel.toEntity();
  }

  @override
  Future<Supplier> updateSupplier(Supplier supplier) async {
    final supplierModel = SupplierModel(
      id: supplier.id,
      name: supplier.name,
      nitTaxId: supplier.nitTaxId,
      address: supplier.address,
      paymentTerms: supplier.paymentTerms,
      currency: supplier.currency,
      isActive: supplier.isActive,
      createdAt: supplier.createdAt.toIso8601String(),
      contacts: supplier.contacts
          .map(
            (contact) => SupplierContactModel(
              id: contact.id,
              supplierId: contact.supplierId,
              name: contact.name,
              email: contact.email,
              phone: contact.phone,
              role: contact.role,
            ),
          )
          .toList(),
    );

    final updatedModel = await remoteDataSource.updateSupplier(
      supplier.id,
      supplierModel,
    );
    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteSupplier(String id) async {
    await remoteDataSource.deleteSupplier(id);
  }

  @override
  Future<Supplier> getSupplierById(String id) async {
    final supplierModel = await remoteDataSource.getSupplierById(id);
    return supplierModel.toEntity();
  }

  @override
  Future<List<SupplierContact>> getSupplierContacts(String supplierId) async {
    final contactModels = await remoteDataSource.getSupplierContacts(
      supplierId,
    );
    return contactModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<SupplierContact> createSupplierContact(SupplierContact contact) async {
    final contactModel = SupplierContactModel(
      id: '',
      supplierId: contact.supplierId,
      name: contact.name,
      email: contact.email,
      phone: contact.phone,
      role: contact.role,
    );

    final createdModel = await remoteDataSource.createSupplierContact(
      contactModel,
    );
    return createdModel.toEntity();
  }

  @override
  Future<SupplierContact> updateSupplierContact(SupplierContact contact) async {
    final contactModel = SupplierContactModel(
      id: contact.id,
      supplierId: contact.supplierId,
      name: contact.name,
      email: contact.email,
      phone: contact.phone,
      role: contact.role,
    );

    final updatedModel = await remoteDataSource.updateSupplierContact(
      contact.id,
      contactModel,
    );
    return updatedModel.toEntity();
  }

  @override
  Future<void> deleteSupplierContact(String id) async {
    await remoteDataSource.deleteSupplierContact(id);
  }
}

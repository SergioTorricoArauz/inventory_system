import '../entities/supplier.dart';
import '../repositories/supplier_repository.dart';

class ManageSupplierContacts {
  final SupplierRepository repository;

  ManageSupplierContacts(this.repository);

  Future<List<SupplierContact>> getContacts(String supplierId) async {
    return await repository.getSupplierContacts(supplierId);
  }

  Future<SupplierContact> createContact(SupplierContact contact) async {
    return await repository.createSupplierContact(contact);
  }

  Future<SupplierContact> updateContact(SupplierContact contact) async {
    return await repository.updateSupplierContact(contact);
  }

  Future<void> deleteContact(String id) async {
    return await repository.deleteSupplierContact(id);
  }
}

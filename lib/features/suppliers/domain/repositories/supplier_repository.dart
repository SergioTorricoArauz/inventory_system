import '../entities/supplier.dart';

abstract class SupplierRepository {
  Future<List<Supplier>> getSuppliers();
  Future<Supplier> createSupplier(Supplier supplier);
  Future<Supplier> updateSupplier(Supplier supplier);
  Future<void> deleteSupplier(String id);
  Future<Supplier> getSupplierById(String id);

  // Contact management
  Future<List<SupplierContact>> getSupplierContacts(String supplierId);
  Future<SupplierContact> createSupplierContact(SupplierContact contact);
  Future<SupplierContact> updateSupplierContact(SupplierContact contact);
  Future<void> deleteSupplierContact(String id);
}

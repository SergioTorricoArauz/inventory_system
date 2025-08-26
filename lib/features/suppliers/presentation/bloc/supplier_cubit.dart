import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/supplier.dart';
import '../../domain/usecases/get_suppliers.dart';
import '../../domain/usecases/get_supplier_by_id.dart';
import '../../domain/usecases/create_supplier.dart';
import '../../domain/usecases/update_supplier.dart';
import '../../domain/usecases/manage_supplier_contacts.dart';
import 'supplier_state.dart';

class SupplierCubit extends Cubit<SupplierState> {
  final GetSuppliers getSuppliers;
  final GetSupplierById getSupplierById;
  final CreateSupplier createSupplier;
  final UpdateSupplier updateSupplier;
  final ManageSupplierContacts manageContacts;

  SupplierCubit({
    required this.getSuppliers,
    required this.getSupplierById,
    required this.createSupplier,
    required this.updateSupplier,
    required this.manageContacts,
  }) : super(SupplierInitial());

  Future<void> loadSuppliers() async {
    try {
      emit(SupplierLoading());
      final suppliers = await getSuppliers();
      emit(SuppliersLoaded(suppliers: suppliers));
    } catch (e) {
      emit(SupplierError(message: e.toString()));
    }
  }

  Future<void> addSupplier({
    required String name,
    required String nitTaxId,
    required String address,
    required String paymentTerms,
    required String currency,
  }) async {
    try {
      emit(SupplierLoading());
      final supplier = Supplier(
        id: '',
        name: name,
        nitTaxId: nitTaxId,
        address: address,
        paymentTerms: paymentTerms,
        currency: currency,
        isActive: true,
        createdAt: DateTime.now(),
        contacts: [],
      );

      final createdSupplier = await createSupplier(supplier);
      emit(SupplierCreated(supplier: createdSupplier));

      // Reload suppliers after creation
      await loadSuppliers();
    } catch (e) {
      emit(SupplierError(message: e.toString()));
    }
  }

  Future<void> loadSupplierById(String id) async {
    try {
      emit(SupplierLoading());
      final supplier = await getSupplierById(id);
      emit(SupplierDetailLoaded(supplier: supplier));
    } catch (e) {
      emit(SupplierError(message: e.toString()));
    }
  }

  Future<void> editSupplier({
    required String id,
    required String name,
    required String nitTaxId,
    required String address,
    required String paymentTerms,
    required String currency,
    required bool isActive,
  }) async {
    try {
      emit(SupplierLoading());
      final supplier = Supplier(
        id: id,
        name: name,
        nitTaxId: nitTaxId,
        address: address,
        paymentTerms: paymentTerms,
        currency: currency,
        isActive: isActive,
        createdAt: DateTime.now(), // This will be ignored by the API
        contacts: [],
      );

      final updatedSupplier = await updateSupplier(supplier);
      emit(SupplierUpdated(supplier: updatedSupplier));
    } catch (e) {
      emit(SupplierError(message: e.toString()));
    }
  }

  Future<void> loadSupplierContacts(String supplierId) async {
    try {
      emit(SupplierLoading());
      final contacts = await manageContacts.getContacts(supplierId);
      emit(SupplierContactsLoaded(contacts: contacts));
    } catch (e) {
      emit(SupplierError(message: e.toString()));
    }
  }

  Future<void> addSupplierContact({
    required String supplierId,
    required String name,
    required String email,
    required String phone,
    required String role,
  }) async {
    try {
      emit(SupplierLoading());
      final contact = SupplierContact(
        id: '',
        supplierId: supplierId,
        name: name,
        email: email,
        phone: phone,
        role: role,
      );

      final createdContact = await manageContacts.createContact(contact);
      emit(SupplierContactCreated(contact: createdContact));

      // Reload contacts after creation
      await loadSupplierContacts(supplierId);
    } catch (e) {
      emit(SupplierError(message: e.toString()));
    }
  }

  Future<void> deleteSupplierContact(
    String contactId,
    String supplierId,
  ) async {
    try {
      emit(SupplierLoading());
      await manageContacts.deleteContact(contactId);

      // Reload contacts after deletion
      await loadSupplierContacts(supplierId);
    } catch (e) {
      emit(SupplierError(message: e.toString()));
    }
  }
}

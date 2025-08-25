import '../../../../core/network/api_client.dart';
import '../models/supplier_model.dart';

class SupplierRemoteDataSource {
  final ApiClient apiClient;

  SupplierRemoteDataSource(this.apiClient);

  Future<List<SupplierModel>> getSuppliers() async {
    final response = await apiClient.get('/Suppliers');
    final List<dynamic> data = response.data;
    return data.map((supplier) => SupplierModel.fromJson(supplier)).toList();
  }

  Future<SupplierModel> createSupplier(SupplierModel supplier) async {
    final response = await apiClient.post('/Suppliers', supplier.toJson());
    return SupplierModel.fromJson(response.data);
  }

  Future<SupplierModel> updateSupplier(
    String id,
    SupplierModel supplier,
  ) async {
    final response = await apiClient.put('/Suppliers/$id', supplier.toJson());
    return SupplierModel.fromJson(response.data);
  }

  Future<void> deleteSupplier(String id) async {
    await apiClient.delete('/Suppliers/$id');
  }

  Future<SupplierModel> getSupplierById(String id) async {
    final response = await apiClient.get('/Suppliers/$id');
    return SupplierModel.fromJson(response.data);
  }

  // Supplier Contacts
  Future<List<SupplierContactModel>> getSupplierContacts(
    String supplierId,
  ) async {
    final response = await apiClient.get(
      '/SupplierContacts/supplier/$supplierId',
    );
    final List<dynamic> data = response.data;
    return data
        .map((contact) => SupplierContactModel.fromJson(contact))
        .toList();
  }

  Future<SupplierContactModel> createSupplierContact(
    SupplierContactModel contact,
  ) async {
    final response = await apiClient.post(
      '/SupplierContacts',
      contact.toJson(),
    );
    return SupplierContactModel.fromJson(response.data);
  }

  Future<SupplierContactModel> updateSupplierContact(
    String id,
    SupplierContactModel contact,
  ) async {
    final response = await apiClient.put(
      '/SupplierContacts/$id',
      contact.toJson(),
    );
    return SupplierContactModel.fromJson(response.data);
  }

  Future<void> deleteSupplierContact(String id) async {
    await apiClient.delete('/SupplierContacts/$id');
  }
}

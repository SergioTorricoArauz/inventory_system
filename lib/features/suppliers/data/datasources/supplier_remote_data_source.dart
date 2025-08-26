import '../../../../core/network/api_client.dart';
import '../models/supplier_model.dart';

class SupplierRemoteDataSource {
  final ApiClient apiClient;

  SupplierRemoteDataSource(this.apiClient);

  Future<List<SupplierModel>> getSuppliers() async {
    try {
      final response = await apiClient.get('/Suppliers');
      final List<dynamic> data = response.data;
      final suppliers = data
          .map((supplier) => SupplierModel.fromJson(supplier))
          .toList();

      // Obtener el conteo de productos para cada proveedor
      for (var i = 0; i < suppliers.length; i++) {
        try {
          final countResponse = await apiClient.get(
            '/SupplierProducts/supplier/${suppliers[i].id}/count',
          );
          final productCount = countResponse.data['productCount'] ?? 0;
          suppliers[i] = SupplierModel(
            id: suppliers[i].id,
            name: suppliers[i].name,
            nitTaxId: suppliers[i].nitTaxId,
            address: suppliers[i].address,
            paymentTerms: suppliers[i].paymentTerms,
            currency: suppliers[i].currency,
            isActive: suppliers[i].isActive,
            createdAt: suppliers[i].createdAt,
            contacts: suppliers[i].contacts,
            productCount: productCount,
          );
        } catch (e) {
          suppliers[i] = SupplierModel(
            id: suppliers[i].id,
            name: suppliers[i].name,
            nitTaxId: suppliers[i].nitTaxId,
            address: suppliers[i].address,
            paymentTerms: suppliers[i].paymentTerms,
            currency: suppliers[i].currency,
            isActive: suppliers[i].isActive,
            createdAt: suppliers[i].createdAt,
            contacts: suppliers[i].contacts,
            productCount: 0,
          );
        }
      }

      return suppliers;
    } catch (e) {
      throw Exception('Error fetching suppliers: $e');
    }
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

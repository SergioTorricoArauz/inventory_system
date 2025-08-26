import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/supplier_product.dart';
import '../../domain/usecases/get_supplier_products.dart';
import '../../domain/usecases/get_preferred_supplier_products.dart';
import '../../domain/usecases/create_supplier_product.dart';
import '../../domain/usecases/delete_supplier_product.dart';
import 'supplier_product_state.dart';

class SupplierProductCubit extends Cubit<SupplierProductState> {
  final GetSupplierProducts getSupplierProducts;
  final GetPreferredSupplierProducts getPreferredSupplierProducts;
  final CreateSupplierProduct createSupplierProduct;
  final DeleteSupplierProduct deleteSupplierProduct;

  SupplierProductCubit({
    required this.getSupplierProducts,
    required this.getPreferredSupplierProducts,
    required this.createSupplierProduct,
    required this.deleteSupplierProduct,
  }) : super(SupplierProductInitial());

  Future<void> loadSupplierProducts(String supplierId) async {
    try {
      emit(SupplierProductLoading());
      final supplierProducts = await getSupplierProducts(supplierId);
      emit(SupplierProductLoaded(supplierProducts: supplierProducts));
    } catch (e) {
      emit(SupplierProductError(message: e.toString()));
    }
  }

  Future<void> loadPreferredSupplierProducts(String productId) async {
    try {
      emit(SupplierProductLoading());
      final preferredSupplierProducts = await getPreferredSupplierProducts(
        productId,
      );
      emit(
        PreferredSupplierProductsLoaded(
          preferredSupplierProducts: preferredSupplierProducts,
        ),
      );
    } catch (e) {
      emit(SupplierProductError(message: e.toString()));
    }
  }

  Future<void> addSupplierProduct(SupplierProduct supplierProduct) async {
    try {
      emit(SupplierProductLoading());
      final createdSupplierProduct = await createSupplierProduct(
        supplierProduct,
      );
      emit(SupplierProductCreated(supplierProduct: createdSupplierProduct));
    } catch (e) {
      emit(SupplierProductError(message: e.toString()));
    }
  }

  Future<void> removeSupplierProduct(
    String supplierId,
    String productId,
  ) async {
    try {
      emit(SupplierProductLoading());
      await deleteSupplierProduct(supplierId, productId);
      emit(SupplierProductDeleted());
    } catch (e) {
      emit(SupplierProductError(message: e.toString()));
    }
  }
}

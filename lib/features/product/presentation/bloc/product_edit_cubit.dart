import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_product_by_id.dart';
import '../../domain/usecases/update_product.dart';

part 'product_edit_state.dart';

class ProductEditCubit extends Cubit<ProductEditState> {
  final GetProductByIdUseCase getProductById;
  final UpdateProductUseCase updateProduct;

  ProductEditCubit({required this.getProductById, required this.updateProduct})
    : super(ProductEditInitial());

  Future<void> loadProduct(String id) async {
    emit(ProductEditLoading());
    try {
      final product = await getProductById(id);
      emit(ProductEditLoaded(product: product));
    } catch (e) {
      emit(ProductEditError(message: e.toString()));
    }
  }

  Future<void> updateProductInfo({
    required String id,
    required String barcode,
    required String name,
    required double price,
    required int stockQuantity,
    required String categoryId,
  }) async {
    emit(ProductEditUpdating());

    try {
      final product = Product(
        id: id,
        barcode: barcode,
        name: name,
        price: price,
        stockQuantity: stockQuantity,
        categoryId: categoryId,
      );

      await updateProduct(product);
      emit(ProductEditSuccess());
    } catch (e) {
      emit(ProductEditError(message: e.toString()));
    }
  }

  void resetState() {
    emit(ProductEditInitial());
  }
}

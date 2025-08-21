import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/delete_product.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  final GetProductsUseCase getProducts;
  final DeleteProductUseCase deleteProduct;

  ProductCubit({required this.getProducts, required this.deleteProduct})
    : super(ProductInitial());

  Future<void> loadProducts() async {
    emit(ProductLoading());
    try {
      final products = await getProducts();
      emit(ProductLoaded(products: products));
    } catch (e) {
      emit(ProductError(message: e.toString()));
    }
  }

  Future<void> deleteProductById(String id) async {
    final currentState = state;
    if (currentState is ProductLoaded) {
      emit(ProductDeleting(products: currentState.products, deletingId: id));

      try {
        await deleteProduct(id);
        emit(ProductDeleteSuccess());
      } catch (e) {
        emit(
          ProductDeleteError(
            products: currentState.products,
            message: e.toString(),
          ),
        );
      }
    }
  }
}

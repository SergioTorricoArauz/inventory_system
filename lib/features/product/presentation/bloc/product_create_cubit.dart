import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../../domain/usecases/create_product.dart';

part 'product_create_state.dart';

class ProductCreateCubit extends Cubit<ProductCreateState> {
  final CreateProductUseCase createProduct;

  ProductCreateCubit({required this.createProduct})
    : super(ProductCreateInitial());

  Future<void> createNewProduct({
    required String barcode,
    required String name,
    required double price,
    required int stockQuantity,
    required String categoryId,
  }) async {
    emit(ProductCreateLoading());

    try {
      final product = Product(
        id: '', // El servidor generará el ID
        barcode: barcode,
        name: name,
        price: price,
        stockQuantity: stockQuantity,
        categoryId: categoryId,
      );

      await createProduct(product);
      emit(ProductCreateSuccess());
    } catch (e) {
      emit(ProductCreateError(message: e.toString()));
    }
  }

  void resetState() {
    emit(ProductCreateInitial());
  }
}

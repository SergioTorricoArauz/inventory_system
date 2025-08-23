import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/scan.dart';
import '../../domain/entities/sale_item.dart';
import '../../domain/usecases/add_scan.dart';
import '../../domain/usecases/get_scans.dart';
import '../../domain/usecases/create_sale.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/domain/usecases/get_product_by_barcode.dart';

part 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  final AddScanUseCase addScan;
  final GetScansUseCase getScans;
  final GetProductByBarcode getProductByBarcode;
  final CreateSaleUseCase createSale;

  // Lista de productos en la venta actual
  final List<SaleItem> _saleItems = [];

  ScanCubit({
    required this.addScan,
    required this.getScans,
    required this.getProductByBarcode,
    required this.createSale,
  }) : super(ScanInitial());

  Future<void> scanBarcodeForSale(String code) async {
    emit(ScanLoading());
    try {
      // Buscar el producto por código de barras
      final product = await getProductByBarcode(code);

      if (product != null) {
        _addProductToSale(product);
      } else {
        emit(ProductNotFound(barcode: code));
      }
    } catch (e) {
      emit(ScanError(message: e.toString()));
    }
  }

  void _addProductToSale(Product product) {
    // Buscar si el producto ya existe en la lista
    final existingIndex = _saleItems.indexWhere(
      (item) => item.productId == product.id,
    );

    if (existingIndex >= 0) {
      // Si existe, incrementar cantidad
      final existingItem = _saleItems[existingIndex];
      _saleItems[existingIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
      );
    } else {
      // Si no existe, agregarlo con cantidad 1
      _saleItems.add(
        SaleItem(
          productId: product.id,
          productName: product.name,
          quantity: 1,
          unitPrice: product.price,
        ),
      );
    }

    _emitSaleState();
  }

  void updateItemQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItem(productId);
      return;
    }

    final index = _saleItems.indexWhere((item) => item.productId == productId);
    if (index >= 0) {
      _saleItems[index] = _saleItems[index].copyWith(quantity: newQuantity);
      _emitSaleState();
    }
  }

  void removeItem(String productId) {
    _saleItems.removeWhere((item) => item.productId == productId);
    _emitSaleState();
  }

  void clearSale() {
    _saleItems.clear();
    emit(ScanInitial());
  }

  Future<void> completeSale() async {
    if (_saleItems.isEmpty) {
      emit(const ScanError(message: 'No hay productos en la venta'));
      return;
    }

    emit(ScanLoading());
    try {
      final saleRequest = SaleRequest(
        sellerId: '3fa85f64-5717-4562-b3fc-2c963f66afa6', // ID por defecto
        notes: 'Venta Exitosa', // Nota por defecto
        details: List.from(_saleItems),
      );

      await createSale(saleRequest);
      _saleItems.clear();
      emit(SaleCompleted());
    } catch (e) {
      emit(ScanError(message: e.toString()));
    }
  }

  void _emitSaleState() {
    final totalAmount = _saleItems.fold(
      0.0,
      (sum, item) => sum + item.subtotal,
    );
    emit(SaleLoaded(items: List.from(_saleItems), totalAmount: totalAmount));
  }

  // Métodos existentes para compatibilidad
  Future<void> scanBarcode(String code) async {
    return scanBarcodeForSale(code);
  }

  Future<void> loadHistory() async {
    emit(ScanLoading());
    try {
      final list = await getScans();
      emit(ScanHistoryLoaded(scans: list));
    } catch (e) {
      emit(ScanError(message: e.toString()));
    }
  }
}

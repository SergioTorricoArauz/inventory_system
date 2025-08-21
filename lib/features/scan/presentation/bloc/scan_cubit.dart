import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/scan.dart';
import '../../domain/usecases/add_scan.dart';
import '../../domain/usecases/get_scans.dart';
import '../../../product/domain/entities/product.dart';
import '../../../product/domain/usecases/get_product_by_barcode.dart';

part 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  final AddScanUseCase addScan;
  final GetScansUseCase getScans;
  final GetProductByBarcode getProductByBarcode;

  ScanCubit({
    required this.addScan,
    required this.getScans,
    required this.getProductByBarcode,
  }) : super(ScanInitial());

  Future<void> scanBarcode(String code) async {
    emit(ScanLoading());
    try {
      // Buscar el producto por código de barras
      final product = await getProductByBarcode(code);

      if (product != null) {
        emit(ProductFound(product: product));
      } else {
        emit(ProductNotFound(barcode: code));
      }
    } catch (e) {
      emit(ScanError(message: e.toString()));
    }
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

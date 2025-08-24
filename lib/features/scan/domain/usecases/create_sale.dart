import '../entities/sale_item.dart';
import '../repositories/scan_repository.dart';

class CreateSaleUseCase {
  final ScanRepository repository;

  CreateSaleUseCase({required this.repository});

  Future<void> call(SaleRequest saleRequest) async {
    if (saleRequest.details.isEmpty) {
      throw ArgumentError('La venta debe tener al menos un producto');
    }

    try {
      await repository.createSale(saleRequest);
    } catch (e) {
      rethrow;
    }
  }
}

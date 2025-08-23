import '../entities/scan.dart';
import '../entities/sale_item.dart';

abstract class ScanRepository {
  Future<void> addScan(Scan scan);
  Future<List<Scan>> getScans();
  Future<void> createSale(SaleRequest saleRequest);
}

import '../entities/sale.dart';

abstract class ReportsRepository {
  Future<List<Sale>> getSales();
}

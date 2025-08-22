import '../entities/sale.dart';
import '../repositories/reports_repository.dart';

class GetSalesReportUseCase {
  final ReportsRepository repository;

  GetSalesReportUseCase({required this.repository});

  Future<List<Sale>> call() async {
    try {
      return await repository.getSales();
    } catch (e) {
      rethrow;
    }
  }
}

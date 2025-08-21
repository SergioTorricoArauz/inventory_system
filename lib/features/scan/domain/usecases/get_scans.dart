import '../entities/scan.dart';
import '../repositories/scan_repository.dart';

class GetScansUseCase {
  final ScanRepository repository;
  GetScansUseCase(this.repository);

  Future<List<Scan>> call() async {
    return await repository.getScans();
  }
}

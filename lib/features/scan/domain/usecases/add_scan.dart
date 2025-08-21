import '../entities/scan.dart';
import '../repositories/scan_repository.dart';

class AddScanUseCase {
  final ScanRepository repository;
  AddScanUseCase(this.repository);

  Future<void> call(Scan scan) async {
    await repository.addScan(scan);
  }
}

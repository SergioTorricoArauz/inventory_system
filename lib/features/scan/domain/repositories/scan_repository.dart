import '../entities/scan.dart';

abstract class ScanRepository {
  Future<void> addScan(Scan scan);
  Future<List<Scan>> getScans();
}

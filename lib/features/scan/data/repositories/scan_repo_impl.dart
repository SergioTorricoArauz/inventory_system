import 'package:inventory_system/features/scan/domain/entities/scan.dart';
import 'package:inventory_system/features/scan/domain/repositories/scan_repository.dart';
import '../datasources/scan_remote_data_source.dart';
import '../models/scan_model.dart';

class ScanRepositoryImpl implements ScanRepository {
  final ScanRemoteDataSource remoteDataSource;
  ScanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addScan(Scan scan) async {
    final model = ScanModel(barcode: scan.barcode, scanDate: scan.scanDate);
    await remoteDataSource.addScan(model);
  }

  @override
  Future<List<Scan>> getScans() async {
    final models = await remoteDataSource.getScans();
    return models
        .map((m) => Scan(barcode: m.barcode, scanDate: m.scanDate))
        .toList();
  }
}

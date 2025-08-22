import '../../domain/entities/sale.dart';
import '../../domain/repositories/reports_repository.dart';
import '../datasources/reports_remote_data_source.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  final ReportsRemoteDataSource remoteDataSource;

  ReportsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Sale>> getSales() async {
    final models = await remoteDataSource.getSales();
    return models.map((model) => model.toEntity()).toList();
  }
}

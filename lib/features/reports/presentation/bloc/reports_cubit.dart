import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/sale.dart';
import '../../domain/usecases/get_sales_report.dart';

part 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  final GetSalesReportUseCase getSalesReport;

  ReportsCubit({required this.getSalesReport}) : super(ReportsInitial());

  Future<void> loadSalesReport() async {
    emit(ReportsLoading());
    try {
      final sales = await getSalesReport();

      // Calcular estadísticas
      final totalRevenue = sales.fold(
        0.0,
        (sum, sale) => sum + sale.totalAmount,
      );
      final totalSales = sales.length;
      final totalItems = sales.fold(0, (sum, sale) => sum + sale.totalItems);

      emit(
        ReportsLoaded(
          sales: sales,
          totalRevenue: totalRevenue,
          totalSales: totalSales,
          totalItems: totalItems,
        ),
      );
    } catch (e) {
      emit(ReportsError(message: e.toString()));
    }
  }
}

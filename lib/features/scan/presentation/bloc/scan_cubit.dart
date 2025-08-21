import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/scan.dart';
import '../../domain/usecases/add_scan.dart';
import '../../domain/usecases/get_scans.dart';

part 'scan_state.dart';

class ScanCubit extends Cubit<ScanState> {
  final AddScanUseCase addScan;
  final GetScansUseCase getScans;

  ScanCubit({required this.addScan, required this.getScans})
    : super(ScanInitial());

  Future<void> scanBarcode(String code) async {
    emit(ScanLoading());
    try {
      final scan = Scan(barcode: code, scanDate: DateTime.now());
      await addScan(scan);
      emit(ScanSuccess());
    } catch (e) {
      emit(ScanError(message: e.toString()));
    }
  }

  Future<void> loadHistory() async {
    emit(ScanLoading());
    try {
      final list = await getScans();
      emit(ScanHistoryLoaded(scans: list));
    } catch (e) {
      emit(ScanError(message: e.toString()));
    }
  }
}

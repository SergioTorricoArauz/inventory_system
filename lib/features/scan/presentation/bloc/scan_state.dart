part of 'scan_cubit.dart';

abstract class ScanState extends Equatable {
  const ScanState();
  @override
  List<Object?> get props => [];
}

class ScanInitial extends ScanState {}

class ScanLoading extends ScanState {}

class ScanSuccess extends ScanState {}

class ScanHistoryLoaded extends ScanState {
  final List<Scan> scans;
  const ScanHistoryLoaded({required this.scans});
  @override
  List<Object?> get props => [scans];
}

class ScanError extends ScanState {
  final String message;
  const ScanError({required this.message});
  @override
  List<Object?> get props => [message];
}

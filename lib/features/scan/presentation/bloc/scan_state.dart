part of 'scan_cubit.dart';

abstract class ScanState extends Equatable {
  const ScanState();
  @override
  List<Object?> get props => [];
}

class ScanInitial extends ScanState {}

class ScanLoading extends ScanState {}

class ScanSuccess extends ScanState {}

class ProductFound extends ScanState {
  final Product product;
  const ProductFound({required this.product});
  @override
  List<Object?> get props => [product];
}

class ProductNotFound extends ScanState {
  final String barcode;
  const ProductNotFound({required this.barcode});
  @override
  List<Object?> get props => [barcode];
}

class SaleLoaded extends ScanState {
  final List<SaleItem> items;
  final double totalAmount;

  const SaleLoaded({required this.items, required this.totalAmount});

  @override
  List<Object?> get props => [items, totalAmount];
}

class SaleCompleted extends ScanState {}

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

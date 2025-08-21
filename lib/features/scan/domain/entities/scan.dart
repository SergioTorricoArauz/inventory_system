import 'package:equatable/equatable.dart';

class Scan extends Equatable {
  final String barcode;
  final DateTime scanDate;

  const Scan({required this.barcode, required this.scanDate});

  @override
  List<Object?> get props => [barcode, scanDate];
}

import 'package:equatable/equatable.dart';

class ScanModel extends Equatable {
  final String barcode;
  final DateTime scanDate;

  const ScanModel({required this.barcode, required this.scanDate});

  factory ScanModel.fromJson(Map<String, dynamic> json) => ScanModel(
    barcode: json['barcode'],
    scanDate: DateTime.parse(json['scanDate']),
  );

  Map<String, dynamic> toJson() => {
    'barcode': barcode,
    'scanDate': scanDate.toIso8601String(),
  };

  @override
  List<Object?> get props => [barcode, scanDate];
}

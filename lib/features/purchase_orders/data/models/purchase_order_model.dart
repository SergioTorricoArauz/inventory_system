import 'package:equatable/equatable.dart';
import '../../domain/entities/purchase_order.dart';
import 'purchase_order_line_model.dart';

class PurchaseOrderModel extends Equatable {
  final String id;
  final String supplierId;
  final String supplierName;
  final int status;
  final String statusText;
  final String expectedDate;
  final String notes;
  final double subtotal;
  final double taxes;
  final double total;
  final String createdBy;
  final String createdAt;
  final List<PurchaseOrderLineModel> lines;

  const PurchaseOrderModel({
    required this.id,
    required this.supplierId,
    required this.supplierName,
    required this.status,
    required this.statusText,
    required this.expectedDate,
    required this.notes,
    required this.subtotal,
    required this.taxes,
    required this.total,
    required this.createdBy,
    required this.createdAt,
    required this.lines,
  });

  factory PurchaseOrderModel.fromJson(Map<String, dynamic> json) {
    return PurchaseOrderModel(
      id: json['id']?.toString() ?? '',
      supplierId: json['supplierId']?.toString() ?? '',
      supplierName: json['supplierName']?.toString() ?? '',
      status: (json['status'] as num).toInt(),
      statusText: json['statusText']?.toString() ?? '',
      expectedDate: json['expectedDate']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      subtotal: (json['subtotal'] as num).toDouble(),
      taxes: (json['taxes'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      createdBy: json['createdBy']?.toString() ?? '',
      createdAt: json['createdAt']?.toString() ?? '',
      lines:
          (json['lines'] as List<dynamic>?)
              ?.map(
                (line) => PurchaseOrderLineModel.fromJson(
                  line as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'supplierId': supplierId,
      'supplierName': supplierName,
      'status': status,
      'statusText': statusText,
      'expectedDate': expectedDate,
      'notes': notes,
      'subtotal': subtotal,
      'taxes': taxes,
      'total': total,
      'createdBy': createdBy,
      'createdAt': createdAt,
      'lines': lines.map((line) => line.toJson()).toList(),
    };
  }

  PurchaseOrder toEntity() {
    return PurchaseOrder(
      id: id,
      supplierId: supplierId,
      supplierName: supplierName,
      status: PurchaseOrderStatus.fromValue(status),
      statusText: statusText,
      expectedDate: DateTime.parse(expectedDate),
      notes: notes,
      subtotal: subtotal,
      taxes: taxes,
      total: total,
      createdBy: createdBy,
      createdAt: DateTime.parse(createdAt),
      lines: lines.map((line) => line.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    supplierId,
    supplierName,
    status,
    statusText,
    expectedDate,
    notes,
    subtotal,
    taxes,
    total,
    createdBy,
    createdAt,
    lines,
  ];
}

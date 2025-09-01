import 'package:equatable/equatable.dart';
import '../../domain/entities/good_receipt_note.dart';
import 'grn_line_model.dart';

class GoodReceiptNoteModel extends Equatable {
  final String id;
  final String purchaseOrderId;
  final String referenceNumber;
  final String notes;
  final String receivedBy;
  final String receivedAt;
  final String branchId;
  final List<GrnLineModel> lines;

  const GoodReceiptNoteModel({
    required this.id,
    required this.purchaseOrderId,
    required this.referenceNumber,
    required this.notes,
    required this.receivedBy,
    required this.receivedAt,
    required this.branchId,
    required this.lines,
  });

  factory GoodReceiptNoteModel.fromJson(Map<String, dynamic> json) {
    return GoodReceiptNoteModel(
      id: json['id']?.toString() ?? '',
      purchaseOrderId: json['purchaseOrderId']?.toString() ?? '',
      referenceNumber: json['referenceNumber']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      receivedBy: json['receivedBy']?.toString() ?? '',
      receivedAt: json['receivedAt']?.toString() ?? '',
      branchId: json['branchId']?.toString() ?? '',
      lines:
          (json['lines'] as List<dynamic>?)
              ?.map(
                (line) => GrnLineModel.fromJson(line as Map<String, dynamic>),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'purchaseOrderId': purchaseOrderId,
      'referenceNumber': referenceNumber,
      'notes': notes,
      'receivedBy': receivedBy,
      'receivedAt': receivedAt,
      'branchId': branchId,
      'lines': lines.map((line) => line.toJson()).toList(),
    };
  }

  GoodReceiptNote toEntity() {
    return GoodReceiptNote(
      id: id,
      purchaseOrderId: purchaseOrderId,
      referenceNumber: referenceNumber,
      notes: notes,
      receivedBy: receivedBy,
      receivedAt: DateTime.parse(receivedAt),
      branchId: branchId,
      lines: lines.map((line) => line.toEntity()).toList(),
    );
  }

  @override
  List<Object?> get props => [
    id,
    purchaseOrderId,
    referenceNumber,
    notes,
    receivedBy,
    receivedAt,
    branchId,
    lines,
  ];
}

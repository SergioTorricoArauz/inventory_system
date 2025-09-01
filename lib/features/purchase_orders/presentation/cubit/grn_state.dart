import 'package:equatable/equatable.dart';
import '../../domain/entities/good_receipt_note.dart';

abstract class GrnState extends Equatable {
  @override
  List<Object?> get props => [];
}

class GrnInitial extends GrnState {}

class GrnLoading extends GrnState {}

// Estados para lista de GRNs
class GrnListLoaded extends GrnState {
  final List<GoodReceiptNote> grns;

  GrnListLoaded(this.grns);

  @override
  List<Object?> get props => [grns];
}

// Estados para creación de GRN
class GrnInProgress extends GrnState {
  final GoodReceiptNote grn;
  final bool canSave;

  GrnInProgress({required this.grn, required this.canSave});

  @override
  List<Object?> get props => [grn, canSave];

  GrnInProgress copyWith({GoodReceiptNote? grn, bool? canSave}) {
    return GrnInProgress(
      grn: grn ?? this.grn,
      canSave: canSave ?? this.canSave,
    );
  }
}

class GrnSaving extends GrnState {}

class GrnSaved extends GrnState {
  final GoodReceiptNote grn;

  GrnSaved(this.grn);

  @override
  List<Object?> get props => [grn];
}

class GrnError extends GrnState {
  final String message;

  GrnError(this.message);

  @override
  List<Object?> get props => [message];
}

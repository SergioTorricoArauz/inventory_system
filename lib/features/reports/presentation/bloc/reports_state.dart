part of 'reports_cubit.dart';

abstract class ReportsState extends Equatable {
  const ReportsState();
  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {}

class ReportsLoading extends ReportsState {}

class ReportsLoaded extends ReportsState {
  final List<Sale> sales;
  final double totalRevenue;
  final int totalSales;
  final int totalItems;

  const ReportsLoaded({
    required this.sales,
    required this.totalRevenue,
    required this.totalSales,
    required this.totalItems,
  });

  @override
  List<Object?> get props => [sales, totalRevenue, totalSales, totalItems];
}

class ReportsError extends ReportsState {
  final String message;

  const ReportsError({required this.message});

  @override
  List<Object?> get props => [message];
}

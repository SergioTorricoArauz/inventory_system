import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/supplier_product_cubit.dart';
import '../../../product/presentation/bloc/product_cubit.dart';
import '../pages/supplier_products_page.dart';
import '../../../../injection_container.dart' as di;

/// Widget wrapper para facilitar la navegación a SupplierProducts
/// desde cualquier parte de la aplicación
class SupplierProductsWrapper extends StatelessWidget {
  final String supplierId;
  final String supplierName;

  const SupplierProductsWrapper({
    super.key,
    required this.supplierId,
    required this.supplierName,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SupplierProductCubit>(
          create: (_) => di.sl<SupplierProductCubit>(),
        ),
        BlocProvider<ProductCubit>(create: (_) => di.sl<ProductCubit>()),
      ],
      child: SupplierProductsPage(
        supplierId: supplierId,
        supplierName: supplierName,
      ),
    );
  }

  /// Método estático para navegar fácilmente desde cualquier contexto
  static Future<void> navigateTo(
    BuildContext context,
    String supplierId,
    String supplierName,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SupplierProductsWrapper(
          supplierId: supplierId,
          supplierName: supplierName,
        ),
      ),
    );
  }
}

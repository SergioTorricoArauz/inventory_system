import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'supplier_products_page.dart';
import 'supplier_product_form_page.dart';
import '../bloc/supplier_product_cubit.dart';
import '../../../product/presentation/bloc/product_cubit.dart';
import '../../../../injection_container.dart' as di;

class TestNavigationPage extends StatelessWidget {
  const TestNavigationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Navigation'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider<SupplierProductCubit>(
                          create: (_) => di.sl<SupplierProductCubit>(),
                        ),
                        BlocProvider<ProductCubit>(
                          create: (_) => di.sl<ProductCubit>(),
                        ),
                      ],
                      child: const SupplierProductsPage(
                        supplierId: '1',
                        supplierName: 'Test Supplier',
                      ),
                    ),
                  ),
                );
              },
              child: const Text('Test Supplier Products Page'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider<SupplierProductCubit>(
                          create: (_) => di.sl<SupplierProductCubit>(),
                        ),
                        BlocProvider<ProductCubit>(
                          create: (_) => di.sl<ProductCubit>(),
                        ),
                      ],
                      child: const SupplierProductFormPage(
                        supplierId: '1',
                        supplierName: 'Test Supplier',
                      ),
                    ),
                  ),
                );
              },
              child: const Text('Test Supplier Product Form Page'),
            ),
          ],
        ),
      ),
    );
  }
}

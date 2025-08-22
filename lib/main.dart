import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inventory_system/features/scan/presentation/bloc/scan_cubit.dart';
import 'package:inventory_system/features/product/presentation/bloc/product_cubit.dart';
import 'package:inventory_system/features/category/presentation/bloc/category_cubit.dart';
import 'package:inventory_system/features/reports/presentation/bloc/reports_cubit.dart';
import 'package:inventory_system/features/home/presentation/pages/home_page.dart';
import 'package:inventory_system/injection_container.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ScanCubit>(create: (_) => sl<ScanCubit>()),
        BlocProvider<ProductCubit>(create: (_) => sl<ProductCubit>()),
        BlocProvider<CategoryCubit>(create: (_) => sl<CategoryCubit>()),
        BlocProvider<ReportsCubit>(create: (_) => sl<ReportsCubit>()),
      ],
      child: MaterialApp(
        title: 'Sistema de Inventario',
        theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
        home: const HomePage(),
      ),
    );
  }
}

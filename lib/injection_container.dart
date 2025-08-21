import 'package:get_it/get_it.dart';
import 'package:inventory_system/features/scan/domain/repositories/scan_repository.dart';
import 'package:inventory_system/features/scan/domain/usecases/add_scan.dart';
import 'package:inventory_system/features/scan/domain/usecases/get_scans.dart';
import 'package:inventory_system/features/scan/presentation/bloc/scan_cubit.dart';
import 'package:inventory_system/features/scan/data/datasources/scan_remote_data_source.dart';
import 'package:inventory_system/features/scan/data/repositories/scan_repo_impl.dart';
import 'package:inventory_system/features/product/domain/repositories/product_repository.dart';
import 'package:inventory_system/features/product/domain/usecases/get_products.dart';
import 'package:inventory_system/features/product/domain/usecases/get_product_by_id.dart';
import 'package:inventory_system/features/product/domain/usecases/create_product.dart';
import 'package:inventory_system/features/product/domain/usecases/update_product.dart';
import 'package:inventory_system/features/product/domain/usecases/delete_product.dart';
import 'package:inventory_system/features/product/presentation/bloc/product_cubit.dart';
import 'package:inventory_system/features/product/presentation/bloc/product_edit_cubit.dart';
import 'package:inventory_system/features/product/presentation/bloc/product_create_cubit.dart';
import 'package:inventory_system/features/product/data/datasources/product_remote_data_source.dart';
import 'package:inventory_system/features/product/data/repositories/product_repository_impl.dart';
import 'package:inventory_system/features/category/domain/repositories/category_repository.dart';
import 'package:inventory_system/features/category/domain/usecases/get_categories.dart';
import 'package:inventory_system/features/category/domain/usecases/get_category_by_id.dart';
import 'package:inventory_system/features/category/domain/usecases/update_category.dart';
import 'package:inventory_system/features/category/domain/usecases/delete_category.dart';
import 'package:inventory_system/features/category/domain/usecases/create_category.dart';
import 'package:inventory_system/features/category/presentation/bloc/category_cubit.dart';
import 'package:inventory_system/features/category/presentation/bloc/category_edit_cubit.dart';
import 'package:inventory_system/features/category/presentation/bloc/category_create_cubit.dart';
import 'package:inventory_system/features/category/data/datasources/category_remote_data_source.dart';
import 'package:inventory_system/features/category/data/repositories/category_repository_impl.dart';
import 'core/network/api_client.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerLazySingleton<ApiClient>(() => ApiClient());

  // Scan Feature
  // Data Source
  sl.registerLazySingleton<ScanRemoteDataSource>(
    () => ScanRemoteDataSourceImpl(sl()),
  );
  // Repository
  sl.registerLazySingleton<ScanRepository>(
    () => ScanRepositoryImpl(remoteDataSource: sl()),
  );
  // UseCases
  sl.registerLazySingleton(() => AddScanUseCase(sl()));
  sl.registerLazySingleton(() => GetScansUseCase(sl()));
  // Cubit / Bloc
  sl.registerFactory(() => ScanCubit(addScan: sl(), getScans: sl()));

  // Product Feature
  // Data Source
  sl.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(sl()),
  );
  // Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDataSource: sl()),
  );
  // UseCases
  sl.registerLazySingleton(() => GetProductsUseCase(sl()));
  sl.registerLazySingleton(() => GetProductByIdUseCase(sl()));
  sl.registerLazySingleton(() => CreateProductUseCase(sl()));
  sl.registerLazySingleton(() => UpdateProductUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));
  // Cubit / Bloc
  sl.registerFactory(
    () => ProductCubit(getProducts: sl(), deleteProduct: sl()),
  );
  sl.registerFactory(
    () => ProductEditCubit(getProductById: sl(), updateProduct: sl()),
  );
  sl.registerFactory(() => ProductCreateCubit(createProduct: sl()));

  // Category Feature
  // Data Source
  sl.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(sl()),
  );
  // Repository
  sl.registerLazySingleton<CategoryRepository>(
    () => CategoryRepositoryImpl(remoteDataSource: sl()),
  );
  // UseCases
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoryByIdUseCase(sl()));
  sl.registerLazySingleton(() => UpdateCategoryUseCase(sl()));
  sl.registerLazySingleton(() => DeleteCategoryUseCase(sl()));
  sl.registerLazySingleton(() => CreateCategoryUseCase(sl()));
  // Cubit / Bloc
  sl.registerFactory(
    () => CategoryCubit(getCategories: sl(), deleteCategory: sl()),
  );
  sl.registerFactory(
    () => CategoryEditCubit(getCategoryById: sl(), updateCategory: sl()),
  );
  sl.registerFactory(() => CategoryCreateCubit(createCategory: sl()));
}

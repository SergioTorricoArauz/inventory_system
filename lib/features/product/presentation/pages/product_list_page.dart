import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_cubit.dart';
import '../bloc/product_edit_cubit.dart';
import '../bloc/product_create_cubit.dart';
import 'product_edit_page.dart';
import 'product_create_page.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/product.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    super.initState();
    context.read<ProductCubit>().loadProducts();
  }

  void _showDeleteConfirmationDialog(BuildContext context, Product product) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
            '¿Estás seguro de que quieres eliminar el producto "${product.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<ProductCubit>().deleteProductById(product.id);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Productos'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => sl<ProductCreateCubit>(),
                    child: const ProductCreatePage(),
                  ),
                ),
              );

              // Si se creó un producto, recargar la lista
              if (result == true && context.mounted) {
                context.read<ProductCubit>().loadProducts();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ProductCubit>().loadProducts(),
          ),
        ],
      ),
      body: BlocListener<ProductCubit, ProductState>(
        listener: (context, state) {
          if (state is ProductDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Producto eliminado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            // Recargar la lista después de eliminar
            context.read<ProductCubit>().loadProducts();
          } else if (state is ProductDeleteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al eliminar producto: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded ||
                state is ProductDeleting ||
                state is ProductDeleteError) {
              final products = state is ProductLoaded
                  ? state.products
                  : state is ProductDeleting
                  ? state.products
                  : (state as ProductDeleteError).products;

              if (products.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No hay productos disponibles',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.inventory,
                          color: Colors.blue.shade700,
                          size: 28,
                        ),
                      ),
                      title: Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  '\$${product.price.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: product.stockQuantity > 0
                                      ? Colors.blue.shade100
                                      : Colors.red.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Stock: ${product.stockQuantity}',
                                  style: TextStyle(
                                    color: product.stockQuantity > 0
                                        ? Colors.blue.shade700
                                        : Colors.red.shade700,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Código: ${product.barcode}',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (_) => sl<ProductEditCubit>(),
                                    child: ProductEditPage(
                                      productId: product.id,
                                    ),
                                  ),
                                ),
                              );

                              // Si se guardaron cambios, recargar la lista
                              if (result == true && context.mounted) {
                                context.read<ProductCubit>().loadProducts();
                              }
                            },
                          ),
                          BlocBuilder<ProductCubit, ProductState>(
                            builder: (context, currentState) {
                              final isDeleting =
                                  currentState is ProductDeleting &&
                                  (currentState).deletingId == product.id;

                              return IconButton(
                                icon: isDeleting
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                onPressed: isDeleting
                                    ? null
                                    : () => _showDeleteConfirmationDialog(
                                        context,
                                        product,
                                      ),
                              );
                            },
                          ),
                        ],
                      ),
                      onTap: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (_) => sl<ProductEditCubit>(),
                              child: ProductEditPage(productId: product.id),
                            ),
                          ),
                        );

                        // Si se guardaron cambios, recargar la lista
                        if (result == true && context.mounted) {
                          context.read<ProductCubit>().loadProducts();
                        }
                      },
                    ),
                  );
                },
              );
            } else if (state is ProductError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar productos',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () =>
                          context.read<ProductCubit>().loadProducts(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }
            return const Center(child: Text('Estado inicial'));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => sl<ProductCreateCubit>(),
                child: const ProductCreatePage(),
              ),
            ),
          );

          // Si se creó un producto, recargar la lista
          if (result == true && context.mounted) {
            context.read<ProductCubit>().loadProducts();
          }
        },
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Producto'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/category_cubit.dart';
import '../bloc/category_edit_cubit.dart';
import '../bloc/category_create_cubit.dart';
import 'category_edit_page.dart';
import 'category_create_page.dart';
import '../../../../injection_container.dart';
import '../../domain/entities/category.dart';

class CategoryListPage extends StatefulWidget {
  const CategoryListPage({super.key});

  @override
  State<CategoryListPage> createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryCubit>().loadCategories();
  }

  void _showDeleteConfirmationDialog(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
            '¿Estás seguro de que quieres eliminar la categoría "${category.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<CategoryCubit>().deleteCategoryById(category.id);
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
        title: const Text('Categorías'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (_) => sl<CategoryCreateCubit>(),
                    child: const CategoryCreatePage(),
                  ),
                ),
              );

              // Si se creó una categoría, recargar la lista
              if (result == true && context.mounted) {
                context.read<CategoryCubit>().loadCategories();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<CategoryCubit>().loadCategories(),
          ),
        ],
      ),
      body: BlocListener<CategoryCubit, CategoryState>(
        listener: (context, state) {
          if (state is CategoryDeleteSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Categoría eliminada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            // Recargar la lista después de eliminar
            context.read<CategoryCubit>().loadCategories();
          } else if (state is CategoryDeleteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al eliminar categoría: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<CategoryCubit, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CategoryLoaded ||
                state is CategoryDeleting ||
                state is CategoryDeleteError) {
              final categories = state is CategoryLoaded
                  ? state.categories
                  : state is CategoryDeleting
                  ? state.categories
                  : (state as CategoryDeleteError).categories;

              if (categories.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'No hay categorías disponibles',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final category = categories[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 3,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.purple.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.category,
                          color: Colors.purple.shade700,
                          size: 28,
                        ),
                      ),
                      title: Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Text(
                            category.description,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade100,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'ID: ${category.id}',
                              style: TextStyle(
                                color: Colors.purple.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
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
                                    create: (_) => sl<CategoryEditCubit>(),
                                    child: CategoryEditPage(
                                      categoryId: category.id,
                                    ),
                                  ),
                                ),
                              );

                              // Si se guardaron cambios, recargar la lista
                              if (result == true && context.mounted) {
                                context.read<CategoryCubit>().loadCategories();
                              }
                            },
                          ),
                          BlocBuilder<CategoryCubit, CategoryState>(
                            builder: (context, currentState) {
                              final isDeleting =
                                  currentState is CategoryDeleting &&
                                  (currentState).deletingId == category.id;

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
                                        category,
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
                              create: (_) => sl<CategoryEditCubit>(),
                              child: CategoryEditPage(categoryId: category.id),
                            ),
                          ),
                        );

                        // Si se guardaron cambios, recargar la lista
                        if (result == true && context.mounted) {
                          context.read<CategoryCubit>().loadCategories();
                        }
                      },
                    ),
                  );
                },
              );
            } else if (state is CategoryError) {
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
                      'Error al cargar categorías',
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
                          context.read<CategoryCubit>().loadCategories(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Reintentar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
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
                create: (_) => sl<CategoryCreateCubit>(),
                child: const CategoryCreatePage(),
              ),
            ),
          );

          // Si se creó una categoría, recargar la lista
          if (result == true && context.mounted) {
            context.read<CategoryCubit>().loadCategories();
          }
        },
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Nueva Categoría'),
      ),
    );
  }
}

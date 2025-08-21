import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/category.dart';
import '../bloc/category_edit_cubit.dart';

class CategoryEditPage extends StatefulWidget {
  final String categoryId;

  const CategoryEditPage({super.key, required this.categoryId});

  @override
  State<CategoryEditPage> createState() => _CategoryEditPageState();
}

class _CategoryEditPageState extends State<CategoryEditPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  Category? _currentCategory;

  @override
  void initState() {
    super.initState();
    context.read<CategoryEditCubit>().loadCategory(widget.categoryId);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _populateForm(Category category) {
    _currentCategory = category;
    _nameController.text = category.name;
    _descriptionController.text = category.description;
  }

  void _saveCategory() {
    if (_formKey.currentState!.validate() && _currentCategory != null) {
      final updatedCategory = Category(
        id: _currentCategory!.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
      );

      context.read<CategoryEditCubit>().saveCategory(updatedCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Categoría'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
        actions: [
          BlocBuilder<CategoryEditCubit, CategoryEditState>(
            builder: (context, state) {
              return IconButton(
                icon: const Icon(Icons.save),
                onPressed: state is CategoryEditLoaded ? _saveCategory : null,
              );
            },
          ),
        ],
      ),
      body: BlocListener<CategoryEditCubit, CategoryEditState>(
        listener: (context, state) {
          if (state is CategoryEditLoaded) {
            _populateForm(state.category);
          } else if (state is CategoryEditSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✓ Categoría actualizada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.pop(
              context,
              true,
            ); // Retorna true para indicar que se guardó
          } else if (state is CategoryEditError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
            // Volver al estado cargado si hay error
            if (_currentCategory != null) {
              context.read<CategoryEditCubit>().resetToLoaded(
                _currentCategory!,
              );
            }
          }
        },
        child: BlocBuilder<CategoryEditCubit, CategoryEditState>(
          builder: (context, state) {
            if (state is CategoryEditLoading) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Cargando categoría...'),
                  ],
                ),
              );
            }

            if (state is CategoryEditError && _currentCategory == null) {
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
                      'Error al cargar la categoría',
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
                      onPressed: () {
                        context.read<CategoryEditCubit>().loadCategory(
                          widget.categoryId,
                        );
                      },
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

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Información de la categoría
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.category,
                                  color: Colors.purple.shade700,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Información de la Categoría',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            if (_currentCategory != null) ...[
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.purple.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    const Text(
                                      'ID: ',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        _currentCategory!.id,
                                        style: TextStyle(
                                          color: Colors.purple.shade700,
                                          fontFamily: 'monospace',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],
                            // Campo Nombre
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Nombre de la categoría',
                                hintText: 'Ingrese el nombre de la categoría',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.label),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'El nombre es requerido';
                                }
                                if (value.trim().length < 2) {
                                  return 'El nombre debe tener al menos 2 caracteres';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            // Campo Descripción
                            TextFormField(
                              controller: _descriptionController,
                              maxLines: 3,
                              decoration: const InputDecoration(
                                labelText: 'Descripción',
                                hintText:
                                    'Ingrese la descripción de la categoría',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.description),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'La descripción es requerida';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Botones de acción
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.cancel),
                            label: const Text('Cancelar'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child:
                              BlocBuilder<CategoryEditCubit, CategoryEditState>(
                                builder: (context, state) {
                                  final isLoading = state is CategoryEditSaving;
                                  return ElevatedButton.icon(
                                    onPressed: isLoading ? null : _saveCategory,
                                    icon: isLoading
                                        ? const SizedBox(
                                            width: 16,
                                            height: 16,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const Icon(Icons.save),
                                    label: Text(
                                      isLoading ? 'Guardando...' : 'Guardar',
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.purple,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                    ),
                                  );
                                },
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/category_create_cubit.dart';

class CategoryCreatePage extends StatefulWidget {
  const CategoryCreatePage({super.key});

  @override
  State<CategoryCreatePage> createState() => _CategoryCreatePageState();
}

class _CategoryCreatePageState extends State<CategoryCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _createCategory() {
    if (_formKey.currentState!.validate()) {
      context.read<CategoryCreateCubit>().createNewCategory(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Categoría'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<CategoryCreateCubit, CategoryCreateState>(
        listener: (context, state) {
          if (state is CategoryCreateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Categoría creada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true); // Retorna true para indicar éxito
          } else if (state is CategoryCreateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al crear categoría: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),

                // Icono de categoría
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.add_box_outlined,
                      color: Colors.purple.shade700,
                      size: 40,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Campo Nombre
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre de la Categoría',
                    prefixIcon: Icon(
                      Icons.category,
                      color: Colors.purple.shade600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.purple.shade600,
                        width: 2,
                      ),
                    ),
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

                const SizedBox(height: 20),

                // Campo Descripción
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'Descripción',
                    prefixIcon: Icon(
                      Icons.description,
                      color: Colors.purple.shade600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.purple.shade600,
                        width: 2,
                      ),
                    ),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La descripción es requerida';
                    }
                    if (value.trim().length < 5) {
                      return 'La descripción debe tener al menos 5 caracteres';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 30),

                // Botón Crear
                BlocBuilder<CategoryCreateCubit, CategoryCreateState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is CategoryCreateLoading
                          ? null
                          : _createCategory,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                      child: state is CategoryCreateLoading
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                Text('Creando...'),
                              ],
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add),
                                SizedBox(width: 8),
                                Text(
                                  'Crear Categoría',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                // Botón Cancelar
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

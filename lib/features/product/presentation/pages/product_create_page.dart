import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_create_cubit.dart';
import 'product_barcode_scan_page.dart';
import '../widgets/category_selector_page.dart';
import '../../../category/presentation/bloc/category_cubit.dart';
import '../../../category/domain/entities/category.dart';
import '../../../../injection_container.dart' as di;

class ProductCreatePage extends StatefulWidget {
  const ProductCreatePage({super.key});

  @override
  State<ProductCreatePage> createState() => _ProductCreatePageState();
}

class _ProductCreatePageState extends State<ProductCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _barcodeController = TextEditingController();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _stockController = TextEditingController();

  String? _selectedCategoryId;

  @override
  void dispose() {
    _barcodeController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _scanBarcode() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProductBarcodeScanPage()),
    );

    // Verificar que el widget sigue montado antes de usar context
    if (!mounted) return;

    if (result != null && result != 'manual') {
      setState(() {
        _barcodeController.text = result;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Código escaneado: $result'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _openCategorySelector() async {
    final result = await Navigator.push<String?>(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => di.sl<CategoryCubit>(),
          child: CategorySelectorPage(selectedCategoryId: _selectedCategoryId),
        ),
      ),
    );

    // Verificar que el widget sigue montado antes de usar context/setState
    if (!mounted) return;

    if (result != _selectedCategoryId) {
      setState(() {
        _selectedCategoryId = result;
      });
    }
  }

  Future<String> _getCategoryName(String? categoryId) async {
    if (categoryId == null) {
      return 'Ninguna categoría seleccionada';
    }

    try {
      // Crear una instancia temporal del cubit para obtener las categorías
      final categoryCubit = di.sl<CategoryCubit>();
      await categoryCubit.loadCategories();

      final state = categoryCubit.state;
      if (state is CategoryLoaded) {
        final category = state.categories.firstWhere(
          (cat) => cat.id == categoryId,
          orElse: () => Category(
            id: categoryId,
            name: 'Categoría no encontrada',
            description: '',
          ),
        );
        return category.name;
      }
      return 'Error al cargar categoría';
    } catch (e) {
      return 'Error al cargar categoría';
    }
  }

  void _createProduct() {
    if (_formKey.currentState!.validate() && _selectedCategoryId != null) {
      context.read<ProductCreateCubit>().createNewProduct(
        barcode: _barcodeController.text.trim(),
        name: _nameController.text.trim(),
        price: double.parse(_priceController.text.trim()),
        stockQuantity: int.parse(_stockController.text.trim()),
        categoryId: _selectedCategoryId!,
      );
    } else if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona una categoría'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Producto'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<ProductCreateCubit, ProductCreateState>(
        listener: (context, state) {
          if (state is ProductCreateSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Producto creado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state is ProductCreateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error al crear producto: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                const SizedBox(height: 20),

                // Icono
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Icon(
                      Icons.add_shopping_cart_outlined,
                      color: Colors.blue.shade700,
                      size: 40,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Botón de Escaneo Prominente
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: 20),
                  child: ElevatedButton.icon(
                    onPressed: _scanBarcode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    icon: const Icon(Icons.qr_code_scanner, size: 24),
                    label: const Text(
                      'Escanear Código de Barras',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                // Divider con texto "O"
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'O',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 20),

                // Campo Código de Barras
                TextFormField(
                  controller: _barcodeController,
                  decoration: InputDecoration(
                    labelText: 'Código de Barras',
                    prefixIcon: Icon(
                      Icons.qr_code,
                      color: Colors.blue.shade600,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.qr_code_scanner,
                        color: Colors.blue.shade600,
                      ),
                      onPressed: _scanBarcode,
                      tooltip: 'Escanear código',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.blue.shade600,
                        width: 2,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El código de barras es requerido';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Campo Nombre
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Nombre del Producto',
                    prefixIcon: Icon(
                      Icons.shopping_bag,
                      color: Colors.blue.shade600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.blue.shade600,
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

                // Campo Precio
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                    labelText: 'Precio',
                    prefixIcon: Icon(
                      Icons.attach_money,
                      color: Colors.blue.shade600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.blue.shade600,
                        width: 2,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El precio es requerido';
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return 'Ingrese un precio válido';
                    }
                    if (double.parse(value.trim()) < 0) {
                      return 'El precio debe ser mayor a 0';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Campo Stock
                TextFormField(
                  controller: _stockController,
                  decoration: InputDecoration(
                    labelText: 'Cantidad en Stock',
                    prefixIcon: Icon(
                      Icons.inventory,
                      color: Colors.blue.shade600,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.blue.shade600,
                        width: 2,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'La cantidad en stock es requerida';
                    }
                    if (int.tryParse(value.trim()) == null) {
                      return 'Ingrese una cantidad válida';
                    }
                    if (int.parse(value.trim()) < 0) {
                      return 'La cantidad debe ser mayor o igual a 0';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 20),

                // Selector de Categoría
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _selectedCategoryId == null
                          ? Colors.red.shade300
                          : Colors.grey.shade400,
                      width: _selectedCategoryId == null ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      Icons.category,
                      color: _selectedCategoryId == null
                          ? Colors.red.shade600
                          : Colors.purple.shade600,
                    ),
                    title: Text(
                      _selectedCategoryId != null
                          ? 'Categoría seleccionada'
                          : 'Seleccionar categoría *',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: _selectedCategoryId == null
                            ? Colors.red.shade700
                            : null,
                      ),
                    ),
                    subtitle: FutureBuilder<String>(
                      future: _getCategoryName(_selectedCategoryId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('Cargando...');
                        }
                        return Text(
                          snapshot.data ?? 'Ninguna categoría seleccionada',
                          style: TextStyle(
                            color: _selectedCategoryId != null
                                ? Colors.purple.shade600
                                : Colors.grey.shade600,
                          ),
                        );
                      },
                    ),
                    trailing: const Icon(Icons.arrow_drop_down),
                    onTap: _openCategorySelector,
                  ),
                ),

                const SizedBox(height: 30),

                // Botón Crear
                BlocBuilder<ProductCreateCubit, ProductCreateState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: state is ProductCreateLoading
                          ? null
                          : _createProduct,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade700,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: state is ProductCreateLoading
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
                                  'Crear Producto',
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

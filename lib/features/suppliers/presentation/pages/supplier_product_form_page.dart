import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/supplier_product_cubit.dart';
import '../bloc/supplier_product_state.dart';
import '../../domain/entities/supplier_product.dart';
import '../../../product/presentation/bloc/product_cubit.dart';
import '../../../product/domain/entities/product.dart';

class SupplierProductFormPage extends StatefulWidget {
  final String supplierId;
  final String supplierName;
  final SupplierProduct? supplierProduct;

  const SupplierProductFormPage({
    super.key,
    required this.supplierId,
    required this.supplierName,
    this.supplierProduct,
  });

  @override
  State<SupplierProductFormPage> createState() =>
      _SupplierProductFormPageState();
}

class _SupplierProductFormPageState extends State<SupplierProductFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _supplierSkuController = TextEditingController();
  final _lastCostController = TextEditingController();
  final _minOrderQtyController = TextEditingController();
  final _leadTimeDaysController = TextEditingController();

  Product? _selectedProduct;
  String _selectedCurrency = 'BOB';
  bool _isPreferred = false;
  bool _isLoading = false;

  final List<String> _currencies = ['BOB', 'USD', 'EUR'];

  @override
  void initState() {
    super.initState();
    _initializeForm();
    // Cargar productos disponibles
    context.read<ProductCubit>().loadProducts();
  }

  void _initializeForm() {
    if (widget.supplierProduct != null) {
      final sp = widget.supplierProduct!;
      _supplierSkuController.text = sp.supplierSku;
      _lastCostController.text = sp.lastCost.toString();
      _minOrderQtyController.text = sp.minOrderQty.toString();
      _leadTimeDaysController.text = sp.leadTimeDays.toString();
      _selectedCurrency = sp.currency;
      _isPreferred = sp.preferred;
      // Note: Necesitaríamos cargar el producto específico para mostrarlo seleccionado
    }
  }

  @override
  void dispose() {
    _supplierSkuController.dispose();
    _lastCostController.dispose();
    _minOrderQtyController.dispose();
    _leadTimeDaysController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate() && _selectedProduct != null) {
      final supplierProduct = SupplierProduct(
        supplierId: widget.supplierId,
        productId: _selectedProduct!.id,
        supplierSku: _supplierSkuController.text.trim(),
        lastCost: double.parse(_lastCostController.text),
        currency: _selectedCurrency,
        minOrderQty: int.parse(_minOrderQtyController.text),
        leadTimeDays: int.parse(_leadTimeDaysController.text),
        preferred: _isPreferred,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        supplierName: widget.supplierName,
        productName: _selectedProduct!.name,
        productBarcode: _selectedProduct!.barcode,
      );

      context.read<SupplierProductCubit>().addSupplierProduct(supplierProduct);
    } else if (_selectedProduct == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor selecciona un producto'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Widget _buildProductSelector(bool isDesktop) {
    final screenSize = MediaQuery.of(context).size;
    final isMobile = screenSize.width < 768;

    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Producto *',
                style: TextStyle(
                  fontSize: isDesktop ? 16 : 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                height: isDesktop ? 60 : 50,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ],
          );
        }

        if (state is ProductLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Producto *',
                style: TextStyle(
                  fontSize: isDesktop ? 16 : 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<Product>(
                    value: _selectedProduct,
                    isExpanded: true,
                    hint: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isDesktop ? 16 : 12,
                        vertical: isDesktop ? 16 : 12,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.inventory_2_outlined,
                            size: isDesktop ? 20 : 18,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Seleccionar producto',
                            style: TextStyle(
                              fontSize: isDesktop ? 16 : 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    selectedItemBuilder: (BuildContext context) {
                      return state.products.map((product) {
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 16 : 12,
                            vertical: isDesktop ? 16 : 12,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Icon(
                                  Icons.inventory_2,
                                  size: isDesktop ? 18 : 16,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      product.name,
                                      style: TextStyle(
                                        fontSize: isDesktop ? 16 : 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800],
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (product.barcode.isNotEmpty &&
                                        !isMobile) ...[
                                      const SizedBox(height: 2),
                                      Text(
                                        'Código: ${product.barcode}',
                                        style: TextStyle(
                                          fontSize: isDesktop ? 12 : 10,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList();
                    },
                    items: state.products.map((product) {
                      return DropdownMenuItem<Product>(
                        value: product,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 16 : 12,
                            vertical: isDesktop ? 12 : 8,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.inventory_2,
                                  size: isDesktop ? 20 : 18,
                                  color: Colors.blue.shade700,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      product.name,
                                      style: TextStyle(
                                        fontSize: isDesktop ? 16 : 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey[800],
                                      ),
                                      maxLines: isMobile ? 1 : 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    if (product.barcode.isNotEmpty) ...[
                                      SizedBox(height: isMobile ? 2 : 4),
                                      Text(
                                        'Código: ${product.barcode}',
                                        style: TextStyle(
                                          fontSize: isDesktop ? 12 : 10,
                                          color: Colors.grey[600],
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                    if (product.price > 0 && !isMobile) ...[
                                      SizedBox(height: isMobile ? 2 : 4),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.attach_money_outlined,
                                            size: isDesktop ? 12 : 10,
                                            color: Colors.green.shade600,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Precio: \$${product.price.toStringAsFixed(2)}',
                                            style: TextStyle(
                                              fontSize: isDesktop ? 11 : 9,
                                              color: Colors.green.shade600,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (Product? product) {
                      setState(() {
                        _selectedProduct = product;
                      });
                    },
                    dropdownColor: Colors.white,
                    elevation: 8,
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: isDesktop ? 16 : 14,
                    ),
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: isDesktop ? 24 : 20,
                      color: Colors.grey[600],
                    ),
                    menuMaxHeight: screenSize.height * 0.4,
                  ),
                ),
              ),
            ],
          );
        }

        return Container(
          padding: EdgeInsets.all(isDesktop ? 16 : 12),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            border: Border.all(color: Colors.red.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                Icons.error_outline,
                color: Colors.red.shade600,
                size: isDesktop ? 20 : 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Error al cargar productos. Por favor, intenta nuevamente.',
                  style: TextStyle(
                    color: Colors.red.shade600,
                    fontSize: isDesktop ? 14 : 12,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? suffix,
    bool isDesktop = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isDesktop ? 16 : 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: inputFormatters,
          validator: validator,
          style: TextStyle(fontSize: isDesktop ? 16 : 14),
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: EdgeInsets.symmetric(
              horizontal: isDesktop ? 16 : 12,
              vertical: isDesktop ? 16 : 12,
            ),
            suffixText: suffix,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width >= 1024;
    final isTablet = screenSize.width >= 768 && screenSize.width < 1024;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.supplierProduct == null
                  ? 'Agregar Producto'
                  : 'Editar Producto',
            ),
            Text(
              'Proveedor: ${widget.supplierName}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
      ),
      body: BlocListener<SupplierProductCubit, SupplierProductState>(
        listener: (context, state) {
          if (state is SupplierProductLoading) {
            setState(() => _isLoading = true);
          } else {
            setState(() => _isLoading = false);
          }

          if (state is SupplierProductCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Producto agregado exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state is SupplierProductError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 32 : 16),
          child: Form(
            key: _formKey,
            child: isDesktop
                ? _buildDesktopLayout()
                : _buildMobileLayout(isTablet),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: _isLoading
                    ? null
                    : () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: isDesktop ? 16 : 12),
                ),
                child: Text(
                  'Cancelar',
                  style: TextStyle(fontSize: isDesktop ? 16 : 14),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: isDesktop ? 16 : 12),
                ),
                child: _isLoading
                    ? SizedBox(
                        height: isDesktop ? 20 : 16,
                        width: isDesktop ? 20 : 16,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        widget.supplierProduct == null ? 'Agregar' : 'Guardar',
                        style: TextStyle(
                          fontSize: isDesktop ? 16 : 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selector de producto
        _buildProductSelector(true),
        const SizedBox(height: 24),

        // Fila 1: SKU y Costo
        Row(
          children: [
            Expanded(
              child: _buildFormField(
                label: 'SKU del Proveedor *',
                controller: _supplierSkuController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Este campo es requerido';
                  }
                  return null;
                },
                isDesktop: true,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: _buildFormField(
                      label: 'Último Costo *',
                      controller: _lastCostController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d*'),
                        ),
                      ],
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Este campo es requerido';
                        }
                        final cost = double.tryParse(value!);
                        if (cost == null || cost <= 0) {
                          return 'Ingresa un costo válido';
                        }
                        return null;
                      },
                      isDesktop: true,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Moneda *',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<String>(
                          value: _selectedCurrency,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                          items: _currencies.map((currency) {
                            return DropdownMenuItem(
                              value: currency,
                              child: Text(currency),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCurrency = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Fila 2: Cantidad mínima y tiempo de entrega
        Row(
          children: [
            Expanded(
              child: _buildFormField(
                label: 'Cantidad Mínima de Pedido *',
                controller: _minOrderQtyController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                suffix: 'unidades',
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Este campo es requerido';
                  }
                  final qty = int.tryParse(value!);
                  if (qty == null || qty <= 0) {
                    return 'Ingresa una cantidad válida';
                  }
                  return null;
                },
                isDesktop: true,
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: _buildFormField(
                label: 'Tiempo de Entrega *',
                controller: _leadTimeDaysController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                suffix: 'días',
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Este campo es requerido';
                  }
                  final days = int.tryParse(value!);
                  if (days == null || days < 0) {
                    return 'Ingresa un tiempo válido';
                  }
                  return null;
                },
                isDesktop: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Switch de proveedor preferido
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            border: Border.all(color: Colors.green.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.star, color: Colors.green.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Proveedor Preferido',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Marcar como proveedor preferido para este producto',
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _isPreferred,
                onChanged: (value) {
                  setState(() {
                    _isPreferred = value;
                  });
                },
                activeColor: Colors.green.shade700,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selector de producto
        _buildProductSelector(isTablet),
        const SizedBox(height: 20),

        // SKU del proveedor
        _buildFormField(
          label: 'SKU del Proveedor *',
          controller: _supplierSkuController,
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Este campo es requerido';
            }
            return null;
          },
          isDesktop: isTablet,
        ),
        const SizedBox(height: 20),

        // Costo y moneda
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildFormField(
                label: 'Último Costo *',
                controller: _lastCostController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'Este campo es requerido';
                  }
                  final cost = double.tryParse(value!);
                  if (cost == null || cost <= 0) {
                    return 'Ingresa un costo válido';
                  }
                  return null;
                },
                isDesktop: isTablet,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Moneda *',
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    value: _selectedCurrency,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 16 : 12,
                        vertical: isTablet ? 16 : 12,
                      ),
                    ),
                    items: _currencies.map((currency) {
                      return DropdownMenuItem(
                        value: currency,
                        child: Text(currency),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedCurrency = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Cantidad mínima
        _buildFormField(
          label: 'Cantidad Mínima de Pedido *',
          controller: _minOrderQtyController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          suffix: 'unidades',
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Este campo es requerido';
            }
            final qty = int.tryParse(value!);
            if (qty == null || qty <= 0) {
              return 'Ingresa una cantidad válida';
            }
            return null;
          },
          isDesktop: isTablet,
        ),
        const SizedBox(height: 20),

        // Tiempo de entrega
        _buildFormField(
          label: 'Tiempo de Entrega *',
          controller: _leadTimeDaysController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          suffix: 'días',
          validator: (value) {
            if (value?.isEmpty ?? true) {
              return 'Este campo es requerido';
            }
            final days = int.tryParse(value!);
            if (days == null || days < 0) {
              return 'Ingresa un tiempo válido';
            }
            return null;
          },
          isDesktop: isTablet,
        ),
        const SizedBox(height: 20),

        // Switch de proveedor preferido
        Container(
          padding: EdgeInsets.all(isTablet ? 16 : 12),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            border: Border.all(color: Colors.green.shade200),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.star, color: Colors.green.shade700),
              SizedBox(width: isTablet ? 12 : 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Proveedor Preferido',
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Marcar como proveedor preferido',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: _isPreferred,
                onChanged: (value) {
                  setState(() {
                    _isPreferred = value;
                  });
                },
                activeColor: Colors.green.shade700,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

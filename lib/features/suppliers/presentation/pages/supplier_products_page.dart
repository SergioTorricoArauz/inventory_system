import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../bloc/supplier_product_cubit.dart';
import '../bloc/supplier_product_state.dart';
import '../../domain/entities/supplier_product.dart';
import '../../../../injection_container.dart';
import 'supplier_product_form_page.dart';

class SupplierProductsPage extends StatefulWidget {
  final String supplierId;
  final String supplierName;

  const SupplierProductsPage({
    super.key,
    required this.supplierId,
    required this.supplierName,
  });

  @override
  State<SupplierProductsPage> createState() => _SupplierProductsPageState();
}

class _SupplierProductsPageState extends State<SupplierProductsPage> {
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    context.read<SupplierProductCubit>().loadSupplierProducts(
      widget.supplierId,
    );
  }

  void _showDeleteConfirmationDialog(
    BuildContext context,
    SupplierProduct supplierProduct,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar eliminación'),
          content: Text(
            '¿Estás seguro de que quieres eliminar la relación con el producto "${supplierProduct.productName ?? 'N/A'}"?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                context.read<SupplierProductCubit>().removeSupplierProduct(
                  supplierProduct.supplierId,
                  supplierProduct.productId,
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSupplierProductCard(
    SupplierProduct supplierProduct,
    bool isDesktop,
    bool isTablet,
  ) {
    final currencyFormat = NumberFormat.currency(
      symbol: supplierProduct.currency,
    );

    return Card(
      elevation: isDesktop ? 3 : 2,
      margin: EdgeInsets.only(bottom: isDesktop ? 16 : 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isDesktop ? 12 : 8),
      ),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header con información principal
            Row(
              children: [
                // Icono de producto
                Container(
                  width: isDesktop ? 60 : 50,
                  height: isDesktop ? 60 : 50,
                  decoration: BoxDecoration(
                    color: supplierProduct.preferred
                        ? Colors.green.shade50
                        : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(isDesktop ? 12 : 8),
                    border: Border.all(
                      color: supplierProduct.preferred
                          ? Colors.green.shade300
                          : Colors.blue.shade300,
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2,
                        color: supplierProduct.preferred
                            ? Colors.green.shade700
                            : Colors.blue.shade700,
                        size: isDesktop ? 28 : 24,
                      ),
                      if (supplierProduct.preferred)
                        Positioned(
                          right: 2,
                          top: 2,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.green.shade700,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 10,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                SizedBox(width: isDesktop ? 20 : 16),

                // Información del producto
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nombre del producto
                      Text(
                        supplierProduct.productName ?? 'Producto sin nombre',
                        style: TextStyle(
                          fontSize: isDesktop ? 18 : 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      SizedBox(height: isDesktop ? 8 : 6),

                      // SKU del proveedor
                      Row(
                        children: [
                          Icon(
                            Icons.qr_code,
                            size: isDesktop ? 16 : 14,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'SKU: ${supplierProduct.supplierSku}',
                              style: TextStyle(
                                fontSize: isDesktop ? 14 : 12,
                                color: Colors.grey[600],
                                fontFamily: 'monospace',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      if (supplierProduct.productBarcode?.isNotEmpty ==
                          true) ...[
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.barcode_reader,
                              size: isDesktop ? 16 : 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                'Código: ${supplierProduct.productBarcode}',
                                style: TextStyle(
                                  fontSize: isDesktop ? 14 : 12,
                                  color: Colors.grey[600],
                                  fontFamily: 'monospace',
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Acciones
                if (isDesktop) ...[
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _navigateToEditForm(supplierProduct),
                        tooltip: 'Editar relación',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _showDeleteConfirmationDialog(
                          context,
                          supplierProduct,
                        ),
                        tooltip: 'Eliminar relación',
                      ),
                    ],
                  ),
                ] else ...[
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'edit':
                          _navigateToEditForm(supplierProduct);
                          break;
                        case 'delete':
                          _showDeleteConfirmationDialog(
                            context,
                            supplierProduct,
                          );
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, color: Colors.blue),
                            SizedBox(width: 8),
                            Text('Editar'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Eliminar'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),

            SizedBox(height: isDesktop ? 16 : 12),

            // Información comercial
            if (isDesktop) ...[
              // Desktop: Layout horizontal
              Row(
                children: [
                  _buildInfoChip(
                    'Último Costo',
                    currencyFormat.format(supplierProduct.lastCost),
                    Colors.green,
                    Icons.attach_money,
                    isDesktop,
                  ),
                  const SizedBox(width: 12),
                  _buildInfoChip(
                    'Cant. Mín.',
                    '${supplierProduct.minOrderQty}',
                    Colors.orange,
                    Icons.shopping_cart,
                    isDesktop,
                  ),
                  const SizedBox(width: 12),
                  _buildInfoChip(
                    'Tiempo Entrega',
                    '${supplierProduct.leadTimeDays} días',
                    Colors.blue,
                    Icons.schedule,
                    isDesktop,
                  ),
                  if (supplierProduct.preferred) ...[
                    const SizedBox(width: 12),
                    _buildInfoChip(
                      'Preferido',
                      'Sí',
                      Colors.green,
                      Icons.star,
                      isDesktop,
                    ),
                  ],
                ],
              ),
            ] else ...[
              // Mobile/Tablet: Layout vertical
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildInfoChip(
                    'Último Costo',
                    currencyFormat.format(supplierProduct.lastCost),
                    Colors.green,
                    Icons.attach_money,
                    isDesktop,
                  ),
                  _buildInfoChip(
                    'Cant. Mín.',
                    '${supplierProduct.minOrderQty}',
                    Colors.orange,
                    Icons.shopping_cart,
                    isDesktop,
                  ),
                  _buildInfoChip(
                    'Tiempo Entrega',
                    '${supplierProduct.leadTimeDays} días',
                    Colors.blue,
                    Icons.schedule,
                    isDesktop,
                  ),
                  if (supplierProduct.preferred)
                    _buildInfoChip(
                      'Preferido',
                      'Sí',
                      Colors.green,
                      Icons.star,
                      isDesktop,
                    ),
                ],
              ),
            ],

            // Fechas de actualización (solo en desktop)
            if (isDesktop) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.schedule, size: 14, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    'Actualizado: ${DateFormat('dd/MM/yyyy HH:mm').format(supplierProduct.updatedAt)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(
    String label,
    String value,
    Color color,
    IconData icon,
    bool isDesktop,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 12 : 8,
        vertical: isDesktop ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(isDesktop ? 8 : 6),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isDesktop ? 16 : 14, color: color),
          SizedBox(width: isDesktop ? 6 : 4),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isDesktop ? 10 : 9,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: isDesktop ? 12 : 11,
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _navigateToEditForm(SupplierProduct? supplierProduct) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider(
          create: (_) => sl<SupplierProductCubit>(),
          child: SupplierProductFormPage(
            supplierId: widget.supplierId,
            supplierName: widget.supplierName,
            supplierProduct: supplierProduct,
          ),
        ),
      ),
    );

    if (result == true) {
      setState(() {
        _hasChanges = true;
      });
      if (!mounted) return;
      context.read<SupplierProductCubit>().loadSupplierProducts(
        widget.supplierId,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width >= 1024;
    final isTablet = screenSize.width >= 768 && screenSize.width < 1024;

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop && _hasChanges) {
          Navigator.of(context).pop(true);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Productos del Proveedor'),
              Text(
                widget.supplierName,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(_hasChanges);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _navigateToEditForm(null),
              tooltip: 'Agregar producto',
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => context
                  .read<SupplierProductCubit>()
                  .loadSupplierProducts(widget.supplierId),
              tooltip: 'Actualizar',
            ),
          ],
        ),
        body: BlocListener<SupplierProductCubit, SupplierProductState>(
          listener: (context, state) {
            if (state is SupplierProductDeleted) {
              setState(() {
                _hasChanges = true;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Relación eliminada exitosamente'),
                  backgroundColor: Colors.green,
                ),
              );
              context.read<SupplierProductCubit>().loadSupplierProducts(
                widget.supplierId,
              );
            } else if (state is SupplierProductError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Error: ${state.message}'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<SupplierProductCubit, SupplierProductState>(
            builder: (context, state) {
              if (state is SupplierProductLoading) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Cargando productos...'),
                    ],
                  ),
                );
              }

              if (state is SupplierProductLoaded) {
                if (state.supplierProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: isDesktop ? 80 : 64,
                          color: Colors.grey[400],
                        ),
                        SizedBox(height: isDesktop ? 24 : 16),
                        Text(
                          'No hay productos asociados',
                          style: TextStyle(
                            fontSize: isDesktop ? 20 : 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: isDesktop ? 12 : 8),
                        Text(
                          'Agrega productos a este proveedor para comenzar',
                          style: TextStyle(
                            fontSize: isDesktop ? 16 : 14,
                            color: Colors.grey[500],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: isDesktop ? 32 : 24),
                        ElevatedButton.icon(
                          onPressed: () => _navigateToEditForm(null),
                          icon: const Icon(Icons.add),
                          label: const Text('Agregar Producto'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 24 : 20,
                              vertical: isDesktop ? 16 : 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(isDesktop ? 24 : 16),
                  itemCount: state.supplierProducts.length,
                  itemBuilder: (context, index) {
                    final supplierProduct = state.supplierProducts[index];
                    return _buildSupplierProductCard(
                      supplierProduct,
                      isDesktop,
                      isTablet,
                    );
                  },
                );
              }

              if (state is SupplierProductError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: isDesktop ? 80 : 64,
                        color: Colors.red,
                      ),
                      SizedBox(height: isDesktop ? 24 : 16),
                      Text(
                        'Error al cargar productos',
                        style: TextStyle(
                          fontSize: isDesktop ? 20 : 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.red.shade700,
                        ),
                      ),
                      SizedBox(height: isDesktop ? 12 : 8),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isDesktop ? 48 : 32,
                        ),
                        child: Text(
                          state.message,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isDesktop ? 16 : 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      SizedBox(height: isDesktop ? 32 : 24),
                      ElevatedButton.icon(
                        onPressed: () => context
                            .read<SupplierProductCubit>()
                            .loadSupplierProducts(widget.supplierId),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Reintentar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade700,
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
          onPressed: () => _navigateToEditForm(null),
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: Text(isDesktop ? 'Agregar Producto' : 'Agregar'),
        ),
      ),
    );
  }
}

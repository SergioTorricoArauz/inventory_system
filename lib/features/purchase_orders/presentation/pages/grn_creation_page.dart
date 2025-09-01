import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/purchase_order.dart';
import '../../domain/entities/good_receipt_note.dart';
import '../cubit/grn_cubit.dart';
import '../cubit/grn_state.dart';
import '../widgets/grn_product_item.dart';
import '../../../../injection_container.dart' as di;

class GrnCreationPage extends StatelessWidget {
  final PurchaseOrder purchaseOrder;

  const GrnCreationPage({super.key, required this.purchaseOrder});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => di.sl<GrnCubit>()..initializeGrn(purchaseOrder),
      child: _GrnCreationView(purchaseOrder: purchaseOrder),
    );
  }
}

class _GrnCreationView extends StatelessWidget {
  final PurchaseOrder purchaseOrder;

  const _GrnCreationView({required this.purchaseOrder});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Recibir Mercancía',
          style: TextStyle(fontSize: isTablet ? 20 : 18),
        ),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          BlocBuilder<GrnCubit, GrnState>(
            builder: (context, state) {
              if (state is GrnInProgress) {
                return Padding(
                  padding: EdgeInsets.only(right: isTablet ? 16 : 8),
                  child: TextButton.icon(
                    onPressed: state.canSave ? () => _saveGrn(context) : null,
                    icon: const Icon(Icons.save, color: Colors.white),
                    label: Text(
                      'Guardar',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isTablet ? 16 : 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocListener<GrnCubit, GrnState>(
        listener: (context, state) {
          if (state is GrnSaved) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Recepción guardada exitosamente',
                  style: TextStyle(fontSize: isTablet ? 16 : 14),
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(isTablet ? 16 : 8),
              ),
            );
            Navigator.of(context).pop(true);
          } else if (state is GrnError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Error: ${state.message}',
                  style: TextStyle(fontSize: isTablet ? 16 : 14),
                ),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                margin: EdgeInsets.all(isTablet ? 16 : 8),
              ),
            );
          }
        },
        child: BlocBuilder<GrnCubit, GrnState>(
          builder: (context, state) {
            if (state is GrnLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GrnInProgress) {
              return _GrnContent(purchaseOrder: purchaseOrder, grn: state.grn);
            } else if (state is GrnError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(
                    isDesktop
                        ? 48
                        : isTablet
                        ? 32
                        : 24,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(isTablet ? 24 : 16),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.error_outline,
                          size: isDesktop
                              ? 80
                              : isTablet
                              ? 64
                              : 48,
                          color: Colors.red.shade400,
                        ),
                      ),
                      SizedBox(height: isTablet ? 24 : 16),
                      Text(
                        'Error al inicializar recepción',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontSize: isDesktop
                                  ? 24
                                  : isTablet
                                  ? 20
                                  : 18,
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: isTablet ? 12 : 8),
                      Container(
                        constraints: BoxConstraints(
                          maxWidth: isDesktop ? 500 : double.infinity,
                        ),
                        child: Text(
                          state.message,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
                                fontSize: isTablet ? 16 : 14,
                                color: Colors.grey.shade600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: isTablet ? 32 : 24),
                      SizedBox(
                        width: isDesktop
                            ? 200
                            : isTablet
                            ? 160
                            : 140,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            context.read<GrnCubit>().initializeGrn(
                              purchaseOrder,
                            );
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 16 : 12,
                              horizontal: isTablet ? 24 : 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _saveGrn(BuildContext context) {
    context.read<GrnCubit>().saveGrn();
  }
}

class _GrnContent extends StatefulWidget {
  final PurchaseOrder purchaseOrder;
  final GoodReceiptNote grn;

  const _GrnContent({required this.purchaseOrder, required this.grn});

  @override
  State<_GrnContent> createState() => _GrnContentState();
}

class _GrnContentState extends State<_GrnContent> {
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _notesController.text = widget.grn.notes;
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con información de la orden
          _HeaderCard(purchaseOrder: widget.purchaseOrder),

          const SizedBox(height: 16),

          // Lista de productos para recibir
          _ProductsSection(
            purchaseOrder: widget.purchaseOrder,
            grn: widget.grn,
          ),

          const SizedBox(height: 16),

          // Notas
          _NotesSection(
            controller: _notesController,
            onChanged: (notes) {
              context.read<GrnCubit>().updateNotes(notes);
            },
          ),

          const SizedBox(height: 16),

          // Botón de escaneo rápido
          _QuickScanButton(),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final PurchaseOrder purchaseOrder;

  const _HeaderCard({required this.purchaseOrder});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recepción de OC #${purchaseOrder.id}',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Icon(Icons.business, size: 16, color: Colors.grey.shade600),
                const SizedBox(width: 8),
                Text(
                  'Proveedor: ${purchaseOrder.supplierName}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),

            const SizedBox(height: 8),

            Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  'Fecha de Recepción: ${_formatDate(DateTime.now())}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _ProductsSection extends StatelessWidget {
  final PurchaseOrder purchaseOrder;
  final GoodReceiptNote grn;

  const _ProductsSection({required this.purchaseOrder, required this.grn});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Productos a Recibir',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            ...grn.lines.map((grnLine) {
              final poLine = purchaseOrder.lines.firstWhere(
                (line) => line.id == grnLine.purchaseOrderLineId,
              );

              return GrnProductItem(
                purchaseOrderLine: poLine,
                grnLine: grnLine,
                onQuantityChanged: (newQuantity) {
                  context.read<GrnCubit>().updateLineQuantity(
                    grnLine.purchaseOrderLineId,
                    newQuantity,
                  );
                },
                onScanned: (quantity) {
                  context.read<GrnCubit>().updateLineQuantity(
                    grnLine.purchaseOrderLineId,
                    grnLine.qtyReceived + quantity,
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _NotesSection extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _NotesSection({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notas de Recepción',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: controller,
              onChanged: onChanged,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Agregar notas sobre la recepción (opcional)...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickScanButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {
          // TODO: Implementar escaneo rápido
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Función de escaneo rápido en desarrollo'),
            ),
          );
        },
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Escaneo Rápido'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }
}

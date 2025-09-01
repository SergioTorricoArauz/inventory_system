import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../domain/entities/purchase_order_line.dart';
import '../../domain/entities/grn_line.dart';

class GrnProductItem extends StatefulWidget {
  final PurchaseOrderLine purchaseOrderLine;
  final GrnLine grnLine;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<int> onScanned;

  const GrnProductItem({
    super.key,
    required this.purchaseOrderLine,
    required this.grnLine,
    required this.onQuantityChanged,
    required this.onScanned,
  });

  @override
  State<GrnProductItem> createState() => _GrnProductItemState();
}

class _GrnProductItemState extends State<GrnProductItem> {
  late TextEditingController _quantityController;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.grnLine.qtyReceived.toString(),
    );
  }

  @override
  void didUpdateWidget(GrnProductItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.grnLine.qtyReceived != widget.grnLine.qtyReceived) {
      _quantityController.text = widget.grnLine.qtyReceived.toString();
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isComplete =
        widget.grnLine.qtyReceived >= widget.purchaseOrderLine.qtyOrdered;
    final hasDiscrepancy =
        widget.grnLine.qtyReceived != widget.purchaseOrderLine.qtyOrdered;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(
          color: isComplete ? Colors.green.shade300 : Colors.grey.shade300,
          width: isComplete ? 2 : 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: isComplete
            ? Colors.green.shade50
            : hasDiscrepancy
            ? Colors.orange.shade50
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header del producto
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.purchaseOrderLine.productName,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      if (widget.purchaseOrderLine.productBarcode?.isNotEmpty ==
                          true) ...[
                        const SizedBox(height: 4),
                        Text(
                          'Código: ${widget.purchaseOrderLine.productBarcode}',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: Colors.grey.shade600),
                        ),
                      ],
                    ],
                  ),
                ),

                // Estado visual
                if (isComplete)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.check, color: Colors.white, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          'Completo',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  )
                else if (hasDiscrepancy)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.warning,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Diferencia',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Información de cantidad
            Row(
              children: [
                // Cantidad pedida
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cantidad Pedida',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        widget.purchaseOrderLine.qtyOrdered.toString(),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                // Arrow
                Icon(Icons.arrow_forward, color: Colors.grey.shade400),

                // Cantidad recibida (editable)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Cantidad Recibida',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Botón -
                          IconButton(
                            onPressed: widget.grnLine.qtyReceived > 0
                                ? () => _updateQuantity(
                                    widget.grnLine.qtyReceived - 1,
                                  )
                                : null,
                            icon: const Icon(Icons.remove),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.grey.shade200,
                              foregroundColor: Colors.grey.shade700,
                            ),
                          ),

                          // Campo de cantidad
                          SizedBox(
                            width: 80,
                            child: TextField(
                              controller: _quantityController,
                              focusNode: _focusNode,
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d*'),
                                ),
                              ],
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 12,
                                ),
                              ),
                              onSubmitted: (value) {
                                final quantity = int.tryParse(value) ?? 0;
                                _updateQuantity(quantity);
                              },
                              onEditingComplete: () {
                                final quantity =
                                    int.tryParse(_quantityController.text) ?? 0;
                                _updateQuantity(quantity);
                                _focusNode.unfocus();
                              },
                            ),
                          ),

                          // Botón +
                          IconButton(
                            onPressed: () =>
                                _updateQuantity(widget.grnLine.qtyReceived + 1),
                            icon: const Icon(Icons.add),
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.blue.shade100,
                              foregroundColor: Colors.blue.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Botones de acción
            Row(
              children: [
                // Botón de escaneo
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showScanDialog(),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Escanear'),
                  ),
                ),

                const SizedBox(width: 12),

                // Botón de cantidad completa
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed:
                        widget.grnLine.qtyReceived <
                            widget.purchaseOrderLine.qtyOrdered
                        ? () => _updateQuantity(
                            widget.purchaseOrderLine.qtyOrdered,
                          )
                        : null,
                    icon: const Icon(Icons.done_all),
                    label: const Text('Completo'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _updateQuantity(int quantity) {
    // Validar que no sea negativa
    final validQuantity = quantity < 0 ? 0 : quantity;

    // Actualizar el controller
    _quantityController.text = validQuantity.toString();

    // Notificar el cambio
    widget.onQuantityChanged(validQuantity);
  }

  void _showScanDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escanear Producto'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Escanee el código del producto: ${widget.purchaseOrderLine.productName}',
            ),
            const SizedBox(height: 16),
            const Text('Función de escaneo en desarrollo'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Simular escaneo exitoso agregando 1
              widget.onScanned(1);
              Navigator.of(context).pop();
            },
            child: const Text('Simular Escaneo'),
          ),
        ],
      ),
    );
  }
}

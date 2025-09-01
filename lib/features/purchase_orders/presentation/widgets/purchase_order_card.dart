import 'package:flutter/material.dart';
import '../../domain/entities/purchase_order.dart';

class PurchaseOrderCard extends StatelessWidget {
  final PurchaseOrder purchaseOrder;
  final VoidCallback onTap;
  final VoidCallback? onReceive;

  const PurchaseOrderCard({
    super.key,
    required this.purchaseOrder,
    required this.onTap,
    this.onReceive,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : 16,
        vertical: 8,
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isDesktop ? 24 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header con número y estado - Responsive
              if (isTablet)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'OC #${purchaseOrder.id}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: isDesktop ? 22 : null,
                        ),
                      ),
                    ),
                    _StatusChip(
                      status: purchaseOrder.status,
                      isLarge: isDesktop,
                    ),
                  ],
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OC #${purchaseOrder.id}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: _StatusChip(status: purchaseOrder.status),
                    ),
                  ],
                ),

              const SizedBox(height: 12),

              // Información del proveedor y fecha - Responsive
              if (isTablet)
                Row(
                  children: [
                    Expanded(
                      child: _infoRow(
                        icon: Icons.business,
                        text: 'Proveedor: ${purchaseOrder.supplierName}',
                        context: context,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _infoRow(
                        icon: Icons.calendar_today,
                        text: 'Fecha: ${_formatDate(purchaseOrder.createdAt)}',
                        context: context,
                      ),
                    ),
                  ],
                )
              else
                Column(
                  children: [
                    _infoRow(
                      icon: Icons.business,
                      text: 'Proveedor: ${purchaseOrder.supplierName}',
                      context: context,
                    ),
                    const SizedBox(height: 8),
                    _infoRow(
                      icon: Icons.calendar_today,
                      text: 'Fecha: ${_formatDate(purchaseOrder.createdAt)}',
                      context: context,
                    ),
                  ],
                ),

              const SizedBox(height: 8),

              // Total y cantidad de productos - Responsive
              if (isTablet)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoRow(
                      icon: Icons.inventory_2,
                      text: '${purchaseOrder.lines.length} productos',
                      context: context,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '\$${(purchaseOrder.total / 100).toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700,
                              fontSize: isDesktop ? 18 : null,
                            ),
                      ),
                    ),
                  ],
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoRow(
                      icon: Icons.inventory_2,
                      text: '${purchaseOrder.lines.length} productos',
                      context: context,
                    ),
                    Text(
                      '\$${(purchaseOrder.total / 100).toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),

              // Notas si existen
              if (purchaseOrder.notes.isNotEmpty) ...[
                const SizedBox(height: 8),
                _infoRow(
                  icon: Icons.note,
                  text: purchaseOrder.notes,
                  context: context,
                  maxLines: isTablet ? 3 : 2,
                ),
              ],

              // Botón de recepción si está disponible
              if (onReceive != null) ...[
                SizedBox(height: isDesktop ? 16 : 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: onReceive,
                    icon: const Icon(Icons.inventory),
                    label: const Text('Recibir Mercancía'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.green.shade700,
                      side: BorderSide(color: Colors.green.shade700),
                      padding: EdgeInsets.symmetric(
                        vertical: isDesktop ? 16 : 12,
                        horizontal: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String text,
    required BuildContext context,
    int maxLines = 1,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }
}

class _StatusChip extends StatelessWidget {
  final PurchaseOrderStatus status;
  final bool isLarge;

  const _StatusChip({required this.status, this.isLarge = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 16 : 12,
        vertical: isLarge ? 8 : 6,
      ),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getStatusColor(status), width: 1),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          color: _getStatusColor(status),
          fontWeight: FontWeight.w600,
          fontSize: isLarge ? 14 : 12,
        ),
      ),
    );
  }

  Color _getStatusColor(PurchaseOrderStatus status) {
    switch (status) {
      case PurchaseOrderStatus.ordered:
        return Colors.blue;
      case PurchaseOrderStatus.received:
        return Colors.orange;
      case PurchaseOrderStatus.cancelled:
        return Colors.red;
      case PurchaseOrderStatus.finalized:
        return Colors.green;
    }
  }
}

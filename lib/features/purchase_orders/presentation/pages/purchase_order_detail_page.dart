import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/purchase_order.dart';
import '../../domain/entities/purchase_order_line.dart';
import '../../domain/entities/good_receipt_note.dart';
import '../cubit/purchase_order_detail_cubit.dart';
import '../cubit/grn_cubit.dart';
import '../cubit/purchase_order_detail_state.dart';
import '../cubit/grn_state.dart';
import 'grn_creation_page.dart';
import 'grn_detail_page.dart';
import '../../../../injection_container.dart' as di;

class PurchaseOrderDetailPage extends StatelessWidget {
  final String purchaseOrderId;

  const PurchaseOrderDetailPage({super.key, required this.purchaseOrderId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              di.sl<PurchaseOrderDetailCubit>()
                ..loadPurchaseOrder(purchaseOrderId),
        ),
        BlocProvider(
          create: (context) =>
              di.sl<GrnCubit>()..loadGrnsByPurchaseOrderId(purchaseOrderId),
        ),
      ],
      child: _PurchaseOrderDetailView(purchaseOrderId: purchaseOrderId),
    );
  }
}

class _PurchaseOrderDetailView extends StatefulWidget {
  final String purchaseOrderId;

  const _PurchaseOrderDetailView({required this.purchaseOrderId});

  @override
  State<_PurchaseOrderDetailView> createState() =>
      _PurchaseOrderDetailViewState();
}

class _PurchaseOrderDetailViewState extends State<_PurchaseOrderDetailView> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    return BlocBuilder<PurchaseOrderDetailCubit, PurchaseOrderDetailState>(
      builder: (context, state) {
        if (state is PurchaseOrderDetailLoading) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Detalle de OC'),
              backgroundColor: Colors.purple.shade700,
              foregroundColor: Colors.white,
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        } else if (state is PurchaseOrderDetailError) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Detalle de OC'),
              backgroundColor: Colors.purple.shade700,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: isDesktop ? 80 : 64,
                    color: Colors.red.shade400,
                  ),
                  SizedBox(height: isTablet ? 20 : 16),
                  Text(
                    'Error al cargar la orden',
                    style: TextStyle(
                      fontSize: isDesktop ? 22 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red.shade700,
                    ),
                  ),
                  SizedBox(height: isTablet ? 12 : 8),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isDesktop ? 48 : 24,
                    ),
                    child: Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: isTablet ? 16 : 14,
                      ),
                    ),
                  ),
                  SizedBox(height: isTablet ? 32 : 24),
                  ElevatedButton(
                    onPressed: () => context
                        .read<PurchaseOrderDetailCubit>()
                        .loadPurchaseOrder(widget.purchaseOrderId),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            ),
          );
        } else if (state is PurchaseOrderDetailLoaded) {
          return _buildDetailPage(
            context,
            state.purchaseOrder,
            isTablet,
            isDesktop,
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildDetailPage(
    BuildContext context,
    PurchaseOrder purchaseOrder,
    bool isTablet,
    bool isDesktop,
  ) {
    return Scaffold(
      appBar: _buildAppBar(context, purchaseOrder, isTablet, isDesktop),
      body: _buildBody(context, purchaseOrder, isTablet, isDesktop),
      floatingActionButton: _buildFloatingActionButton(
        context,
        purchaseOrder,
        isTablet,
        isDesktop,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    PurchaseOrder purchaseOrder,
    bool isTablet,
    bool isDesktop,
  ) {
    return AppBar(
      title: Text(
        'OC #${purchaseOrder.id}',
        style: TextStyle(fontSize: isDesktop ? 22 : 18),
      ),
      backgroundColor: Colors.purple.shade700,
      foregroundColor: Colors.white,
      actions: [
        if (isDesktop && purchaseOrder.canReceive)
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ElevatedButton.icon(
              onPressed: () => _navigateToReceive(context, purchaseOrder),
              icon: const Icon(Icons.inventory),
              label: const Text('Recibir'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                foregroundColor: Colors.white,
              ),
            ),
          ),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            context.read<PurchaseOrderDetailCubit>().loadPurchaseOrder(
              widget.purchaseOrderId,
            );
            context.read<GrnCubit>().loadGrnsByPurchaseOrderId(
              widget.purchaseOrderId,
            );
          },
        ),
      ],
    );
  }

  Widget _buildBody(
    BuildContext context,
    PurchaseOrder purchaseOrder,
    bool isTablet,
    bool isDesktop,
  ) {
    if (isDesktop) {
      // Layout de escritorio - dos paneles
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Panel izquierdo - Líneas de la orden
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  _buildHeader(purchaseOrder, true),
                  const SizedBox(height: 24),
                  _buildStatusBanner(purchaseOrder, true),
                  const SizedBox(height: 24),
                  _buildLinesSection(purchaseOrder, true),
                ],
              ),
            ),
          ),

          const VerticalDivider(width: 1),

          // Panel derecho - Historial de recepciones
          Expanded(
            child: Container(
              height: double.infinity,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.purple.shade50,
                      border: Border(
                        bottom: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.receipt_long, color: Colors.purple.shade700),
                        const SizedBox(width: 12),
                        Text(
                          'Historial de Recepciones',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: _buildReceiptsHistory(true)),
                ],
              ),
            ),
          ),
        ],
      );
    } else {
      // Layout móvil/tablet - una columna
      return SingleChildScrollView(
        padding: EdgeInsets.all(isTablet ? 20 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(purchaseOrder, isTablet),
            SizedBox(height: isTablet ? 20 : 16),
            _buildStatusBanner(purchaseOrder, isTablet),
            SizedBox(height: isTablet ? 20 : 16),
            _buildLinesSection(purchaseOrder, isTablet),
            SizedBox(height: isTablet ? 20 : 16),
            _buildReceiptsHistoryCard(isTablet),
          ],
        ),
      );
    }
  }

  Widget? _buildFloatingActionButton(
    BuildContext context,
    PurchaseOrder purchaseOrder,
    bool isTablet,
    bool isDesktop,
  ) {
    // Solo mostrar FAB en móvil si puede recibir
    if (!isDesktop && purchaseOrder.canReceive) {
      return FloatingActionButton.extended(
        onPressed: () => _navigateToReceive(context, purchaseOrder),
        icon: const Icon(Icons.inventory),
        label: const Text('Recibir'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
      );
    }
    return null;
  }

  // Encabezado con información de la OC
  Widget _buildHeader(PurchaseOrder purchaseOrder, bool isLarge) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isLarge ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'OC #${purchaseOrder.id}',
                        style: TextStyle(
                          fontSize: isLarge ? 28 : 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        purchaseOrder.supplierName,
                        style: TextStyle(
                          fontSize: isLarge ? 20 : 18,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusChip(status: purchaseOrder.status, isLarge: isLarge),
              ],
            ),

            SizedBox(height: isLarge ? 20 : 16),

            Row(
              children: [
                Expanded(
                  child: _InfoItem(
                    icon: Icons.location_on,
                    label: 'Sucursal',
                    value: 'Principal', // Esto vendría de la API
                    isLarge: isLarge,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _InfoItem(
                    icon: Icons.calendar_today,
                    label: 'Fecha Esperada',
                    value: _formatDate(purchaseOrder.expectedDate),
                    isLarge: isLarge,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Banner de estado para OC canceladas/finalizadas
  Widget _buildStatusBanner(PurchaseOrder purchaseOrder, bool isLarge) {
    if (purchaseOrder.status == PurchaseOrderStatus.cancelled ||
        purchaseOrder.status == PurchaseOrderStatus.finalized) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.all(isLarge ? 20 : 16),
        decoration: BoxDecoration(
          color: purchaseOrder.status == PurchaseOrderStatus.cancelled
              ? Colors.red.shade50
              : Colors.green.shade50,
          border: Border.all(
            color: purchaseOrder.status == PurchaseOrderStatus.cancelled
                ? Colors.red.shade300
                : Colors.green.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              purchaseOrder.status == PurchaseOrderStatus.cancelled
                  ? Icons.cancel
                  : Icons.check_circle,
              color: purchaseOrder.status == PurchaseOrderStatus.cancelled
                  ? Colors.red.shade600
                  : Colors.green.shade600,
              size: isLarge ? 28 : 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Esta OC está ${purchaseOrder.status.displayName}. No admite recepciones.',
                style: TextStyle(
                  fontSize: isLarge ? 16 : 14,
                  fontWeight: FontWeight.w500,
                  color: purchaseOrder.status == PurchaseOrderStatus.cancelled
                      ? Colors.red.shade700
                      : Colors.green.shade700,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  // Tabla/Lista de líneas de productos
  Widget _buildLinesSection(PurchaseOrder purchaseOrder, bool isLarge) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isLarge ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Productos (${purchaseOrder.lines.length})',
              style: TextStyle(
                fontSize: isLarge ? 22 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isLarge ? 20 : 16),
            ...purchaseOrder.lines.map((line) => _buildLineItem(line, isLarge)),
          ],
        ),
      ),
    );
  }

  Widget _buildLineItem(PurchaseOrderLine line, bool isLarge) {
    return Container(
      margin: EdgeInsets.only(bottom: isLarge ? 16 : 12),
      padding: EdgeInsets.all(isLarge ? 16 : 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Nombre del producto y código de barras
          Text(
            line.productName,
            style: TextStyle(
              fontSize: isLarge ? 18 : 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (line.productBarcode?.isNotEmpty == true) ...[
            SizedBox(height: isLarge ? 6 : 4),
            Text(
              'Código: ${line.productBarcode}',
              style: TextStyle(
                fontSize: isLarge ? 14 : 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],

          SizedBox(height: isLarge ? 16 : 12),

          // Cantidades: Ordenado - Recibido - Pendiente
          Row(
            children: [
              Expanded(
                child: _buildQuantityInfo(
                  'Ordenado',
                  line.qtyOrdered.toString(),
                  Colors.blue,
                  isLarge,
                ),
              ),
              Expanded(
                child: _buildQuantityInfo(
                  'Recibido',
                  line.qtyReceived.toString(),
                  Colors.green,
                  isLarge,
                ),
              ),
              Expanded(
                child: _buildQuantityInfo(
                  'Pendiente',
                  line.qtyPending.toString(),
                  line.qtyPending > 0 ? Colors.orange : Colors.grey,
                  isLarge,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityInfo(
    String label,
    String value,
    Color color,
    bool isLarge,
  ) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isLarge ? 12 : 10,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: isLarge ? 12 : 8,
            vertical: isLarge ? 8 : 6,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: isLarge ? 16 : 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
      ],
    );
  }

  // Historial de recepciones para móvil/tablet
  Widget _buildReceiptsHistoryCard(bool isLarge) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(isLarge ? 24 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.receipt_long, color: Colors.purple.shade700),
                const SizedBox(width: 8),
                Text(
                  'Historial de Recepciones',
                  style: TextStyle(
                    fontSize: isLarge ? 20 : 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade700,
                  ),
                ),
              ],
            ),
            SizedBox(height: isLarge ? 16 : 12),
            SizedBox(
              height: 300, // Altura fija para la lista
              child: _buildReceiptsHistory(isLarge),
            ),
          ],
        ),
      ),
    );
  }

  // Lista de recepciones
  Widget _buildReceiptsHistory(bool isLarge) {
    return BlocBuilder<GrnCubit, GrnState>(
      builder: (context, state) {
        if (state is GrnLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is GrnError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: isLarge ? 48 : 40,
                  color: Colors.red.shade400,
                ),
                SizedBox(height: isLarge ? 16 : 12),
                Text(
                  'Error al cargar recepciones',
                  style: TextStyle(
                    fontSize: isLarge ? 16 : 14,
                    color: Colors.red.shade700,
                  ),
                ),
                SizedBox(height: isLarge ? 12 : 8),
                ElevatedButton(
                  onPressed: () => context
                      .read<GrnCubit>()
                      .loadGrnsByPurchaseOrderId(widget.purchaseOrderId),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        } else if (state is GrnListLoaded) {
          if (state.grns.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: isLarge ? 64 : 48,
                    color: Colors.grey.shade400,
                  ),
                  SizedBox(height: isLarge ? 16 : 12),
                  Text(
                    'No hay recepciones registradas',
                    style: TextStyle(
                      fontSize: isLarge ? 16 : 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: state.grns.length,
            itemBuilder: (context, index) {
              final grn = state.grns[index];
              return _buildGrnItem(grn, isLarge);
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildGrnItem(GoodReceiptNote grn, bool isLarge) {
    return Card(
      margin: EdgeInsets.only(bottom: isLarge ? 12 : 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(isLarge ? 16 : 12),
        leading: Container(
          width: isLarge ? 48 : 40,
          height: isLarge ? 48 : 40,
          decoration: BoxDecoration(
            color: Colors.green.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.receipt,
            color: Colors.green.shade700,
            size: isLarge ? 24 : 20,
          ),
        ),
        title: Text(
          'GRN #${grn.referenceNumber}',
          style: TextStyle(
            fontSize: isLarge ? 16 : 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: isLarge ? 6 : 4),
            Text(
              '${_formatDateTime(grn.receivedAt)} · ${grn.receivedBy}',
              style: TextStyle(fontSize: isLarge ? 14 : 12),
            ),
            SizedBox(height: isLarge ? 4 : 2),
            Text(
              '${grn.totalUnits} unidades totales',
              style: TextStyle(
                fontSize: isLarge ? 14 : 12,
                color: Colors.green.shade700,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: isLarge ? 20 : 16,
          color: Colors.grey.shade400,
        ),
        onTap: () => _navigateToGrnDetail(grn),
      ),
    );
  }

  // Navegación
  void _navigateToReceive(BuildContext context, PurchaseOrder purchaseOrder) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GrnCreationPage(purchaseOrder: purchaseOrder),
      ),
    ).then((result) {
      if (result == true && mounted) {
        // Recargar datos
        context.read<PurchaseOrderDetailCubit>().loadPurchaseOrder(
          widget.purchaseOrderId,
        );
        context.read<GrnCubit>().loadGrnsByPurchaseOrderId(
          widget.purchaseOrderId,
        );
      }
    });
  }

  void _navigateToGrnDetail(GoodReceiptNote grn) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => GrnDetailPage(grn: grn)),
    );
  }

  // Formateo de fechas
  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatDateTime(DateTime date) {
    return '${_formatDate(date)} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

// Widgets auxiliares
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

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLarge;

  const _InfoItem({
    required this.icon,
    required this.label,
    required this.value,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: isLarge ? 20 : 16, color: Colors.grey.shade600),
            SizedBox(width: isLarge ? 8 : 6),
            Text(
              label,
              style: TextStyle(
                fontSize: isLarge ? 14 : 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: isLarge ? 6 : 4),
        Text(
          value,
          style: TextStyle(
            fontSize: isLarge ? 16 : 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

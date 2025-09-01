import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/purchase_order.dart';
import '../cubit/purchase_order_cubit.dart';
import '../cubit/purchase_order_state.dart';
import '../cubit/purchase_order_detail_cubit.dart';
import '../widgets/purchase_order_card.dart';
import '../widgets/purchase_order_filter_chips.dart';
import 'purchase_order_detail_page.dart';
import 'grn_creation_page.dart';
import '../../../../injection_container.dart' as di;

class PurchaseOrderListPage extends StatefulWidget {
  const PurchaseOrderListPage({super.key});

  @override
  State<PurchaseOrderListPage> createState() => _PurchaseOrderListPageState();
}

class _PurchaseOrderListPageState extends State<PurchaseOrderListPage> {
  PurchaseOrderStatus? _selectedStatus;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<PurchaseOrderCubit>().loadPurchaseOrders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onFilterChanged(PurchaseOrderStatus? status) {
    setState(() {
      _selectedStatus = status;
    });
    context.read<PurchaseOrderCubit>().loadPurchaseOrders(status: status);
  }

  void _onSearchChanged(String query) {}

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Órdenes de Compra'),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context
                .read<PurchaseOrderCubit>()
                .refreshPurchaseOrders(status: _selectedStatus),
          ),
        ],
      ),
      body: Column(
        children: [
          // Barra de búsqueda - Responsiva
          Container(
            padding: EdgeInsets.all(isDesktop ? 24 : 16),
            color: Colors.purple.shade50,
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Buscar por Nº OC, proveedor...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.qr_code_scanner),
                  onPressed: () {},
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 20 : 16,
                  vertical: isTablet ? 16 : 12,
                ),
              ),
              style: TextStyle(fontSize: isTablet ? 16 : 14),
            ),
          ),

          // Filtros por estado
          PurchaseOrderFilterChips(
            selectedStatus: _selectedStatus,
            onStatusChanged: _onFilterChanged,
          ),

          // Lista de órdenes - Responsiva
          Expanded(
            child: BlocBuilder<PurchaseOrderCubit, PurchaseOrderState>(
              builder: (context, state) {
                if (state is PurchaseOrderLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is PurchaseOrderLoaded) {
                  if (state.purchaseOrders.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: isDesktop ? 80 : 64,
                            color: Colors.grey.shade400,
                          ),
                          SizedBox(height: isTablet ? 20 : 16),
                          Text(
                            'No hay órdenes de compra',
                            style: TextStyle(
                              fontSize: isDesktop ? 22 : 18,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          SizedBox(height: isTablet ? 12 : 8),
                          Text(
                            _selectedStatus != null
                                ? 'con estado ${_selectedStatus!.displayName}'
                                : '',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: isTablet ? 16 : 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<PurchaseOrderCubit>().refreshPurchaseOrders(
                        status: _selectedStatus,
                      );
                    },
                    child: isDesktop
                        ? _buildDesktopGrid(state.purchaseOrders)
                        : _buildMobileList(state.purchaseOrders),
                  );
                } else if (state is PurchaseOrderError) {
                  return Center(
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
                          'Error al cargar órdenes',
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
                        ElevatedButton.icon(
                          onPressed: () => context
                              .read<PurchaseOrderCubit>()
                              .loadPurchaseOrders(status: _selectedStatus),
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple.shade700,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              horizontal: isTablet ? 32 : 24,
                              vertical: isTablet ? 16 : 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  // Layout responsivo para desktop - Grid
  Widget _buildDesktopGrid(List<PurchaseOrder> orders) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 1.8,
      ),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final po = orders[index];
        return PurchaseOrderCard(
          purchaseOrder: po,
          onTap: () => _navigateToDetail(po),
          onReceive: po.canReceive ? () => _navigateToReceive(po) : null,
        );
      },
    );
  }

  // Layout para móvil/tablet - Lista vertical
  Widget _buildMobileList(List<PurchaseOrder> orders) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return ListView.builder(
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final po = orders[index];
        return PurchaseOrderCard(
          purchaseOrder: po,
          onTap: () => _navigateToDetail(po),
          onReceive: po.canReceive ? () => _navigateToReceive(po) : null,
        );
      },
    );
  }

  void _navigateToDetail(PurchaseOrder po) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => di.sl<PurchaseOrderDetailCubit>(),
          child: PurchaseOrderDetailPage(purchaseOrderId: po.id),
        ),
      ),
    );
  }

  void _navigateToReceive(PurchaseOrder po) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GrnCreationPage(purchaseOrder: po),
      ),
    ).then((result) {
      if (result == true && mounted) {
        // Recargar la lista para actualizar el estado
        context.read<PurchaseOrderCubit>().refreshPurchaseOrders(
          status: _selectedStatus,
        );
      }
    });
  }
}

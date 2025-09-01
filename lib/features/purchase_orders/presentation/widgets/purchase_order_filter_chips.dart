import 'package:flutter/material.dart';
import '../../domain/entities/purchase_order.dart';

class PurchaseOrderFilterChips extends StatelessWidget {
  final PurchaseOrderStatus? selectedStatus;
  final ValueChanged<PurchaseOrderStatus?> onStatusChanged;

  const PurchaseOrderFilterChips({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 24 : 16,
        vertical: isTablet ? 12 : 8,
      ),
      child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(isTablet),
    );
  }

  // Layout para desktop - Centrado con mayor espaciado
  Widget _buildDesktopLayout() {
    return Center(
      child: Wrap(
        spacing: 16,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: [
          // Chip "Todos"
          _buildFilterChip(
            label: 'Todos',
            isSelected: selectedStatus == null,
            onSelected: () => onStatusChanged(null),
            color: Colors.purple,
            isLarge: true,
          ),

          // Chips por cada estado
          ...PurchaseOrderStatus.values.map(
            (status) => _buildFilterChip(
              label: status.displayName,
              isSelected: selectedStatus == status,
              onSelected: () => onStatusChanged(status),
              color: _getStatusColor(status),
              isLarge: true,
            ),
          ),
        ],
      ),
    );
  }

  // Layout para móvil/tablet - Scroll horizontal
  Widget _buildMobileLayout(bool isTablet) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          // Chip "Todos"
          Padding(
            padding: EdgeInsets.only(right: isTablet ? 12 : 8),
            child: _buildFilterChip(
              label: 'Todos',
              isSelected: selectedStatus == null,
              onSelected: () => onStatusChanged(null),
              color: Colors.purple,
              isLarge: isTablet,
            ),
          ),

          // Chips por cada estado
          ...PurchaseOrderStatus.values.map(
            (status) => Padding(
              padding: EdgeInsets.only(right: isTablet ? 12 : 8),
              child: _buildFilterChip(
                label: status.displayName,
                isSelected: selectedStatus == status,
                onSelected: () => onStatusChanged(status),
                color: _getStatusColor(status),
                isLarge: isTablet,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget reutilizable para los chips de filtro
  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onSelected,
    required Color color,
    bool isLarge = false,
  }) {
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: isLarge ? 14 : 12,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      selected: isSelected,
      onSelected: (_) => onSelected(),
      selectedColor: color.withValues(alpha: 0.2),
      checkmarkColor: color,
      side: BorderSide(color: color, width: isSelected ? 2 : 1),
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 16 : 12,
        vertical: isLarge ? 8 : 6,
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: isLarge
          ? VisualDensity.comfortable
          : VisualDensity.compact,
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

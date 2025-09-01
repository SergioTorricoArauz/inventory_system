import 'package:flutter/material.dart';
import '../../domain/entities/purchase_order.dart';

class PurchaseOrderEditPage extends StatelessWidget {
  final PurchaseOrder purchaseOrder;

  const PurchaseOrderEditPage({super.key, required this.purchaseOrder});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar Orden de Compra',
          style: TextStyle(fontSize: isTablet ? 20 : 18),
        ),
        backgroundColor: Colors.purple.shade700,
        foregroundColor: Colors.white,
      ),
      body: Center(
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
              // Ícono responsivo
              Container(
                padding: EdgeInsets.all(
                  isDesktop
                      ? 32
                      : isTablet
                      ? 24
                      : 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.construction,
                  size: isDesktop
                      ? 80
                      : isTablet
                      ? 64
                      : 48,
                  color: Colors.orange.shade600,
                ),
              ),

              SizedBox(height: isTablet ? 24 : 16),

              // Título responsivo
              Text(
                'Función en Desarrollo',
                style: TextStyle(
                  fontSize: isDesktop
                      ? 32
                      : isTablet
                      ? 28
                      : 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: isTablet ? 16 : 8),

              // Descripción responsiva
              Container(
                constraints: BoxConstraints(
                  maxWidth: isDesktop
                      ? 600
                      : isTablet
                      ? 400
                      : double.infinity,
                ),
                child: Text(
                  'La edición de órdenes de compra estará disponible próximamente. '
                  'Mientras tanto, puedes crear nuevas órdenes desde el módulo de proveedores.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isDesktop
                        ? 18
                        : isTablet
                        ? 16
                        : 14,
                    color: Colors.grey.shade600,
                    height: 1.5,
                  ),
                ),
              ),

              SizedBox(height: isTablet ? 32 : 24),

              // Información de la orden actual
              Container(
                padding: EdgeInsets.all(isTablet ? 24 : 16),
                decoration: BoxDecoration(
                  color: Colors.purple.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple.shade200),
                ),
                child: Column(
                  children: [
                    Text(
                      'Orden Actual',
                      style: TextStyle(
                        fontSize: isTablet ? 18 : 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.purple.shade700,
                      ),
                    ),
                    SizedBox(height: isTablet ? 12 : 8),
                    Text(
                      'OC #${purchaseOrder.id}',
                      style: TextStyle(
                        fontSize: isDesktop
                            ? 20
                            : isTablet
                            ? 18
                            : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: isTablet ? 8 : 4),
                    Text(
                      'Proveedor: ${purchaseOrder.supplierName}',
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: isTablet ? 32 : 24),

              // Botón de regreso responsivo
              SizedBox(
                width: isDesktop
                    ? 200
                    : isTablet
                    ? 160
                    : 140,
                child: ElevatedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Regresar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade700,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      vertical: isTablet ? 16 : 12,
                      horizontal: isTablet ? 24 : 16,
                    ),
                    textStyle: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/supplier.dart';
import '../bloc/supplier_cubit.dart';
import '../bloc/supplier_state.dart';
import 'supplier_form_page.dart';
import 'supplier_contacts_page.dart';

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({super.key});

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  @override
  void initState() {
    super.initState();
    context.read<SupplierCubit>().loadSuppliers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Proveedores',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2E3B4E),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: () => context.read<SupplierCubit>().loadSuppliers(),
            tooltip: 'Recargar proveedores',
          ),
          IconButton(
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            onPressed: () => _navigateToAddSupplier(context),
            tooltip: 'Agregar proveedor',
          ),
        ],
      ),
      body: BlocBuilder<SupplierCubit, SupplierState>(
        builder: (context, state) {
          if (state is SupplierLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2E3B4E)),
              ),
            );
          }

          if (state is SupplierError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Error al cargar proveedores',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.read<SupplierCubit>().loadSuppliers(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reintentar'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2E3B4E),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          if (state is SuppliersLoaded) {
            if (state.suppliers.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildSuppliersList(context, state.suppliers);
          }

          return const SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddSupplier(context),
        backgroundColor: const Color(0xFF2E3B4E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.business_outlined, size: 80, color: Colors.grey[400]),
            const SizedBox(height: 24),
            Text(
              'No hay proveedores registrados',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Agrega tu primer proveedor para comenzar a gestionar tu inventario',
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () =>
                      context.read<SupplierCubit>().loadSuppliers(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Recargar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[600],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => _navigateToAddSupplier(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar Proveedor'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2E3B4E),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuppliersList(BuildContext context, List<Supplier> suppliers) {
    return RefreshIndicator(
      onRefresh: () => context.read<SupplierCubit>().loadSuppliers(),
      color: const Color(0xFF2E3B4E),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: suppliers.length,
        itemBuilder: (context, index) {
          final supplier = suppliers[index];
          return _buildSupplierCard(context, supplier);
        },
      ),
    );
  }

  Widget _buildSupplierCard(BuildContext context, Supplier supplier) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToSupplierContacts(context, supplier),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2E3B4E).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.business,
                      color: const Color(0xFF2E3B4E),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          supplier.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E3B4E),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'NIT: ${supplier.nitTaxId}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: supplier.isActive
                          ? Colors.green[100]
                          : Colors.red[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      supplier.isActive ? 'Activo' : 'Inactivo',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: supplier.isActive
                            ? Colors.green[800]
                            : Colors.red[800],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildInfoRow(Icons.location_on_outlined, supplier.address),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.payment_outlined,
                'Términos: ${supplier.paymentTerms}',
              ),
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.monetization_on_outlined,
                'Moneda: ${supplier.currency}',
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${supplier.contacts.length} contacto${supplier.contacts.length != 1 ? 's' : ''}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Color(0xFF2E3B4E),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _navigateToAddSupplier(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SupplierFormPage()),
    );

    // Reload suppliers when returning from form
    if (context.mounted) {
      context.read<SupplierCubit>().loadSuppliers();
    }
  }

  void _navigateToSupplierContacts(
    BuildContext context,
    Supplier supplier,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SupplierContactsPage(supplier: supplier),
      ),
    );

    // Reload suppliers when returning from contacts page
    if (context.mounted) {
      context.read<SupplierCubit>().loadSuppliers();
    }
  }
}

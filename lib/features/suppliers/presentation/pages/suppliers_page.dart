import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/supplier.dart';
import '../bloc/supplier_cubit.dart';
import '../bloc/supplier_state.dart';
import 'supplier_form_page.dart';
import 'supplier_contacts_page.dart';
import '../widgets/supplier_products_wrapper.dart';

class SuppliersPage extends StatefulWidget {
  const SuppliersPage({super.key});

  @override
  State<SuppliersPage> createState() => _SuppliersPageState();
}

class _SuppliersPageState extends State<SuppliersPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Todos';
  String _sortOrder = 'Nombre A-Z';

  @override
  void initState() {
    super.initState();
    context.read<SupplierCubit>().loadSuppliers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 768;
    final isDesktop = screenSize.width >= 1024;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Proveedores',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: isTablet ? 22 : 20,
          ),
        ),
        backgroundColor: Colors.blue.shade700,
        elevation: 0,
        toolbarHeight: isTablet ? 70 : 56,
        actions: [
          IconButton(
            icon: Icon(
              Icons.refresh_rounded,
              color: Colors.white,
              size: isTablet ? 28 : 24,
            ),
            onPressed: () => context.read<SupplierCubit>().loadSuppliers(),
            tooltip: 'Recargar proveedores',
          ),
          if (!isDesktop) ...[
            IconButton(
              icon: Icon(
                Icons.add_rounded,
                color: Colors.white,
                size: isTablet ? 28 : 24,
              ),
              onPressed: () => _navigateToAddSupplier(context),
              tooltip: 'Agregar proveedor',
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          _buildSearchAndFilters(context, isTablet, isDesktop),
          Expanded(
            child: BlocBuilder<SupplierCubit, SupplierState>(
              builder: (context, state) {
                if (state is SupplierLoading) {
                  return _buildLoadingState(isTablet);
                }

                if (state is SupplierError) {
                  return _buildErrorState(context, state.message, isTablet);
                }

                if (state is SuppliersLoaded) {
                  final filteredSuppliers = _getFilteredSuppliers(
                    state.suppliers,
                  );

                  if (filteredSuppliers.isEmpty) {
                    return _searchQuery.isNotEmpty
                        ? _buildNoResultsState(context, isTablet)
                        : _buildEmptyState(context, isTablet);
                  }

                  return _buildSuppliersList(
                    context,
                    filteredSuppliers,
                    isTablet,
                    isDesktop,
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isDesktop
          ? _buildDesktopFAB(context, isTablet)
          : _buildMobileFAB(context),
    );
  }

  Widget _buildSearchAndFilters(
    BuildContext context,
    bool isTablet,
    bool isDesktop,
  ) {
    return Container(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Buscador
          TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            style: TextStyle(fontSize: isTablet ? 16 : 14),
            decoration: InputDecoration(
              labelText: 'Buscar por nombre o NIT...',
              labelStyle: TextStyle(fontSize: isTablet ? 16 : 14),
              prefixIcon: Icon(
                Icons.search,
                size: isTablet ? 24 : 20,
                color: Colors.blue.shade700,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, size: isTablet ? 24 : 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isTablet ? 16 : 12,
                vertical: isTablet ? 16 : 12,
              ),
            ),
          ),

          SizedBox(height: isTablet ? 16 : 12),

          // Filtros
          isDesktop
              ? _buildDesktopFilters(isTablet)
              : _buildMobileFilters(isTablet),
        ],
      ),
    );
  }

  Widget _buildDesktopFilters(bool isTablet) {
    return Row(
      children: [
        Expanded(
          child: _buildFilterDropdown(
            'Estado:',
            _selectedFilter,
            ['Todos', 'Activos', 'Desactivados'],
            (value) => setState(() => _selectedFilter = value!),
            isTablet,
          ),
        ),
        SizedBox(width: isTablet ? 24 : 16),
        Expanded(
          child: _buildFilterDropdown(
            'Ordenar:',
            _sortOrder,
            ['Nombre A-Z', 'Nombre Z-A', 'Recientes'],
            (value) => setState(() => _sortOrder = value!),
            isTablet,
          ),
        ),
      ],
    );
  }

  Widget _buildMobileFilters(bool isTablet) {
    return Column(
      children: [
        _buildFilterDropdown(
          'Estado:',
          _selectedFilter,
          ['Todos', 'Activos', 'Desactivados'],
          (value) => setState(() => _selectedFilter = value!),
          isTablet,
        ),
        SizedBox(height: isTablet ? 12 : 8),
        _buildFilterDropdown(
          'Ordenar:',
          _sortOrder,
          ['Nombre A-Z', 'Nombre Z-A', 'Recientes'],
          (value) => setState(() => _sortOrder = value!),
          isTablet,
        ),
      ],
    );
  }

  Widget _buildFilterDropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
    bool isTablet,
  ) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(width: isTablet ? 12 : 8),
        Expanded(
          child: DropdownButtonFormField<String>(
            value: value,
            onChanged: onChanged,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: Colors.grey[800],
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: isTablet ? 12 : 8,
                vertical: isTablet ? 12 : 8,
              ),
            ),
            items: options.map((option) {
              return DropdownMenuItem<String>(
                value: option,
                child: Text(option),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(bool isTablet) {
    return ListView.builder(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      itemCount: 6,
      itemBuilder: (context, index) => _buildSkeletonCard(isTablet),
    );
  }

  Widget _buildSkeletonCard(bool isTablet) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: isTablet ? 48 : 40,
                    height: isTablet ? 48 : 40,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  SizedBox(width: isTablet ? 16 : 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: isTablet ? 20 : 16,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        SizedBox(height: isTablet ? 8 : 6),
                        Container(
                          height: isTablet ? 16 : 14,
                          width: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message, bool isTablet) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 32 : 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: isTablet ? 80 : 64,
              color: Colors.red[400],
            ),
            SizedBox(height: isTablet ? 24 : 16),
            Text(
              'Error al cargar proveedores',
              style: TextStyle(
                fontSize: isTablet ? 22 : 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: isTablet ? 12 : 8),
            Text(
              message,
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isTablet ? 32 : 24),
            ElevatedButton.icon(
              onPressed: () => context.read<SupplierCubit>().loadSuppliers(),
              icon: Icon(Icons.refresh, size: isTablet ? 24 : 20),
              label: Text(
                'Reintentar',
                style: TextStyle(fontSize: isTablet ? 16 : 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 24,
                  vertical: isTablet ? 16 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isTablet) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 48 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business_outlined,
              size: isTablet ? 120 : 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: isTablet ? 32 : 24),
            Text(
              'Aún no tienes proveedores',
              style: TextStyle(
                fontSize: isTablet ? 28 : 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: isTablet ? 16 : 12),
            Text(
              'Agrega tu primer proveedor para comenzar a gestionar tu inventario',
              style: TextStyle(
                fontSize: isTablet ? 18 : 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isTablet ? 48 : 32),
            ElevatedButton.icon(
              onPressed: () => _navigateToAddSupplier(context),
              icon: Icon(Icons.add, size: isTablet ? 24 : 20),
              label: Text(
                'Agregar Proveedor',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 32 : 24,
                  vertical: isTablet ? 20 : 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoResultsState(BuildContext context, bool isTablet) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isTablet ? 48 : 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: isTablet ? 80 : 64,
              color: Colors.grey[400],
            ),
            SizedBox(height: isTablet ? 24 : 16),
            Text(
              'No se encontraron resultados',
              style: TextStyle(
                fontSize: isTablet ? 22 : 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: isTablet ? 12 : 8),
            Text(
              'Intenta con diferentes términos de búsqueda o filtros',
              style: TextStyle(
                fontSize: isTablet ? 16 : 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isTablet ? 32 : 24),
            ElevatedButton.icon(
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedFilter = 'Todos';
                });
              },
              icon: Icon(Icons.clear_all, size: isTablet ? 20 : 18),
              label: Text(
                'Limpiar filtros',
                style: TextStyle(fontSize: isTablet ? 16 : 14),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[600],
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 24 : 20,
                  vertical: isTablet ? 16 : 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuppliersList(
    BuildContext context,
    List<Supplier> suppliers,
    bool isTablet,
    bool isDesktop,
  ) {
    return RefreshIndicator(
      onRefresh: () => context.read<SupplierCubit>().loadSuppliers(),
      color: Colors.blue.shade700,
      child: isDesktop
          ? _buildDesktopGrid(context, suppliers, isTablet)
          : _buildMobileList(context, suppliers, isTablet),
    );
  }

  Widget _buildDesktopGrid(
    BuildContext context,
    List<Supplier> suppliers,
    bool isTablet,
  ) {
    return GridView.builder(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: isTablet ? 24 : 16,
        mainAxisSpacing: isTablet ? 24 : 16,
        childAspectRatio: isTablet ? 2.2 : 2.0,
      ),
      itemCount: suppliers.length,
      itemBuilder: (context, index) {
        final supplier = suppliers[index];
        return _buildSupplierCard(context, supplier, isTablet, true);
      },
    );
  }

  Widget _buildMobileList(
    BuildContext context,
    List<Supplier> suppliers,
    bool isTablet,
  ) {
    return ListView.builder(
      padding: EdgeInsets.all(isTablet ? 24 : 16),
      itemCount: suppliers.length,
      itemBuilder: (context, index) {
        final supplier = suppliers[index];
        return _buildSupplierCard(context, supplier, isTablet, false);
      },
    );
  }

  Widget _buildSupplierCard(
    BuildContext context,
    Supplier supplier,
    bool isTablet,
    bool isDesktop,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: isDesktop ? 0 : (isTablet ? 16 : 12)),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _navigateToSupplierContacts(context, supplier),
          child: Padding(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header con nombre y estado
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(isTablet ? 12 : 8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade700.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.business,
                        color: Colors.blue.shade700,
                        size: isTablet ? 28 : 24,
                      ),
                    ),
                    SizedBox(width: isTablet ? 16 : 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            supplier.name,
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: isTablet ? 6 : 4),
                          Text(
                            'NIT: ${supplier.nitTaxId}',
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isTablet ? 12 : 8,
                        vertical: isTablet ? 8 : 4,
                      ),
                      decoration: BoxDecoration(
                        color: supplier.isActive
                            ? Colors.green[100]
                            : Colors.red[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        supplier.isActive ? 'Activo' : 'Inactivo',
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          fontWeight: FontWeight.w600,
                          color: supplier.isActive
                              ? Colors.green[800]
                              : Colors.red[800],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isTablet ? 16 : 12),

                // Información de contacto y chips
                if (supplier.address.isNotEmpty) ...[
                  _buildInfoRow(
                    Icons.location_on_outlined,
                    supplier.address,
                    isTablet,
                  ),
                  SizedBox(height: isTablet ? 10 : 8),
                ],

                _buildInfoRow(
                  Icons.payment_outlined,
                  'Términos: ${supplier.paymentTerms}',
                  isTablet,
                ),
                SizedBox(height: isTablet ? 10 : 8),

                _buildInfoRow(
                  Icons.monetization_on_outlined,
                  'Moneda: ${supplier.currency}',
                  isTablet,
                ),

                SizedBox(height: isTablet ? 16 : 12),

                // Chips de información
                Wrap(
                  spacing: isTablet ? 12 : 8,
                  runSpacing: isTablet ? 8 : 6,
                  children: [
                    if (supplier.contacts.isNotEmpty) ...[
                      _buildInfoChip(
                        Icons.person_outline,
                        '${supplier.contacts.length} contacto${supplier.contacts.length != 1 ? 's' : ''}',
                        Colors.blue,
                        isTablet,
                      ),
                    ],
                    _buildInfoChip(
                      Icons.inventory_2_outlined,
                      'Productos: ${supplier.productCount}',
                      Colors.orange,
                      isTablet,
                    ),
                  ],
                ),

                SizedBox(height: isTablet ? 12 : 8),

                // Botones de acción
                Row(
                  children: [
                    // Botón de productos
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            _navigateToSupplierProducts(context, supplier),
                        icon: Icon(
                          Icons.inventory_2_outlined,
                          size: isTablet ? 18 : 16,
                        ),
                        label: Text(
                          'Productos',
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade50,
                          foregroundColor: Colors.orange.shade700,
                          elevation: 0,
                          padding: EdgeInsets.symmetric(
                            vertical: isTablet ? 12 : 8,
                            horizontal: isTablet ? 16 : 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(color: Colors.orange.shade200),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: isTablet ? 12 : 8),
                    // Flecha de navegación a detalles
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            'Ver detalles',
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 12,
                              color: Colors.blue.shade700,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(width: isTablet ? 8 : 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: isTablet ? 16 : 14,
                            color: Colors.blue.shade700,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, bool isTablet) {
    return Row(
      children: [
        Icon(icon, size: isTablet ? 18 : 16, color: Colors.grey[600]),
        SizedBox(width: isTablet ? 8 : 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isTablet ? 14 : 13,
              color: Colors.grey[700],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoChip(
    IconData icon,
    String label,
    Color color,
    bool isTablet,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 12 : 8,
        vertical: isTablet ? 6 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isTablet ? 16 : 14, color: color),
          SizedBox(width: isTablet ? 6 : 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 13 : 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileFAB(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _navigateToAddSupplier(context),
      backgroundColor: Colors.blue.shade700,
      foregroundColor: Colors.white,
      icon: const Icon(Icons.add),
      label: const Text(
        'Nuevo Proveedor',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      elevation: 4,
    );
  }

  Widget _buildDesktopFAB(BuildContext context, bool isTablet) {
    return FloatingActionButton(
      onPressed: () => _navigateToAddSupplier(context),
      backgroundColor: Colors.blue.shade700,
      foregroundColor: Colors.white,
      elevation: 4,
      child: Icon(Icons.add, size: isTablet ? 28 : 24),
    );
  }

  List<Supplier> _getFilteredSuppliers(List<Supplier> suppliers) {
    List<Supplier> filtered = suppliers;

    // Aplicar filtro de búsqueda
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((supplier) {
        return supplier.name.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ) ||
            supplier.nitTaxId.toLowerCase().contains(
              _searchQuery.toLowerCase(),
            );
      }).toList();
    }

    // Aplicar filtro de estado
    if (_selectedFilter != 'Todos') {
      filtered = filtered.where((supplier) {
        if (_selectedFilter == 'Activos') return supplier.isActive;
        if (_selectedFilter == 'Desactivados') return !supplier.isActive;
        return true;
      }).toList();
    }

    // Aplicar ordenamiento
    filtered.sort((a, b) {
      switch (_sortOrder) {
        case 'Nombre A-Z':
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        case 'Nombre Z-A':
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        case 'Recientes':
          return b.createdAt.compareTo(a.createdAt);
        default:
          return 0;
      }
    });

    return filtered;
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

  void _navigateToSupplierProducts(
    BuildContext context,
    Supplier supplier,
  ) async {
    final result = await SupplierProductsWrapper.navigateTo(
      context,
      supplier.id,
      supplier.name,
    );

    // Reload suppliers when returning from products page to update product count
    // Solo recarga si hubo cambios o si result es null (por si acaso)
    if (context.mounted && (result == true || result == null)) {
      context.read<SupplierCubit>().loadSuppliers();
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/supplier.dart';
import '../bloc/supplier_cubit.dart';
import '../bloc/supplier_state.dart';

class SupplierContactsPage extends StatefulWidget {
  final Supplier supplier;

  const SupplierContactsPage({super.key, required this.supplier});

  @override
  State<SupplierContactsPage> createState() => _SupplierContactsPageState();
}

class _SupplierContactsPageState extends State<SupplierContactsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<SupplierCubit>().loadSupplierContacts(widget.supplier.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contactos',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: isMobile ? 16 : 18,
              ),
            ),
            Text(
              widget.supplier.name,
              style: TextStyle(
                color: Colors.white70,
                fontSize: isMobile ? 12 : 14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        backgroundColor: const Color(0xFF2E3B4E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: Colors.white),
            onPressed: () => _showAddContactDialog(context),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isTablet = constraints.maxWidth >= 768;
          final isMobile = constraints.maxWidth < 600;

          return Column(
            children: [
              // Supplier Info Card - Responsive
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(isMobile ? 12 : 16),
                constraints: BoxConstraints(
                  maxWidth: isTablet ? 800 : double.infinity,
                ),
                child: Card(
                  elevation: 2,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 12 : 16),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(isMobile ? 8 : 12),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF2E3B4E,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.business,
                            color: const Color(0xFF2E3B4E),
                            size: isMobile ? 20 : 24,
                          ),
                        ),
                        SizedBox(width: isMobile ? 12 : 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.supplier.name,
                                style: TextStyle(
                                  fontSize: isMobile ? 14 : 16,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF2E3B4E),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'NIT: ${widget.supplier.nitTaxId}',
                                style: TextStyle(
                                  fontSize: isMobile ? 12 : 14,
                                  color: Colors.grey[600],
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        // Refresh button for mobile
                        if (isMobile)
                          IconButton(
                            icon: const Icon(Icons.refresh, size: 20),
                            onPressed: () => context
                                .read<SupplierCubit>()
                                .loadSupplierContacts(widget.supplier.id),
                            tooltip: 'Actualizar contactos',
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              // Contacts List - Responsive
              Expanded(
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: isTablet ? 800 : double.infinity,
                  ),
                  child: BlocBuilder<SupplierCubit, SupplierState>(
                    builder: (context, state) {
                      if (state is SupplierLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xFF2E3B4E),
                            ),
                          ),
                        );
                      }

                      if (state is SupplierError) {
                        return Center(
                          child: Padding(
                            padding: EdgeInsets.all(isMobile ? 16 : 32),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: isMobile ? 48 : 64,
                                  color: Colors.red[400],
                                ),
                                SizedBox(height: isMobile ? 12 : 16),
                                Text(
                                  'Error al cargar contactos',
                                  style: TextStyle(
                                    fontSize: isMobile ? 16 : 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey[800],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: isMobile ? 6 : 8),
                                Text(
                                  state.message,
                                  style: TextStyle(
                                    fontSize: isMobile ? 12 : 14,
                                    color: Colors.grey[600],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(height: isMobile ? 16 : 24),
                                ElevatedButton.icon(
                                  onPressed: () => context
                                      .read<SupplierCubit>()
                                      .loadSupplierContacts(widget.supplier.id),
                                  icon: Icon(
                                    Icons.refresh,
                                    size: isMobile ? 16 : 20,
                                  ),
                                  label: Text(
                                    'Reintentar',
                                    style: TextStyle(
                                      fontSize: isMobile ? 12 : 14,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2E3B4E),
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isMobile ? 16 : 24,
                                      vertical: isMobile ? 8 : 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (state is SupplierContactsLoaded) {
                        if (state.contacts.isEmpty) {
                          return _buildEmptyState(context, isMobile);
                        }
                        return _buildContactsList(context, state.contacts);
                      }

                      return const SizedBox();
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddContactDialog(context),
        backgroundColor: const Color(0xFF2E3B4E),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isMobile) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 24.0 : 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.contacts_outlined,
              size: isMobile ? 64 : 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: isMobile ? 16 : 24),
            Text(
              'No hay contactos registrados',
              style: TextStyle(
                fontSize: isMobile ? 18 : 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isMobile ? 8 : 12),
            Text(
              'Agrega contactos para este proveedor para facilitar la comunicación',
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isMobile ? 24 : 32),
            ElevatedButton.icon(
              onPressed: () => _showAddContactDialog(context),
              icon: Icon(Icons.add, size: isMobile ? 18 : 20),
              label: Text(
                'Agregar Contacto',
                style: TextStyle(fontSize: isMobile ? 14 : 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E3B4E),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : 32,
                  vertical: isMobile ? 12 : 16,
                ),
                textStyle: TextStyle(
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactsList(
    BuildContext context,
    List<SupplierContact> contacts,
  ) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return RefreshIndicator(
      onRefresh: () async {
        context.read<SupplierCubit>().loadSupplierContacts(widget.supplier.id);
      },
      color: const Color(0xFF2E3B4E),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return _buildContactCard(context, contact, isMobile);
        },
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context,
    SupplierContact contact,
    bool isMobile,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: isMobile ? 8 : 12),
      elevation: 2,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isMobile ? 6 : 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E3B4E).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.person,
                    color: const Color(0xFF2E3B4E),
                    size: isMobile ? 18 : 20,
                  ),
                ),
                SizedBox(width: isMobile ? 10 : 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        contact.name,
                        style: TextStyle(
                          fontSize: isMobile ? 14 : 16,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF2E3B4E),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 6 : 8,
                          vertical: isMobile ? 2 : 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          contact.role,
                          style: TextStyle(
                            fontSize: isMobile ? 10 : 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'delete') {
                      _showDeleteConfirmation(context, contact);
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete,
                            color: Colors.red,
                            size: isMobile ? 18 : 20,
                          ),
                          SizedBox(width: isMobile ? 6 : 8),
                          Text(
                            'Eliminar',
                            style: TextStyle(fontSize: isMobile ? 12 : 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: isMobile ? 8 : 12),
            _buildContactInfo(Icons.email_outlined, contact.email, isMobile),
            SizedBox(height: isMobile ? 6 : 8),
            _buildContactInfo(Icons.phone_outlined, contact.phone, isMobile),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo(IconData icon, String text, bool isMobile) {
    return Row(
      children: [
        Icon(icon, size: isMobile ? 14 : 16, color: Colors.grey[600]),
        SizedBox(width: isMobile ? 6 : 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: isMobile ? 12 : 14,
              color: Colors.grey[700],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  void _showAddContactDialog(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();
    final roleController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Nuevo Contacto',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2E3B4E),
            fontSize: isMobile ? 16 : 18,
          ),
        ),
        content: SizedBox(
          width: isMobile ? double.maxFinite : 400,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildDialogField(
                  controller: nameController,
                  label: 'Nombre',
                  icon: Icons.person_outline,
                  isMobile: isMobile,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El nombre es requerido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: isMobile ? 12 : 16),
                _buildDialogField(
                  controller: emailController,
                  label: 'Email',
                  icon: Icons.email_outlined,
                  isMobile: isMobile,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El email es requerido';
                    }
                    if (!value.contains('@')) {
                      return 'Ingresa un email válido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: isMobile ? 12 : 16),
                _buildDialogField(
                  controller: phoneController,
                  label: 'Teléfono',
                  icon: Icons.phone_outlined,
                  isMobile: isMobile,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El teléfono es requerido';
                    }
                    return null;
                  },
                ),
                SizedBox(height: isMobile ? 12 : 16),
                _buildDialogField(
                  controller: roleController,
                  label: 'Cargo/Posición',
                  icon: Icons.work_outline,
                  isMobile: isMobile,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'El cargo es requerido';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancelar',
              style: TextStyle(fontSize: isMobile ? 12 : 14),
            ),
          ),
          BlocConsumer<SupplierCubit, SupplierState>(
            listener: (context, state) {
              if (state is SupplierContactCreated) {
                Navigator.pop(dialogContext);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Contacto "${state.contact.name}" agregado'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              } else if (state is SupplierError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Error: ${state.message}'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            builder: (context, state) {
              final isLoading = state is SupplierLoading;
              return ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () {
                        if (formKey.currentState!.validate()) {
                          context.read<SupplierCubit>().addSupplierContact(
                            supplierId: widget.supplier.id,
                            name: nameController.text.trim(),
                            email: emailController.text.trim(),
                            phone: phoneController.text.trim(),
                            role: roleController.text.trim(),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E3B4E),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 16 : 20,
                    vertical: isMobile ? 8 : 12,
                  ),
                ),
                child: isLoading
                    ? SizedBox(
                        height: isMobile ? 14 : 16,
                        width: isMobile ? 14 : 16,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        'Agregar',
                        style: TextStyle(fontSize: isMobile ? 12 : 14),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, SupplierContact contact) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Confirmar eliminación',
          style: TextStyle(fontSize: isMobile ? 16 : 18),
        ),
        content: Text(
          '¿Estás seguro de que quieres eliminar a ${contact.name}?',
          style: TextStyle(fontSize: isMobile ? 12 : 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancelar',
              style: TextStyle(fontSize: isMobile ? 12 : 14),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<SupplierCubit>().deleteSupplierContact(
                contact.id,
                widget.supplier.id,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 16 : 20,
                vertical: isMobile ? 8 : 12,
              ),
            ),
            child: Text(
              'Eliminar',
              style: TextStyle(fontSize: isMobile ? 12 : 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isMobile,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      style: TextStyle(fontSize: isMobile ? 12 : 14),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontSize: isMobile ? 12 : 14),
        prefixIcon: Icon(icon, size: isMobile ? 18 : 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF2E3B4E), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: isMobile ? 12 : 16,
          vertical: isMobile ? 8 : 12,
        ),
      ),
    );
  }
}

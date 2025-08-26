import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/supplier.dart';
import '../bloc/supplier_cubit.dart';
import '../bloc/supplier_state.dart';

class SupplierFormPage extends StatefulWidget {
  final String? supplierId; // Para edición

  const SupplierFormPage({super.key, this.supplierId});

  @override
  State<SupplierFormPage> createState() => _SupplierFormPageState();
}

class _SupplierFormPageState extends State<SupplierFormPage> {
  final _formKey = GlobalKey<FormState>();

  // Controladores principales según el JSON
  final _nameController = TextEditingController();
  final _nitController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _paymentTermsController = TextEditingController();
  final _currencyController = TextEditingController();

  // Controlador para términos personalizados
  final _customPaymentTermsController = TextEditingController();

  // Estado del formulario
  bool _isActive = true;
  String _selectedPaymentTerms = '';
  String _selectedCurrency = '';

  final List<String> _currencies = [
    'USD',
    'EUR',
    'COP',
    'PEN',
    'MXN',
    'CLP',
    'BOB',
  ];
  final List<String> _paymentTermsOptions = [
    'Al contado',
    '15 días',
    '30 días',
    '45 días',
    '60 días',
    '90 días',
    'Personalizado',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCurrency = 'USD'; // Valor por defecto
    _currencyController.text = 'USD';

    // Si es edición, cargar datos del proveedor
    if (widget.supplierId != null) {
      _loadSupplierData();
    }
  }

  void _loadSupplierData() {
    context.read<SupplierCubit>().loadSupplierById(widget.supplierId!);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nitController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _paymentTermsController.dispose();
    _currencyController.dispose();
    _customPaymentTermsController.dispose();
    super.dispose();
  }

  bool get _isEditing => widget.supplierId != null;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surfaceContainerLowest,
      appBar: _buildAppBar(context),
      body: BlocListener<SupplierCubit, SupplierState>(
        listener: _handleStateChanges,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isTablet ? 24 : 16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Form(
                key: _formKey,
                child: Card(
                  elevation: 0,
                  color: Theme.of(context).colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Theme.of(context).colorScheme.outlineVariant,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionHeader(
                          icon: Icons.business_rounded,
                          title: 'Información del Proveedor',
                          subtitle: 'Complete todos los campos requeridos',
                        ),
                        const SizedBox(height: 32),

                        // Nombre y NIT
                        if (isTablet) ...[
                          Row(
                            children: [
                              Expanded(
                                flex: 2,
                                child: _buildTextField(
                                  controller: _nameController,
                                  label: 'Nombre de la Empresa *',
                                  icon: Icons.business_outlined,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'El nombre es requerido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  controller: _nitController,
                                  label: 'NIT / Número Tributario *',
                                  icon: Icons.numbers_outlined,
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'El NIT es requerido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          _buildTextField(
                            controller: _nameController,
                            label: 'Nombre de la Empresa *',
                            icon: Icons.business_outlined,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El nombre es requerido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _nitController,
                            label: 'NIT / Número Tributario *',
                            icon: Icons.numbers_outlined,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El NIT es requerido';
                              }
                              return null;
                            },
                          ),
                        ],

                        const SizedBox(height: 16),

                        // Email y Teléfono
                        if (isTablet) ...[
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  controller: _emailController,
                                  label: 'Correo Electrónico *',
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  placeholder: 'contacto@empresa.com',
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'El email es requerido';
                                    }
                                    final emailRegex = RegExp(
                                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                                    );
                                    if (!emailRegex.hasMatch(value)) {
                                      return 'Ingrese un email válido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildTextField(
                                  controller: _phoneController,
                                  label: 'Teléfono *',
                                  icon: Icons.phone_outlined,
                                  keyboardType: TextInputType.phone,
                                  placeholder: '+1234567890',
                                  validator: (value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'El teléfono es requerido';
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ],
                          ),
                        ] else ...[
                          _buildTextField(
                            controller: _emailController,
                            label: 'Correo Electrónico *',
                            icon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            placeholder: 'contacto@empresa.com',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El email es requerido';
                              }
                              final emailRegex = RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              );
                              if (!emailRegex.hasMatch(value)) {
                                return 'Ingrese un email válido';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildTextField(
                            controller: _phoneController,
                            label: 'Teléfono *',
                            icon: Icons.phone_outlined,
                            keyboardType: TextInputType.phone,
                            placeholder: '+1234567890',
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'El teléfono es requerido';
                              }
                              return null;
                            },
                          ),
                        ],

                        const SizedBox(height: 16),

                        // Dirección
                        _buildTextField(
                          controller: _addressController,
                          label: 'Dirección *',
                          icon: Icons.location_on_outlined,
                          maxLines: 2,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'La dirección es requerida';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Términos de pago
                        _buildPaymentTermsField(),

                        const SizedBox(height: 16),

                        // Moneda
                        _buildDropdownField(
                          label: 'Moneda *',
                          icon: Icons.monetization_on_outlined,
                          value: _selectedCurrency.isEmpty
                              ? null
                              : _selectedCurrency,
                          items: _currencies,
                          onChanged: (value) {
                            setState(() {
                              _selectedCurrency = value ?? 'USD';
                              _currencyController.text = _selectedCurrency;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'La moneda es requerida';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // Estado del proveedor
                        SwitchListTile(
                          title: Text(
                            'Proveedor Activo',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'El proveedor puede recibir órdenes de compra',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          value: _isActive,
                          onChanged: (value) {
                            setState(() {
                              _isActive = value;
                            });
                          },
                          activeColor: Theme.of(context).colorScheme.primary,
                          contentPadding: EdgeInsets.zero,
                        ),

                        const SizedBox(height: 32),

                        // Botón de envío
                        SizedBox(
                          width: double.infinity,
                          child: BlocBuilder<SupplierCubit, SupplierState>(
                            builder: (context, state) {
                              final isLoading = state is SupplierLoading;
                              return FilledButton.icon(
                                onPressed: isLoading ? null : _submitForm,
                                icon: isLoading
                                    ? const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Icon(_isEditing ? Icons.save : Icons.add),
                                label: Text(
                                  _isEditing
                                      ? 'Guardar Cambios'
                                      : 'Crear Proveedor',
                                ),
                                style: FilledButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  textStyle: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        _isEditing ? 'Editar Proveedor' : 'Nuevo Proveedor',
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      surfaceTintColor: Theme.of(context).colorScheme.surfaceTint,
      elevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        onPressed: () => _handleBackNavigation(context),
      ),
    );
  }

  Widget _buildPaymentTermsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDropdownField(
          label: 'Términos de Pago *',
          icon: Icons.payment_outlined,
          value: _selectedPaymentTerms.isEmpty ? null : _selectedPaymentTerms,
          items: _paymentTermsOptions,
          onChanged: (value) {
            setState(() {
              _selectedPaymentTerms = value ?? '';
              if (value != 'Personalizado') {
                _paymentTermsController.text = value ?? '';
                _customPaymentTermsController.clear();
              }
            });
          },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Los términos de pago son requeridos';
            }
            return null;
          },
        ),
        if (_selectedPaymentTerms == 'Personalizado') ...[
          const SizedBox(height: 16),
          _buildTextField(
            controller: _customPaymentTermsController,
            label: 'Días personalizados *',
            icon: Icons.event_outlined,
            keyboardType: TextInputType.number,
            placeholder: 'Ej: 120',
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: (value) {
              if (_selectedPaymentTerms == 'Personalizado' &&
                  (value == null || value.trim().isEmpty)) {
                return 'Ingrese la cantidad de días';
              }
              return null;
            },
            onChanged: (value) {
              if (value.isNotEmpty) {
                _paymentTermsController.text = '$value días';
              }
            },
          ),
        ],
      ],
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? placeholder,
    int maxLines = 1,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    void Function(String)? onChanged,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) {
        return DropdownMenuItem<String>(value: item, child: Text(item));
      }).toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Theme.of(context).colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.error,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  void _handleStateChanges(BuildContext context, SupplierState state) {
    if (state is SupplierCreated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Proveedor "${state.supplier.name}" creado exitosamente',
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true); // Retornar true para indicar éxito
    } else if (state is SupplierUpdated) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Proveedor "${state.supplier.name}" actualizado exitosamente',
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.pop(context, true); // Retornar true para indicar éxito
    } else if (state is SupplierDetailLoaded) {
      _populateForm(state.supplier);
    } else if (state is SupplierError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${state.message}'),
          backgroundColor: Theme.of(context).colorScheme.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _populateForm(Supplier supplier) {
    _nameController.text = supplier.name;
    _nitController.text = supplier.nitTaxId;
    _addressController.text = supplier.address;
    _paymentTermsController.text = supplier.paymentTerms;
    _currencyController.text = supplier.currency;

    // Necesitamos obtener email y phone de los contactos principales si existen
    if (supplier.contacts.isNotEmpty) {
      final primaryContact = supplier.contacts.first;
      _emailController.text = primaryContact.email;
      _phoneController.text = primaryContact.phone;
    }

    setState(() {
      _isActive = supplier.isActive;
      _selectedCurrency = supplier.currency;

      // Configurar términos de pago
      if (_paymentTermsOptions.contains(supplier.paymentTerms)) {
        _selectedPaymentTerms = supplier.paymentTerms;
      } else {
        _selectedPaymentTerms = 'Personalizado';
        _customPaymentTermsController.text = supplier.paymentTerms;
      }
    });
  }

  void _handleBackNavigation(BuildContext context) {
    if (_hasChanges()) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('¿Descartar cambios?'),
          content: const Text(
            'Tiene cambios sin guardar. ¿Está seguro de que desea salir?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.pop(context); // Cerrar diálogo
                Navigator.pop(context); // Cerrar formulario
              },
              child: const Text('Descartar'),
            ),
          ],
        ),
      );
    } else {
      Navigator.pop(context);
    }
  }

  bool _hasChanges() {
    return _nameController.text.isNotEmpty ||
        _nitController.text.isNotEmpty ||
        _emailController.text.isNotEmpty ||
        _phoneController.text.isNotEmpty ||
        _addressController.text.isNotEmpty ||
        _paymentTermsController.text.isNotEmpty ||
        _selectedCurrency != 'USD' ||
        !_isActive;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Preparar el valor final de términos de pago
      String finalPaymentTerms = _paymentTermsController.text;
      if (_selectedPaymentTerms == 'Personalizado' &&
          _customPaymentTermsController.text.isNotEmpty) {
        finalPaymentTerms = '${_customPaymentTermsController.text} días';
      }

      if (_isEditing) {
        // Editar proveedor existente
        context.read<SupplierCubit>().editSupplier(
          id: widget.supplierId!,
          name: _nameController.text.trim(),
          nitTaxId: _nitController.text.trim(),
          address: _addressController.text.trim(),
          paymentTerms: finalPaymentTerms,
          currency: _currencyController.text.trim(),
          isActive: _isActive,
        );
      } else {
        // Crear nuevo proveedor
        context.read<SupplierCubit>().addSupplier(
          name: _nameController.text.trim(),
          nitTaxId: _nitController.text.trim(),
          address: _addressController.text.trim(),
          paymentTerms: finalPaymentTerms,
          currency: _currencyController.text.trim(),
        );
      }
    }
  }
}

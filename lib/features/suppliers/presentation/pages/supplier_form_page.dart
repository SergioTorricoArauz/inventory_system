import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/supplier_cubit.dart';
import '../bloc/supplier_state.dart';

class SupplierFormPage extends StatefulWidget {
  const SupplierFormPage({super.key});

  @override
  State<SupplierFormPage> createState() => _SupplierFormPageState();
}

class _SupplierFormPageState extends State<SupplierFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nitController = TextEditingController();
  final _addressController = TextEditingController();
  final _paymentTermsController = TextEditingController();
  final _currencyController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _nitController.dispose();
    _addressController.dispose();
    _paymentTermsController.dispose();
    _currencyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Nuevo Proveedor',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2E3B4E),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocListener<SupplierCubit, SupplierState>(
        listener: (context, state) {
          if (state is SupplierCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Proveedor "${state.supplier.name}" creado exitosamente',
                ),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            Navigator.pop(context);
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 2,
                  shadowColor: Colors.black26,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(
                                  0xFF2E3B4E,
                                ).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.business,
                                color: Color(0xFF2E3B4E),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Información del Proveedor',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2E3B4E),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildTextField(
                          controller: _nameController,
                          label: 'Nombre de la Empresa',
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
                          label: 'NIT / Número Tributario',
                          icon: Icons.numbers_outlined,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El NIT es requerido';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _addressController,
                          label: 'Dirección',
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
                        _buildTextField(
                          controller: _paymentTermsController,
                          label: 'Términos de Pago',
                          icon: Icons.payment_outlined,
                          placeholder: 'Ej: 30 días, Al contado, etc.',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Los términos de pago son requeridos';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          controller: _currencyController,
                          label: 'Moneda',
                          icon: Icons.monetization_on_outlined,
                          placeholder: 'Ej: USD, EUR, COP',
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'La moneda es requerida';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                BlocBuilder<SupplierCubit, SupplierState>(
                  builder: (context, state) {
                    final isLoading = state is SupplierLoading;

                    return ElevatedButton(
                      onPressed: isLoading ? null : _submitForm,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E3B4E),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      child: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white,
                                ),
                              ),
                            )
                          : const Text('Crear Proveedor'),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? placeholder,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        prefixIcon: Icon(icon, color: const Color(0xFF2E3B4E)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF2E3B4E), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<SupplierCubit>().addSupplier(
        name: _nameController.text.trim(),
        nitTaxId: _nitController.text.trim(),
        address: _addressController.text.trim(),
        paymentTerms: _paymentTermsController.text.trim(),
        currency: _currencyController.text.trim(),
      );
    }
  }
}

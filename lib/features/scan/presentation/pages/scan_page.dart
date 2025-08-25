import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:audioplayers/audioplayers.dart';
import '../bloc/scan_cubit.dart';
import 'scan_history_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _barcodeController = TextEditingController();
  String? _lastScanned;

  @override
  void dispose() {
    _audioPlayer.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final raw = capture.barcodes.first.rawValue;
    if (raw != null && raw != _lastScanned) {
      _lastScanned = raw;

      // Reproduce el sonido
      _audioPlayer.play(AssetSource('beep.mp3'));

      // Busca el producto por código de barras
      context.read<ScanCubit>().scanBarcode(raw);

      // Feedback visual
      if (!context.mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Buscando producto...')));
    }
  }

  void _showProductDialog(BuildContext context, product) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 768;
    final isDesktop = screenSize.width >= 1024;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop
                  ? 600
                  : (isTablet ? 500 : screenSize.width * 0.9),
              maxHeight: screenSize.height * 0.7,
            ),
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: isTablet ? 32 : 28,
                      ),
                      SizedBox(width: isTablet ? 12 : 8),
                      Expanded(
                        child: Text(
                          'Producto Encontrado',
                          style: TextStyle(
                            fontSize: isTablet ? 24 : 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 24 : 16),

                  // Información del producto
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(isTablet ? 20 : 16),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet ? 20 : 18,
                            color: Colors.green[800],
                          ),
                        ),
                        SizedBox(height: isTablet ? 16 : 12),

                        _buildProductInfoRow(
                          'Código:',
                          product.barcode,
                          Icons.qr_code,
                          isTablet,
                        ),
                        SizedBox(height: isTablet ? 12 : 8),

                        _buildProductInfoRow(
                          'Precio:',
                          '\$${product.price.toStringAsFixed(2)}',
                          Icons.attach_money,
                          isTablet,
                        ),
                        SizedBox(height: isTablet ? 12 : 8),

                        _buildProductInfoRow(
                          'Stock:',
                          '${product.stockQuantity} unidades',
                          Icons.inventory,
                          isTablet,
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: isTablet ? 32 : 24),

                  // Botones
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 16 : 12,
                            ),
                          ),
                          child: Text(
                            'Cerrar',
                            style: TextStyle(fontSize: isTablet ? 16 : 14),
                          ),
                        ),
                      ),
                      SizedBox(width: isTablet ? 16 : 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✓ Producto verificado'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 16 : 12,
                            ),
                          ),
                          child: Text(
                            'Confirmar',
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductInfoRow(
    String label,
    String value,
    IconData icon,
    bool isTablet,
  ) {
    return Row(
      children: [
        Icon(icon, size: isTablet ? 20 : 18, color: Colors.green[600]),
        SizedBox(width: isTablet ? 12 : 8),
        Text(
          label,
          style: TextStyle(
            fontSize: isTablet ? 16 : 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        SizedBox(width: isTablet ? 8 : 4),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: Colors.grey[800],
            ),
          ),
        ),
      ],
    );
  }

  void _showManualInputDialog() {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 768;
    final isDesktop = screenSize.width >= 1024;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isDesktop
                  ? 500
                  : (isTablet ? 400 : screenSize.width * 0.9),
              maxHeight: screenSize.height * 0.6,
            ),
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 24.0 : 16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Row(
                    children: [
                      Icon(
                        Icons.keyboard,
                        color: Colors.blue,
                        size: isTablet ? 28 : 24,
                      ),
                      SizedBox(width: isTablet ? 12 : 8),
                      Expanded(
                        child: Text(
                          'Ingresar Código Manual',
                          style: TextStyle(
                            fontSize: isTablet ? 22 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isTablet ? 24 : 16),

                  // Descripción
                  Text(
                    'Ingresa el código de barras manualmente:',
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: isTablet ? 20 : 16),

                  // Campo de texto
                  TextField(
                    controller: _barcodeController,
                    autofocus: true,
                    style: TextStyle(fontSize: isTablet ? 18 : 16),
                    decoration: InputDecoration(
                      labelText: 'Código de barras',
                      labelStyle: TextStyle(fontSize: isTablet ? 16 : 14),
                      hintText: 'Ej: 1234567890123',
                      hintStyle: TextStyle(fontSize: isTablet ? 16 : 14),
                      border: const OutlineInputBorder(),
                      prefixIcon: Icon(Icons.qr_code, size: isTablet ? 24 : 20),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: isTablet ? 16 : 12,
                        horizontal: isTablet ? 16 : 12,
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.search,
                    onSubmitted: (value) {
                      if (value.trim().isNotEmpty) {
                        Navigator.of(context).pop();
                        _searchManualBarcode(value.trim());
                      }
                    },
                  ),

                  SizedBox(height: isTablet ? 32 : 24),

                  // Botones
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            _barcodeController.clear();
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 16 : 12,
                            ),
                          ),
                          child: Text(
                            'Cancelar',
                            style: TextStyle(fontSize: isTablet ? 16 : 14),
                          ),
                        ),
                      ),
                      SizedBox(width: isTablet ? 16 : 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            final barcode = _barcodeController.text.trim();
                            if (barcode.isNotEmpty) {
                              Navigator.of(context).pop();
                              _searchManualBarcode(barcode);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Por favor ingresa un código válido',
                                  ),
                                  backgroundColor: Colors.orange,
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(
                              vertical: isTablet ? 16 : 12,
                            ),
                          ),
                          child: Text(
                            'Buscar',
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _searchManualBarcode(String barcode) {
    _barcodeController.clear();

    // Reproduce el sonido para simular escaneo
    _audioPlayer.play(AssetSource('beep.mp3'));

    // Busca el producto
    context.read<ScanCubit>().scanBarcode(barcode);

    // Feedback visual
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Buscando producto con código: $barcode')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escáner de Ventas'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.keyboard),
            onPressed: _showManualInputDialog,
            tooltip: 'Ingresar código manual',
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ScanHistoryPage()),
              );
            },
            tooltip: 'Ver Historial',
          ),
        ],
      ),
      body: Column(
        children: [
          // Información superior
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              border: Border(bottom: BorderSide(color: Colors.green.shade200)),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.qr_code_scanner,
                  size: 48,
                  color: Colors.green,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Buscar productos por código de barras',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Escanea el código o usa el botón ⌨️ para ingresarlo manualmente',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          // Scanner
          Expanded(
            child: BlocListener<ScanCubit, ScanState>(
              listener: (context, state) {
                if (state is ScanError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: ${state.message}'),
                      backgroundColor: Colors.red,
                    ),
                  );
                } else if (state is ProductFound) {
                  _showProductDialog(context, state.product);
                } else if (state is ProductNotFound) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        '❌ Producto no encontrado con código: ${state.barcode}',
                      ),
                      backgroundColor: Colors.orange,
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              },
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green, width: 3),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: MobileScanner(onDetect: _onDetect),
                ),
              ),
            ),
          ),
          // Estado de carga
          BlocBuilder<ScanCubit, ScanState>(
            builder: (context, state) {
              if (state is ScanLoading) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                      SizedBox(width: 12),
                      Text('Buscando producto...'),
                    ],
                  ),
                );
              }
              return const SizedBox(height: 16);
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showManualInputDialog,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        icon: const Icon(Icons.keyboard),
        label: const Text('Código Manual'),
        tooltip: 'Ingresar código de barras manualmente',
      ),
    );
  }
}

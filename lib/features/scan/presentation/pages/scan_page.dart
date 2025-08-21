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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green),
              SizedBox(width: 8),
              Text('Producto Encontrado'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nombre: ${product.name}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Text('Código: ${product.barcode}'),
              const SizedBox(height: 4),
              Text('Precio: \$${product.price.toStringAsFixed(2)}'),
              const SizedBox(height: 4),
              Text('Stock: ${product.stockQuantity} unidades'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Aquí podrías agregar lógica para agregar a carrito, etc.
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✓ Producto verificado'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );
  }

  void _showManualInputDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.keyboard, color: Colors.blue),
              SizedBox(width: 8),
              Text('Ingresar Código Manual'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Ingresa el código de barras manualmente:',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _barcodeController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Código de barras',
                  hintText: 'Ej: 1234567890123',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.qr_code),
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                _barcodeController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final barcode = _barcodeController.text.trim();
                if (barcode.isNotEmpty) {
                  Navigator.of(context).pop();
                  _searchManualBarcode(barcode);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor ingresa un código válido'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
              child: const Text('Buscar'),
            ),
          ],
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

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
  String? _lastScanned;

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final raw = capture.barcodes.first.rawValue;
    if (raw != null && raw != _lastScanned) {
      _lastScanned = raw;

      // Reproduce el sonido
      _audioPlayer.play(AssetSource('beep.mp3'));

      // Envía el escaneo al backend
      context.read<ScanCubit>().scanBarcode(raw);

      // Feedback visual
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escaneo enviado al servidor')),
      );
    }
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
                  'Escaneando productos para venta',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Apunta la cámara hacia el código de barras',
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
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
                } else if (state is ScanSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✓ Producto escaneado exitosamente'),
                      backgroundColor: Colors.green,
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
                      Text('Procesando escaneo...'),
                    ],
                  ),
                );
              }
              return const SizedBox(height: 16);
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:audioplayers/audioplayers.dart';

class ProductBarcodeScanPage extends StatefulWidget {
  const ProductBarcodeScanPage({super.key});

  @override
  State<ProductBarcodeScanPage> createState() => _ProductBarcodeScanPageState();
}

class _ProductBarcodeScanPageState extends State<ProductBarcodeScanPage> {
  MobileScannerController controller = MobileScannerController();
  final AudioPlayer audioPlayer = AudioPlayer();
  bool hasScanned = false;

  @override
  void dispose() {
    controller.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (hasScanned) return;
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final barcode = barcodes.first;
      if (barcode.rawValue != null) {
        setState(() {
          hasScanned = true;
        });

        // Reproducir sonido de confirmación
        try {
          await audioPlayer.play(AssetSource('beep.mp3'));
        } catch (e) {
          // Si falla el audio, continuar sin él
        }

        // Retornar el código escaneado
        if (mounted) {
          Navigator.of(context).pop(barcode.rawValue);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear Código de Barras'),
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            onPressed: () => controller.toggleTorch(),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Cámara del escáner
          MobileScanner(controller: controller, onDetect: _onDetect),

          // Overlay con marco de escaneo
          CustomPaint(painter: ScannerOverlayPainter(), child: Container()),

          // Instrucciones
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.qr_code_scanner, color: Colors.white, size: 32),
                  const SizedBox(height: 8),
                  const Text(
                    'Apunta la cámara hacia el código de barras del producto',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'El escaneo es automático',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Botón de entrada manual
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.of(context).pop('manual');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.keyboard),
                label: const Text('Ingresar manualmente'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.5)
      ..style = PaintingStyle.fill;

    // Crear el overlay oscuro con un agujero en el centro
    const double cutOutSize = 250.0;
    final cutOutRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height / 2),
      width: cutOutSize,
      height: cutOutSize,
    );

    // Dibujar el overlay
    canvas.drawPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(Rect.fromLTWH(0, 0, size.width, size.height)),
        Path()..addRRect(
          RRect.fromRectAndRadius(cutOutRect, const Radius.circular(16)),
        ),
      ),
      paint,
    );

    // Dibujar las esquinas del marco de escaneo
    final cornerPaint = Paint()
      ..color = Colors.blue.shade700
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    const double cornerLength = 30.0;
    final double left = cutOutRect.left;
    final double top = cutOutRect.top;
    final double right = cutOutRect.right;
    final double bottom = cutOutRect.bottom;

    // Esquinas superiores
    canvas.drawLine(
      Offset(left, top),
      Offset(left + cornerLength, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left, top + cornerLength),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(right, top),
      Offset(right - cornerLength, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(right, top),
      Offset(right, top + cornerLength),
      cornerPaint,
    );

    // Esquinas inferiores
    canvas.drawLine(
      Offset(left, bottom),
      Offset(left + cornerLength, bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, bottom),
      Offset(left, bottom - cornerLength),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(right, bottom),
      Offset(right - cornerLength, bottom),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(right, bottom),
      Offset(right, bottom - cornerLength),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

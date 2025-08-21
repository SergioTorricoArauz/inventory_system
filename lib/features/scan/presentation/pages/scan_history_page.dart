import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/scan_cubit.dart';

class ScanHistoryPage extends StatefulWidget {
  const ScanHistoryPage({super.key});

  @override
  State<ScanHistoryPage> createState() => _ScanHistoryPageState();
}

class _ScanHistoryPageState extends State<ScanHistoryPage> {
  @override
  void initState() {
    super.initState();
    // Cargar el historial cuando se inicializa la página
    context.read<ScanCubit>().getScans();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Escaneos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => context.read<ScanCubit>().getScans(),
          ),
        ],
      ),
      body: BlocBuilder<ScanCubit, ScanState>(
        builder: (context, state) {
          if (state is ScanLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ScanHistoryLoaded) {
            if (state.scans.isEmpty) {
              return const Center(
                child: Text('No hay escaneos en el historial'),
              );
            }
            return ListView.builder(
              itemCount: state.scans.length,
              itemBuilder: (ctx, i) {
                final scan = state.scans[i];
                return ListTile(
                  leading: const Icon(Icons.qr_code),
                  title: Text(scan.barcode),
                  subtitle: Text(scan.scanDate.toLocal().toString()),
                );
              },
            );
          } else if (state is ScanError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () => context.read<ScanCubit>().getScans(),
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Text('Toca el botón de actualizar para cargar el historial'),
          );
        },
      ),
    );
  }
}

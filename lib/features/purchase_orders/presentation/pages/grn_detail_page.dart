import 'package:flutter/material.dart';
import '../../domain/entities/good_receipt_note.dart';
import '../../domain/entities/grn_line.dart';

class GrnDetailPage extends StatelessWidget {
  final GoodReceiptNote grn;

  const GrnDetailPage({super.key, required this.grn});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;
    final isDesktop = screenWidth > 1200;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GRN #${grn.referenceNumber}',
          style: TextStyle(fontSize: isDesktop ? 22 : 18),
        ),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          isDesktop
              ? 24
              : isTablet
              ? 20
              : 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(grn, isTablet, isDesktop),
            SizedBox(height: isTablet ? 20 : 16),
            _buildLinesSection(grn, isTablet, isDesktop),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(GoodReceiptNote grn, bool isTablet, bool isDesktop) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(
          isDesktop
              ? 24
              : isTablet
              ? 20
              : 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Información de Recepción',
              style: TextStyle(
                fontSize: isDesktop
                    ? 24
                    : isTablet
                    ? 20
                    : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isTablet ? 20 : 16),
            _buildInfoRow(
              Icons.receipt,
              'Referencia',
              grn.referenceNumber,
              isTablet,
              isDesktop,
            ),
            SizedBox(height: isTablet ? 16 : 12),
            _buildInfoRow(
              Icons.person,
              'Recibido por',
              grn.receivedBy,
              isTablet,
              isDesktop,
            ),
            SizedBox(height: isTablet ? 16 : 12),
            _buildInfoRow(
              Icons.access_time,
              'Fecha y Hora',
              _formatDateTime(grn.receivedAt),
              isTablet,
              isDesktop,
            ),
            SizedBox(height: isTablet ? 16 : 12),
            _buildInfoRow(
              Icons.inventory,
              'Total de Unidades',
              grn.totalUnits.toString(),
              isTablet,
              isDesktop,
            ),
            if (grn.notes.isNotEmpty) ...[
              SizedBox(height: isTablet ? 20 : 16),
              Text(
                'Notas:',
                style: TextStyle(
                  fontSize: isDesktop
                      ? 18
                      : isTablet
                      ? 16
                      : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: isTablet ? 8 : 6),
              Text(
                grn.notes,
                style: TextStyle(
                  fontSize: isDesktop
                      ? 16
                      : isTablet
                      ? 14
                      : 12,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value,
    bool isTablet,
    bool isDesktop,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: isDesktop
              ? 24
              : isTablet
              ? 20
              : 18,
          color: Colors.grey.shade600,
        ),
        SizedBox(width: isTablet ? 16 : 12),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: isDesktop
                ? 16
                : isTablet
                ? 14
                : 12,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade700,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: isDesktop
                  ? 16
                  : isTablet
                  ? 14
                  : 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLinesSection(
    GoodReceiptNote grn,
    bool isTablet,
    bool isDesktop,
  ) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(
          isDesktop
              ? 24
              : isTablet
              ? 20
              : 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Productos Recibidos (${grn.lines.length})',
              style: TextStyle(
                fontSize: isDesktop
                    ? 24
                    : isTablet
                    ? 20
                    : 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isTablet ? 20 : 16),
            ...grn.lines.map(
              (line) => _buildLineItem(line, isTablet, isDesktop),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineItem(GrnLine line, bool isTablet, bool isDesktop) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 16 : 12),
      padding: EdgeInsets.all(
        isDesktop
            ? 16
            : isTablet
            ? 14
            : 12,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.productName,
                  style: TextStyle(
                    fontSize: isDesktop
                        ? 18
                        : isTablet
                        ? 16
                        : 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: isTablet ? 6 : 4),
                Text(
                  'ID: ${line.productId}',
                  style: TextStyle(
                    fontSize: isDesktop
                        ? 14
                        : isTablet
                        ? 12
                        : 10,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: isTablet ? 20 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 12 : 8,
                    vertical: isTablet ? 8 : 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: Colors.green.shade300),
                  ),
                  child: Text(
                    '${line.qtyReceived}',
                    style: TextStyle(
                      fontSize: isDesktop
                          ? 18
                          : isTablet
                          ? 16
                          : 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green.shade700,
                    ),
                  ),
                ),
                SizedBox(height: isTablet ? 6 : 4),
                Text(
                  'unidades',
                  style: TextStyle(
                    fontSize: isDesktop
                        ? 12
                        : isTablet
                        ? 10
                        : 8,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

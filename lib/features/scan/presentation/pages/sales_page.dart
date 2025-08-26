import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';
import '../bloc/scan_cubit.dart';
import '../../domain/entities/sale_item.dart';
import '../../../product/domain/entities/product.dart';

class SalesPage extends StatefulWidget {
  const SalesPage({super.key});

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final TextEditingController _barcodeController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  String? _lastScanned;
  bool _showScanner = true;

  @override
  void dispose() {
    _audioPlayer.dispose();
    _barcodeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    final raw = capture.barcodes.first.rawValue;
    if (raw != null && raw != _lastScanned) {
      _lastScanned = raw;
      _audioPlayer.play(AssetSource('beep.mp3'));
      context.read<ScanCubit>().scanBarcodeForSale(raw);
    }
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
                    'Ingresa el código de barras manualmente para agregarlo al carrito:',
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
    _audioPlayer.play(AssetSource('beep.mp3'));
    context.read<ScanCubit>().scanBarcodeForSale(barcode);
  }

  void _showProductSearchDialog() {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;

    // Responsive breakpoints más detallados
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    // Cálculo dinámico de dimensiones
    final dialogWidth = isMobile
        ? screenWidth * 0.95
        : isTablet
        ? screenWidth * 0.85
        : isDesktop
        ? screenWidth * 0.6
        : 800.0; // Large desktop max width

    final dialogMaxHeight = isMobile
        ? screenHeight * 0.85
        : isTablet
        ? screenHeight * 0.8
        : screenHeight * 0.75;

    // Responsive spacing y sizing
    final titleFontSize = isMobile
        ? 18.0
        : isTablet
        ? 20.0
        : 22.0;
    final bodyFontSize = isMobile
        ? 14.0
        : isTablet
        ? 15.0
        : 16.0;
    final iconSize = isMobile
        ? 20.0
        : isTablet
        ? 24.0
        : 28.0;
    final padding = isMobile
        ? 16.0
        : isTablet
        ? 20.0
        : 24.0;
    final spacing = isMobile
        ? 12.0
        : isTablet
        ? 16.0
        : 20.0;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: dialogWidth,
              maxHeight: dialogMaxHeight,
              minWidth: isMobile ? 280 : 400,
              minHeight: isMobile ? 300 : 400,
            ),
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header responsive
                  _buildResponsiveHeader(
                    dialogContext,
                    isMobile,
                    isTablet,
                    titleFontSize,
                    iconSize,
                    spacing,
                  ),

                  SizedBox(height: spacing * 0.8),

                  // Descripción responsive
                  _buildResponsiveDescription(bodyFontSize, isMobile),

                  SizedBox(height: spacing),

                  // Campo de búsqueda responsive
                  _buildResponsiveSearchField(
                    isMobile,
                    isTablet,
                    bodyFontSize,
                    iconSize,
                    padding * 0.8,
                  ),

                  SizedBox(height: spacing),

                  // Resultados responsive
                  Expanded(
                    child: _buildResponsiveSearchResults(
                      dialogContext,
                      isMobile,
                      isTablet,
                      bodyFontSize,
                      spacing,
                      screenWidth,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildResponsiveHeader(
    BuildContext dialogContext,
    bool isMobile,
    bool isTablet,
    double titleFontSize,
    double iconSize,
    double spacing,
  ) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.search, color: Colors.green, size: iconSize),
            SizedBox(width: spacing * 0.6),
            Expanded(
              child: Text(
                isMobile ? 'Buscar Producto' : 'Buscar Producto por Nombre',
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: isMobile ? 2 : 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              icon: Icon(Icons.close, size: iconSize * 0.9),
              onPressed: () {
                _searchController.clear();
                Navigator.of(dialogContext).pop();
              },
              padding: EdgeInsets.all(isMobile ? 8 : 12),
            ),
          ],
        ),

        // Divider solo en móvil para mejor separación
        if (isMobile) ...[
          const SizedBox(height: 8),
          Divider(color: Colors.grey[300]),
        ],
      ],
    );
  }

  Widget _buildResponsiveDescription(double fontSize, bool isMobile) {
    return Text(
      isMobile
          ? 'Busca productos por nombre:'
          : 'Busca productos por nombre para agregarlos al carrito:',
      style: TextStyle(
        fontSize: fontSize,
        color: Colors.grey[600],
        height: 1.3,
      ),
    );
  }

  Widget _buildResponsiveSearchField(
    bool isMobile,
    bool isTablet,
    double fontSize,
    double iconSize,
    double contentPadding,
  ) {
    return TextField(
      controller: _searchController,
      autofocus:
          !isMobile, // No autofocus en móvil para evitar problemas de teclado
      style: TextStyle(fontSize: fontSize + 2),
      decoration: InputDecoration(
        labelText: 'Nombre del producto',
        labelStyle: TextStyle(fontSize: fontSize),
        hintText: isMobile
            ? 'Ej: Coca Cola...'
            : 'Ej: Coca Cola, Pan, Leche...',
        hintStyle: TextStyle(fontSize: fontSize, color: Colors.grey[400]),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
          borderSide: const BorderSide(color: Colors.green, width: 2),
        ),
        prefixIcon: Icon(
          Icons.inventory_2,
          size: iconSize * 0.9,
          color: Colors.green,
        ),
        suffixIcon: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
          ),
          child: IconButton(
            icon: Icon(Icons.search, color: Colors.white, size: iconSize * 0.8),
            onPressed: () {
              final searchTerm = _searchController.text.trim();
              if (searchTerm.isNotEmpty) {
                context.read<ScanCubit>().searchProductsByNameForSale(
                  searchTerm,
                );
              }
            },
          ),
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: contentPadding,
          horizontal: contentPadding + 4,
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      textInputAction: TextInputAction.search,
      onSubmitted: (value) {
        final searchTerm = value.trim();
        if (searchTerm.isNotEmpty) {
          context.read<ScanCubit>().searchProductsByNameForSale(searchTerm);
        }
      },
      onChanged: (value) {
        // Búsqueda en tiempo real con debounce más largo en móvil
        if (value.trim().length >= 2) {
          final delay = isMobile ? 800 : 500; // Más delay en móvil
          Future.delayed(Duration(milliseconds: delay), () {
            if (mounted && _searchController.text.trim() == value.trim()) {
              context.read<ScanCubit>().searchProductsByNameForSale(
                value.trim(),
              );
            }
          });
        }
      },
    );
  }

  Widget _buildResponsiveSearchResults(
    BuildContext dialogContext,
    bool isMobile,
    bool isTablet,
    double fontSize,
    double spacing,
    double screenWidth,
  ) {
    return BlocConsumer<ScanCubit, ScanState>(
      listener: (context, state) {
        if (state is SaleLoaded) {
          Navigator.of(dialogContext).pop();
          _searchController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('✅ Producto agregado al carrito'),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
              behavior: isMobile
                  ? SnackBarBehavior.floating
                  : SnackBarBehavior.fixed,
              margin: isMobile ? const EdgeInsets.all(16) : null,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is ScanLoading) {
          return _buildLoadingState(isMobile, fontSize);
        }

        if (state is ProductSearchResults) {
          return _buildSearchResultsList(
            state.products,
            state.products.length,
            isMobile,
            isTablet,
            fontSize,
            spacing,
            screenWidth,
          );
        }

        if (state is ProductNotFound) {
          return _buildNotFoundState(isMobile, fontSize);
        }

        return _buildInitialState(isMobile, fontSize);
      },
    );
  }

  Widget _buildLoadingState(bool isMobile, double fontSize) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: isMobile ? 32 : 40,
            height: isMobile ? 32 : 40,
            child: const CircularProgressIndicator(color: Colors.green),
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            'Buscando productos...',
            style: TextStyle(fontSize: fontSize, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResultsList(
    List<Product> products,
    int count,
    bool isMobile,
    bool isTablet,
    double fontSize,
    double spacing,
    double screenWidth,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header de resultados
        Container(
          padding: EdgeInsets.symmetric(
            vertical: spacing * 0.5,
            horizontal: isMobile ? 8 : 12,
          ),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.green[200]!),
          ),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green[600],
                size: fontSize + 2,
              ),
              SizedBox(width: spacing * 0.5),
              Text(
                'Resultados encontrados: $count',
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: spacing * 0.8),

        // Lista de productos
        Expanded(
          child: ListView.separated(
            physics: const BouncingScrollPhysics(),
            itemCount: products.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: isMobile ? 6 : 8),
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildSearchResultCard(product, screenWidth);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNotFoundState(bool isMobile, double fontSize) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: isMobile ? 48 : 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            'No se encontraron productos',
            style: TextStyle(
              fontSize: fontSize + 2,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isMobile ? 6 : 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 24),
            child: Text(
              'Intenta con otro término de búsqueda o verifica la escritura',
              style: TextStyle(
                fontSize: fontSize - 1,
                color: Colors.grey[500],
                height: 1.3,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialState(bool isMobile, double fontSize) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search, size: isMobile ? 48 : 64, color: Colors.grey[300]),
          SizedBox(height: isMobile ? 12 : 16),
          Text(
            'Busca productos por nombre',
            style: TextStyle(
              fontSize: fontSize + 1,
              color: Colors.grey[500],
              fontWeight: FontWeight.w500,
            ),
          ),
          if (!isMobile) ...[
            const SizedBox(height: 8),
            Text(
              'Escribe al menos 2 caracteres para iniciar',
              style: TextStyle(fontSize: fontSize - 1, color: Colors.grey[400]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchResultCard(Product product, double screenWidth) {
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    // Dynamic sizing based on breakpoints
    final cardPadding = isMobile
        ? 12.0
        : isTablet
        ? 16.0
        : isDesktop
        ? 18.0
        : 20.0;

    final avatarSize = isMobile
        ? 42.0
        : isTablet
        ? 48.0
        : isDesktop
        ? 52.0
        : 56.0;

    final iconSize = isMobile
        ? 22.0
        : isTablet
        ? 26.0
        : isDesktop
        ? 28.0
        : 30.0;

    final titleSize = isMobile
        ? 14.0
        : isTablet
        ? 16.0
        : isDesktop
        ? 17.0
        : 18.0;

    final priceTagSize = isMobile
        ? 10.0
        : isTablet
        ? 11.0
        : isDesktop
        ? 12.0
        : 13.0;

    final barcodeSize = isMobile
        ? 10.0
        : isTablet
        ? 11.0
        : isDesktop
        ? 12.0
        : 12.0;

    final buttonIconSize = isMobile
        ? 16.0
        : isTablet
        ? 18.0
        : isDesktop
        ? 20.0
        : 22.0;

    final buttonTextSize = isMobile
        ? 12.0
        : isTablet
        ? 13.0
        : isDesktop
        ? 14.0
        : 15.0;

    // Dynamic spacing
    final verticalSpacing = isMobile
        ? 2.0
        : isTablet
        ? 3.0
        : isDesktop
        ? 4.0
        : 5.0;

    final horizontalSpacing = isMobile
        ? 6.0
        : isTablet
        ? 8.0
        : isDesktop
        ? 10.0
        : 12.0;

    // Tag padding
    final tagHorizontalPadding = isMobile
        ? 6.0
        : isTablet
        ? 8.0
        : isDesktop
        ? 10.0
        : 12.0;

    final tagVerticalPadding = isMobile
        ? 2.0
        : isTablet
        ? 3.0
        : isDesktop
        ? 4.0
        : 5.0;

    // Button padding
    final buttonHorizontalPadding = isMobile
        ? 8.0
        : isTablet
        ? 10.0
        : isDesktop
        ? 12.0
        : 14.0;

    final buttonVerticalPadding = isMobile
        ? 6.0
        : isTablet
        ? 7.0
        : isDesktop
        ? 8.0
        : 9.0;

    return Card(
      elevation: isMobile ? 1 : 2,
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 4.0 : 0.0,
        vertical: isMobile ? 2.0 : 4.0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(isMobile ? 8 : 12),
        onTap: product.stockQuantity > 0
            ? () {
                context.read<ScanCubit>().addProductToSaleFromSearch(product);
                Navigator.of(context).pop();
              }
            : null,
        child: Padding(
          padding: EdgeInsets.all(cardPadding),
          child: Row(
            children: [
              // Avatar/Icon
              Container(
                width: avatarSize,
                height: avatarSize,
                decoration: BoxDecoration(
                  color: product.stockQuantity > 0
                      ? Colors.green.shade50
                      : Colors.red.shade50,
                  borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
                  border: Border.all(
                    color: product.stockQuantity > 0
                        ? Colors.green.shade200
                        : Colors.red.shade200,
                    width: 1,
                  ),
                ),
                child: Icon(
                  product.stockQuantity > 0
                      ? Icons.inventory_2
                      : Icons.remove_shopping_cart,
                  color: product.stockQuantity > 0
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                  size: iconSize,
                ),
              ),

              SizedBox(width: horizontalSpacing * 1.5),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product name
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w600,
                        color: product.stockQuantity > 0
                            ? Colors.black87
                            : Colors.grey[600],
                      ),
                      maxLines: isDesktop ? 2 : 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: verticalSpacing),

                    // Price and Stock tags
                    Wrap(
                      spacing: horizontalSpacing,
                      runSpacing: verticalSpacing,
                      children: [
                        // Price tag
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: tagHorizontalPadding,
                            vertical: tagVerticalPadding,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.green.shade200,
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.attach_money,
                                size: priceTagSize + 2,
                                color: Colors.green.shade700,
                              ),
                              Text(
                                product.price.toStringAsFixed(2),
                                style: TextStyle(
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: priceTagSize,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Stock tag
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: tagHorizontalPadding,
                            vertical: tagVerticalPadding,
                          ),
                          decoration: BoxDecoration(
                            color: _getStockColor(
                              product.stockQuantity,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _getStockColor(
                                product.stockQuantity,
                              ).withValues(alpha: 0.3),
                              width: 0.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                _getStockIcon(product.stockQuantity),
                                size: priceTagSize + 2,
                                color: _getStockColor(product.stockQuantity),
                              ),
                              SizedBox(width: 2),
                              Text(
                                'Stock: ${product.stockQuantity}',
                                style: TextStyle(
                                  color: _getStockColor(product.stockQuantity),
                                  fontWeight: FontWeight.bold,
                                  fontSize: priceTagSize,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Barcode (if available)
                    if (product.barcode.isNotEmpty) ...[
                      SizedBox(height: verticalSpacing),
                      Row(
                        children: [
                          Icon(
                            Icons.qr_code,
                            size: barcodeSize + 2,
                            color: Colors.grey[500],
                          ),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Código: ${product.barcode}',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: barcodeSize,
                                fontFamily: 'monospace',
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              SizedBox(width: horizontalSpacing),

              // Add to cart button
              if (isDesktop) ...[
                // Desktop: Full button
                ElevatedButton.icon(
                  onPressed: product.stockQuantity > 0
                      ? () {
                          context.read<ScanCubit>().addProductToSaleFromSearch(
                            product,
                          );
                          Navigator.of(context).pop();
                        }
                      : null,
                  icon: Icon(Icons.add_shopping_cart, size: buttonIconSize),
                  label: Text(
                    'Agregar',
                    style: TextStyle(
                      fontSize: buttonTextSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: product.stockQuantity > 0
                        ? Colors.green
                        : Colors.grey,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: buttonHorizontalPadding,
                      vertical: buttonVerticalPadding,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 1,
                  ),
                ),
              ] else ...[
                // Mobile/Tablet: Icon button
                Container(
                  decoration: BoxDecoration(
                    color: product.stockQuantity > 0
                        ? Colors.green
                        : Colors.grey[400],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    onPressed: product.stockQuantity > 0
                        ? () {
                            context
                                .read<ScanCubit>()
                                .addProductToSaleFromSearch(product);
                            Navigator.of(context).pop();
                          }
                        : null,
                    icon: Icon(
                      Icons.add_shopping_cart,
                      color: Colors.white,
                      size: buttonIconSize,
                    ),
                    tooltip: 'Agregar al carrito',
                    padding: EdgeInsets.all(isMobile ? 8.0 : 10.0),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // Helper methods for stock indicators
  Color _getStockColor(int stock) {
    if (stock <= 0) return Colors.red;
    if (stock < 5) return Colors.orange;
    if (stock < 10) return Colors.amber;
    return Colors.blue;
  }

  IconData _getStockIcon(int stock) {
    if (stock <= 0) return Icons.remove_circle_outline;
    if (stock < 5) return Icons.warning_amber_outlined;
    if (stock < 10) return Icons.inventory_outlined;
    return Icons.inventory_2_outlined;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Sistema de Ventas'),
        backgroundColor: Colors.green.shade700,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: _showProductSearchDialog,
            tooltip: 'Buscar por nombre',
          ),
          IconButton(
            icon: const Icon(Icons.keyboard),
            onPressed: _showManualInputDialog,
            tooltip: 'Ingresar código manual',
          ),
          IconButton(
            icon: Icon(_showScanner ? Icons.visibility : Icons.visibility_off),
            onPressed: () {
              setState(() {
                _showScanner = !_showScanner;
              });
            },
            tooltip: 'Mostrar/Ocultar escáner',
          ),
        ],
      ),
      body: BlocListener<ScanCubit, ScanState>(
        listener: (context, state) {
          if (state is ScanError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          } else if (state is ProductNotFound) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ Producto no encontrado: ${state.barcode}'),
                backgroundColor: Colors.orange,
              ),
            );
          } else if (state is SaleCompleted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Venta realizada exitosamente'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: Column(
          children: [
            // Escáner (opcional)
            if (_showScanner) ...[
              Container(
                height: 200,
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
            ],

            // Lista de productos y total
            Expanded(
              child: BlocBuilder<ScanCubit, ScanState>(
                builder: (context, state) {
                  if (state is ScanLoading) {
                    return const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: Colors.green),
                          SizedBox(height: 16),
                          Text('Procesando...'),
                        ],
                      ),
                    );
                  }

                  if (state is SaleLoaded) {
                    return _buildSaleContent(state.items, state.totalAmount);
                  }

                  return _buildEmptyState();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            'Carrito vacío',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Escanea productos para comenzar una venta',
            style: TextStyle(fontSize: 16, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSaleContent(List<SaleItem> items, double totalAmount) {
    return Column(
      children: [
        // Header con resumen
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            border: Border(bottom: BorderSide(color: Colors.green.shade200)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Productos: ${items.length}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Cantidad total: ${items.fold(0, (sum, item) => sum + item.quantity)}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total:',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Text(
                    '\$${NumberFormat('#,##0.00').format(totalAmount)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Lista de productos
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildProductCard(item);
            },
          ),
        ),

        // Botón de venta
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.2),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<ScanCubit>().clearSale();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        foregroundColor: Colors.black87,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Limpiar'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: items.isEmpty
                          ? null
                          : () {
                              context.read<ScanCubit>().completeSale();
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Realizar Venta',
                        style: TextStyle(
                          fontSize: 16,
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
      ],
    );
  }

  Widget _buildProductCard(SaleItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Precio: \$${NumberFormat('#,##0.00').format(item.unitPrice)}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                // Controles de cantidad
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          context.read<ScanCubit>().updateItemQuantity(
                            item.productId,
                            item.quantity - 1,
                          );
                        },
                        icon: const Icon(Icons.remove),
                        iconSize: 20,
                      ),
                      Container(
                        constraints: const BoxConstraints(minWidth: 40),
                        child: Text(
                          '${item.quantity}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context.read<ScanCubit>().updateItemQuantity(
                            item.productId,
                            item.quantity + 1,
                          );
                        },
                        icon: const Icon(Icons.add),
                        iconSize: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    context.read<ScanCubit>().removeItem(item.productId);
                  },
                  icon: const Icon(Icons.delete, color: Colors.red),
                  label: const Text(
                    'Eliminar',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                Text(
                  'Subtotal: \$${NumberFormat('#,##0.00').format(item.subtotal)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

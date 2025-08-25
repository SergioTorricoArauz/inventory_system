import 'package:flutter/material.dart';
import '../../../scan/presentation/pages/sales_page.dart';
import 'admin_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width >= 768;
    final isDesktop = screenSize.width >= 1024;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sistema de Inventario',
          style: TextStyle(fontSize: isTablet ? 22 : 18),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade700,
        foregroundColor: Colors.white,
        toolbarHeight: isTablet ? 70 : 56,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.white],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: isDesktop ? 800 : (isTablet ? 600 : double.infinity),
              ),
              child: Padding(
                padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
                child: isDesktop
                    ? _buildDesktopLayout(context, isTablet)
                    : _buildMobileLayout(context, isTablet),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, bool isTablet) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHeader(isTablet),
        SizedBox(height: isTablet ? 64 : 48),
        _buildMenuCard(
          context,
          title: 'Ventas',
          subtitle: 'Escanear productos y gestionar ventas',
          icon: Icons.point_of_sale,
          color: Colors.green,
          isTablet: isTablet,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SalesPage()),
          ),
        ),
        SizedBox(height: isTablet ? 24 : 16),
        _buildMenuCard(
          context,
          title: 'Administrar',
          subtitle: 'Configuración y gestión del sistema',
          icon: Icons.admin_panel_settings,
          color: Colors.orange,
          isTablet: isTablet,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AdminPage()),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, bool isTablet) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildHeader(true),
        const SizedBox(height: 64),
        Row(
          children: [
            Expanded(
              child: _buildMenuCard(
                context,
                title: 'Ventas',
                subtitle: 'Escanear productos y gestionar ventas',
                icon: Icons.point_of_sale,
                color: Colors.green,
                isTablet: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SalesPage()),
                ),
              ),
            ),
            const SizedBox(width: 32),
            Expanded(
              child: _buildMenuCard(
                context,
                title: 'Administrar',
                subtitle: 'Configuración y gestión del sistema',
                icon: Icons.admin_panel_settings,
                color: Colors.orange,
                isTablet: true,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AdminPage()),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader(bool isTablet) {
    return Column(
      children: [
        Icon(Icons.inventory_2, size: isTablet ? 120 : 80, color: Colors.blue),
        SizedBox(height: isTablet ? 32 : 24),
        Text(
          'Bienvenido al Sistema de Inventario',
          style: TextStyle(
            fontSize: isTablet ? 32 : 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: isTablet ? 16 : 8),
        Text(
          'Selecciona una opción para continuar',
          style: TextStyle(fontSize: isTablet ? 20 : 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildMenuCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isTablet,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: isTablet ? 12 : 8,
      shadowColor: color.withValues(alpha: 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(isTablet ? 20 : 16),
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: isTablet ? 200 : 160),
          padding: EdgeInsets.all(isTablet ? 32 : 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(isTablet ? 24 : 16),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: isTablet ? 56 : 40, color: color),
              ),
              SizedBox(height: isTablet ? 24 : 16),
              Text(
                title,
                style: TextStyle(
                  fontSize: isTablet ? 28 : 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              SizedBox(height: isTablet ? 12 : 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

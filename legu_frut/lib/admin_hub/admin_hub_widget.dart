import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'admin_hub_model.dart';
export 'admin_hub_model.dart';

class AdminHubWidget extends StatefulWidget {
  const AdminHubWidget({super.key});

  static String routeName = 'AdminHub';
  static String routePath = '/adminHub';

  @override
  State<AdminHubWidget> createState() => _AdminHubWidgetState();
}

class _AdminHubWidgetState extends State<AdminHubWidget> {
  late AdminHubModel _model;

  static const _kDarkGreen = Color(0xFF2D5016);
  static const _kGreen = Color(0xFF2E7D32);
  static const _kBg = Color(0xFFF8F4EF);
  static const _kText = Color(0xFF1A1A1A);
  static const _kMuted = Color(0xFF6B7280);

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdminHubModel());
    actions.enforceRole(context);
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Scaffold(
      backgroundColor: _kBg,
      body: Column(
        children: [
          // ── Hero header ──────────────────────────────────────────
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: _kDarkGreen,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back button row
                    GestureDetector(
                      onTap: () => context.pushNamed(HomePageWidget.routeName),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.arrow_back_rounded,
                              color: Colors.white70, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            'Inicio',
                            style: GoogleFonts.inter(
                                color: Colors.white70, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Legufrut logo + name
                    Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.storefront_rounded,
                              color: Colors.white, size: 26),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Panel de Administrador',
                              style: GoogleFonts.interTight(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -0.3,
                              ),
                            ),
                            Text(
                              'Elige qué quieres gestionar',
                              style: GoogleFonts.inter(
                                color: Colors.white60,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Cards ────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                children: [
                  _buildCard(
                    icon: Icons.inventory_2_rounded,
                    iconBg: const Color(0xFFE8F5E9),
                    iconColor: _kGreen,
                    title: 'Gestor de Productos',
                    description:
                        'Agrega nuevos productos, busca y edita precios de tu inventario por categoría.',
                    tag: 'Inventario',
                    tagColor: _kGreen,
                    onTap: () =>
                        context.pushNamed(AdmincreateproductWidget.routeName),
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    icon: Icons.receipt_long_rounded,
                    iconBg: const Color(0xFFFFF8E1),
                    iconColor: Color(0xFFE65100),
                    title: 'Panel de Órdenes',
                    description:
                        'Ve los pedidos pendientes, en preparación y entregados. Asigna repartidores y consulta detalles.',
                    tag: 'Pedidos',
                    tagColor: Color(0xFFE65100),
                    onTap: () =>
                        context.pushNamed(OrdenesAdminWidget.routeName),
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    icon: Icons.campaign_rounded,
                    iconBg: const Color(0xFFE8EAF6),
                    iconColor: Color(0xFF3949AB),
                    title: 'Alerta Principal',
                    description:
                        'Configura el aviso que ven los clientes al abrir la aplicación. Edita título y mensaje.',
                    tag: 'Comunicación',
                    tagColor: Color(0xFF3949AB),
                    onTap: () =>
                        context.pushNamed(RecuadroAlertaWidget.routeName),
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    icon: Icons.local_shipping_rounded,
                    iconBg: const Color(0xFFE0F2F1),
                    iconColor: Color(0xFF00695C),
                    title: 'Conductores',
                    description:
                        'Asigna conductores por correo, monitorea sus pedidos activos y paradas pendientes en tiempo real.',
                    tag: 'Repartos',
                    tagColor: Color(0xFF00695C),
                    onTap: () => context.pushNamed(ConductoresWidget.routeName),
                  ),
                  const SizedBox(height: 16),
                  _buildCard(
                    icon: Icons.menu_book_rounded,
                    iconBg: const Color(0xFFFFF8E1),
                    iconColor: Color(0xFFF57F17),
                    title: 'Recetas',
                    description:
                        'Crea, edita y elimina las recetas que ven los clientes. Gestiona ingredientes y tiempos de preparación.',
                    tag: 'Contenido',
                    tagColor: Color(0xFFF57F17),
                    onTap: () =>
                        context.pushNamed(RecetasAdminWidget.routeName),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String description,
    required String tag,
    required Color tagColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 16),

              // Text content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: tagColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.interTight(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: tagColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Title
                    Text(
                      title,
                      style: GoogleFonts.interTight(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: _kText,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Description
                    Text(
                      description,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: _kMuted,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Arrow
              const Icon(Icons.arrow_forward_ios_rounded,
                  size: 16, color: Color(0xFFD1D5DB)),
            ],
          ),
        ),
      ),
    );
  }
}

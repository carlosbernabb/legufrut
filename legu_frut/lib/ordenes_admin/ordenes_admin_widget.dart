import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'ordenes_admin_model.dart';
export 'ordenes_admin_model.dart';

class OrdenesAdminWidget extends StatefulWidget {
  const OrdenesAdminWidget({super.key});

  static String routeName = 'Ordenes-Admin';
  static String routePath = '/ordenesAdmin';

  @override
  State<OrdenesAdminWidget> createState() => _OrdenesAdminWidgetState();
}

class _OrdenesAdminWidgetState extends State<OrdenesAdminWidget>
    with TickerProviderStateMixin {
  late OrdenesAdminModel _model;

  // ── Colors ───────────────────────────────────────────────────
  static const _kDarkGreen = Color(0xFF2D5016);
  static const _kGreen = Color(0xFF2E7D32);
  static const _kGreenLight = Color(0xFFE8F5E9);
  static const _kBg = Color(0xFFF8F4EF);
  static const _kText = Color(0xFF1A1A1A);
  static const _kMuted = Color(0xFF6B7280);
  static const _kBorder = Color(0xFFE5E7EB);
  static const _kRed = Color(0xFFEF5350);

  // ── Status colors ────────────────────────────────────────────
  static const _statusPendiente = Color(0xFFFF8F00);
  static const _statusPreparando = Color(0xFF1565C0);
  static const _statusEntregado = Color(0xFF2E7D32);

  // ── Drivers ──────────────────────────────────────────────────
  static const _drivers = ['Driver #1', 'Driver #2', 'Driver #3'];
  static const _driverColors = [
    Color(0xFF7B1FA2),
    Color(0xFF1565C0),
    Color(0xFF00838F),
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrdenesAdminModel());
    _model.tabBarController = TabController(vsync: this, length: 3)
      ..addListener(() => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // ── Actions ──────────────────────────────────────────────────

  Future<void> _assignDriver(OrdersRecord order, String driver) async {
    await order.reference.update(createOrdersRecordData(
      driverTag: driver,
      status: 'Reparto',
      driverStatusText: 'En preparación',
    ));
  }

  Future<void> _deleteOrder(OrdersRecord order) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Eliminar orden',
            style: GoogleFonts.interTight(fontWeight: FontWeight.w700)),
        content: Text(
            '¿Eliminar la orden de ${order.nombrecliente.isNotEmpty ? order.nombrecliente : "este cliente"}? Esta acción no se puede deshacer.',
            style: GoogleFonts.inter(color: _kMuted, fontSize: 13)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar',
                style: GoogleFonts.inter(color: _kMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Eliminar',
                style: GoogleFonts.inter(
                    color: _kRed, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await order.reference.delete();
  }

  void _toggleAddress(OrdersRecord order) async {
    await order.reference
        .update(createOrdersRecordData(showorder: !order.showorder));
  }

  // ── BUILD ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kDarkGreen,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pushNamed(AdminHubWidget.routeName),
        ),
        title: Text(
          'Panel de Órdenes',
          style: GoogleFonts.interTight(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Tab bar ─────────────────────────────────────────
          Container(
            color: _kDarkGreen,
            child: TabBar(
              controller: _model.tabBarController,
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white54,
              labelStyle: GoogleFonts.interTight(
                  fontSize: 14, fontWeight: FontWeight.w700),
              unselectedLabelStyle:
                  GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500),
              tabs: const [
                Tab(text: 'Pendientes'),
                Tab(text: 'Preparando'),
                Tab(text: 'Entregados'),
              ],
            ),
          ),

          // ── Tab views ───────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _model.tabBarController,
              children: [
                _buildOrderList(
                  queryBuilder: (q) => q
                      .where('status', isEqualTo: 'Pendiente')
                      .orderBy('createdAt', descending: true),
                  tabType: _TabType.pendiente,
                ),
                _buildOrderList(
                  queryBuilder: (q) => q
                      .where('status', isEqualTo: 'Reparto')
                      .orderBy('createdAt', descending: true),
                  tabType: _TabType.preparando,
                ),
                _buildOrderList(
                  queryBuilder: (q) => q
                      .where('driverStatusText',
                          isEqualTo: 'Su pedido ha llegado')
                      .orderBy('createdAt', descending: true),
                  tabType: _TabType.entregado,
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── ORDER LIST ───────────────────────────────────────────────

  Widget _buildOrderList({
    required Query Function(Query) queryBuilder,
    required _TabType tabType,
  }) {
    return StreamBuilder<List<OrdersRecord>>(
      stream: queryOrdersRecord(
        queryBuilder: queryBuilder,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
              child: CircularProgressIndicator(color: _kGreen));
        }

        final orders = snapshot.data!;
        if (orders.isEmpty) {
          return _buildEmpty(tabType);
        }

        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          itemCount: orders.length,
          itemBuilder: (context, i) =>
              _buildOrderCard(orders[i], tabType),
        );
      },
    );
  }

  Widget _buildEmpty(_TabType tabType) {
    final labels = {
      _TabType.pendiente: ('Sin órdenes pendientes', Icons.pending_actions_outlined),
      _TabType.preparando: ('Sin órdenes en preparación', Icons.local_shipping_outlined),
      _TabType.entregado: ('Sin órdenes entregadas', Icons.check_circle_outline),
    };
    final (text, icon) = labels[tabType]!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: _kBorder, size: 56),
          const SizedBox(height: 12),
          Text(text,
              style: GoogleFonts.inter(color: _kMuted, fontSize: 15)),
        ],
      ),
    );
  }

  // ── ORDER CARD ───────────────────────────────────────────────

  Widget _buildOrderCard(OrdersRecord order, _TabType tabType) {
    final shortId = order.reference.id.length > 8
        ? order.reference.id.substring(0, 8).toUpperCase()
        : order.reference.id.toUpperCase();

    final statusColor = tabType == _TabType.pendiente
        ? _statusPendiente
        : tabType == _TabType.preparando
            ? _statusPreparando
            : _statusEntregado;

    final statusLabel = tabType == _TabType.pendiente
        ? 'Pendiente'
        : tabType == _TabType.entregado
            ? 'Entregado'
            : order.driverStatusText.isNotEmpty
                ? order.driverStatusText
                : 'En preparación';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Card header ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left: order info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 7,
                              height: 7,
                              decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              statusLabel,
                              style: GoogleFonts.interTight(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: statusColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Order ID + timestamp
                      Row(
                        children: [
                          Text(
                            'Orden #$shortId',
                            style: GoogleFonts.interTight(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: _kText,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '···',
                            style: GoogleFonts.inter(
                                color: _kMuted, fontSize: 12),
                          ),
                        ],
                      ),

                      // Customer name
                      if (order.nombrecliente.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            order.nombrecliente,
                            style: GoogleFonts.inter(
                                fontSize: 13, color: _kMuted),
                          ),
                        ),

                      // Date
                      if (order.createdAt != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time,
                                  size: 12, color: _kMuted),
                              const SizedBox(width: 3),
                              Text(
                                dateTimeFormat('d MMM, HH:mm',
                                    order.createdAt!),
                                style: GoogleFonts.inter(
                                    fontSize: 12, color: _kMuted),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),

                // Right: total + actions
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${order.subtotal.toStringAsFixed(2)}',
                      style: GoogleFonts.interTight(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: _kGreen,
                      ),
                    ),
                    if (order.shippingFee > 0)
                      Text(
                        '+ \$${order.shippingFee.toStringAsFixed(2)} envío',
                        style: GoogleFonts.inter(
                            fontSize: 11, color: _kMuted),
                      ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        // Eye toggle
                        GestureDetector(
                          onTap: () => _toggleAddress(order),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: order.showorder
                                  ? _kGreenLight
                                  : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              order.showorder
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              color: order.showorder ? _kGreen : _kMuted,
                              size: 18,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Delete
                        GestureDetector(
                          onTap: () => _deleteOrder(order),
                          child: Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: _kRed.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                                Icons.delete_outline_rounded,
                                color: _kRed,
                                size: 18),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // ── Driver info (Preparando/Entregado) ─────────────
          if (tabType != _TabType.pendiente &&
              order.driverTag.isNotEmpty) ...[
            const Divider(height: 1, color: _kBorder),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
              child: Row(
                children: [
                  const Icon(Icons.delivery_dining_rounded,
                      size: 16, color: _kMuted),
                  const SizedBox(width: 6),
                  Text(
                    'Asignado a: ',
                    style: GoogleFonts.inter(fontSize: 12, color: _kMuted),
                  ),
                  Text(
                    order.driverTag,
                    style: GoogleFonts.interTight(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: _kText),
                  ),
                  if (order.driverStatusText.isNotEmpty &&
                      tabType == _TabType.preparando) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: _statusPreparando.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        order.driverStatusText,
                        style: GoogleFonts.interTight(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: _statusPreparando,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],

          // ── Expanded detail (products + address) controlled by eye toggle ──
          if (order.showorder)
            StreamBuilder<List<OrdersitemsRecord>>(
              stream: queryOrdersitemsRecord(parent: order.reference),
              builder: (context, snap) {
                final items = snap.data ?? [];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Products ──────────────────────────────
                    if (items.isNotEmpty) ...[
                      const Divider(height: 1, color: _kBorder),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(14, 8, 14, 4),
                        child: Row(
                          children: [
                            const Icon(Icons.shopping_basket_rounded,
                                size: 14, color: _kMuted),
                            const SizedBox(width: 6),
                            Text(
                              '${items.length} producto${items.length == 1 ? '' : 's'}',
                              style: GoogleFonts.interTight(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: _kMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                      ...items.map((item) => _buildItemRow(item)),
                      const SizedBox(height: 4),
                    ],

                    // ── Address ───────────────────────────────
                    const Divider(height: 1, color: _kBorder),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.location_on_rounded,
                                  size: 14, color: _kMuted),
                              const SizedBox(width: 4),
                              Text(
                                'Dirección de entrega',
                                style: GoogleFonts.interTight(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: _kMuted,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F8F0),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: _kBorder),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _addressRow('Calle',
                                    '${order.street} ${order.number}'.trim()),
                                if (order.neighborhood.isNotEmpty)
                                  _addressRow('Colonia', order.neighborhood),
                                if (order.postalCode.isNotEmpty)
                                  _addressRow('C.P.', order.postalCode),
                                if (order.referenceNote.isNotEmpty)
                                  _addressRow(
                                      'Referencia', order.referenceNote),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

          // ── Driver assignment buttons (Pendientes only) ─────
          if (tabType == _TabType.pendiente) ...[
            const Divider(height: 1, color: _kBorder),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Asignar a repartidor',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _kMuted),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: List.generate(
                      _drivers.length,
                      (i) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(
                              right: i < _drivers.length - 1 ? 8 : 0),
                          child: GestureDetector(
                            onTap: () =>
                                _assignDriver(order, _drivers[i]),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 9),
                              decoration: BoxDecoration(
                                color: _driverColors[i],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                _drivers[i],
                                textAlign: TextAlign.center,
                                style: GoogleFonts.interTight(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ── Bottom padding for Preparando/Entregado ─────────
          if (tabType != _TabType.pendiente)
            const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildItemRow(OrdersitemsRecord item) {
    final isKg = item.unitType == 'Gramos';
    final qty = isKg
        ? (item.grams >= 1000
            ? '${(item.grams / 1000).toStringAsFixed(2)} kg'
            : '${item.grams.toStringAsFixed(0)} g')
        : '${item.grams.toStringAsFixed(0)} pzas';

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              item.coverimage,
              width: 48,
              height: 48,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _kGreenLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.image_not_supported_outlined,
                    color: _kGreen, size: 20),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: GoogleFonts.interTight(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _kText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  qty,
                  style: GoogleFonts.inter(fontSize: 12, color: _kMuted),
                ),
              ],
            ),
          ),
          Text(
            '\$${item.unitPrice.toStringAsFixed(2)}',
            style: GoogleFonts.interTight(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: _kGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressRow(String label, String value) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _kText),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.inter(fontSize: 12, color: _kMuted),
            ),
          ),
        ],
      ),
    );
  }
}

enum _TabType { pendiente, preparando, entregado }

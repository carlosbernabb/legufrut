import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'notificaciones_model.dart';
export 'notificaciones_model.dart';

class NotificacionesWidget extends StatefulWidget {
  const NotificacionesWidget({super.key});

  static String routeName = 'Notificaciones';
  static String routePath = '/notificaciones';

  @override
  State<NotificacionesWidget> createState() => _NotificacionesWidgetState();
}

class _NotificacionesWidgetState extends State<NotificacionesWidget> {
  late NotificacionesModel _model;

  static const _kDarkGreen = Color(0xFF2D5016);
  static const _kGreen = Color(0xFF2E7D32);
  static const _kGreenLight = Color(0xFFE8F5E9);
  static const _kBg = Color(0xFFF8F4EF);
  static const _kText = Color(0xFF1A1A1A);
  static const _kMuted = Color(0xFF6B7280);
  static const _kBorder = Color(0xFFE5E7EB);
  static const _kRed = Color(0xFFEF5350);

  static String _fmtQty(double grams, String unitType) {
    if (unitType == 'Piezas') {
      return '${grams.toStringAsFixed(0)} pzas';
    }
    if (grams >= 1000) {
      final kg = grams / 1000;
      return '${kg == kg.roundToDouble() ? kg.toStringAsFixed(0) : kg.toStringAsFixed(2)} kg';
    }
    return '${grams.toStringAsFixed(0)} g';
  }

  // Status steps
  static const _steps = [
    'Recibido',
    'En preparación',
    'En camino',
    'Entregado',
  ];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificacionesModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // How many steps are complete for this order
  int _stepIndex(OrdersRecord order) {
    if (order.driverStatusText == 'Su pedido ha llegado') return 4;
    if (order.driverStatusText == 'En camino') return 3;
    if (order.status == 'Reparto') return 2;
    return 1;
  }

  Color _statusColor(int step) {
    if (step == 4) return _kGreen;
    if (step == 3) return const Color(0xFF0277BD);
    if (step == 2) return const Color(0xFFE65100);
    return const Color(0xFFFF8F00);
  }

  String _statusLabel(OrdersRecord order) {
    if (order.status == 'Cancelado') return 'Cancelado';
    if (order.status == 'Confirmado') return 'Confirmado ✓';
    if (order.driverStatusText.isNotEmpty) return order.driverStatusText;
    if (order.status == 'Reparto') return 'En preparación';
    return 'Pendiente';
  }

  Color _statusColorForOrder(OrdersRecord order) {
    if (order.status == 'Cancelado') return _kRed;
    final step = _stepIndex(order);
    return _statusColor(step);
  }

  Future<void> _cancelOrder(OrdersRecord order) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Cancelar pedido',
            style: GoogleFonts.interTight(fontWeight: FontWeight.w700)),
        content: Text(
          '¿Cancelar la orden #${order.reference.id.substring(0, 8).toUpperCase()}? Esta acción no se puede deshacer.',
          style: GoogleFonts.inter(color: _kMuted, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('No cancelar',
                style: GoogleFonts.inter(color: _kMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Cancelar pedido',
                style: GoogleFonts.inter(
                    color: _kRed, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (confirm != true) return;

    // Delete order items then order
    final items = await queryOrdersitemsRecordOnce(
      parent: order.reference,
    );
    for (final item in items) {
      await item.reference.delete();
    }
    await order.reference.delete();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Scaffold(
      backgroundColor: _kBg,
      appBar: AppBar(
        backgroundColor: _kDarkGreen,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => context.pushNamed(HomePageWidget.routeName),
        ),
        title: Text(
          'Mis Pedidos',
          style: GoogleFonts.interTight(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: StreamBuilder<List<OrdersRecord>>(
        stream: queryOrdersRecord(
          queryBuilder: (q) => q
              .where('userRef', isEqualTo: currentUserReference)
              .orderBy('createdAt', descending: true),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: _kGreen),
            );
          }

          final orders = snapshot.data!;

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 72, color: _kBorder),
                  const SizedBox(height: 16),
                  Text('Sin pedidos aún',
                      style: GoogleFonts.interTight(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: _kText)),
                  const SizedBox(height: 6),
                  Text('Tus pedidos aparecerán aquí',
                      style: GoogleFonts.inter(
                          fontSize: 14, color: _kMuted)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            itemCount: orders.length,
            itemBuilder: (context, i) => _buildOrderCard(orders[i]),
          );
        },
      ),
    );
  }

  Widget _buildOrderCard(OrdersRecord order) {
    final step = _stepIndex(order);
    final isCancelado = order.status == 'Cancelado';
    final statusColor = _statusColorForOrder(order);
    final shortId = order.reference.id.length > 8
        ? order.reference.id.substring(0, 8).toUpperCase()
        : order.reference.id.toUpperCase();
    final canCancel = !isCancelado &&
        (order.status != 'Reparto' ||
            order.driverStatusText == '' ||
            order.driverStatusText == 'En preparación');

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top bar: status + ID + date ────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                              _statusLabel(order),
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
                      Text(
                        'Pedido #$shortId',
                        style: GoogleFonts.interTight(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _kText,
                          letterSpacing: -0.3,
                        ),
                      ),
                      if (order.createdAt != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Row(
                            children: [
                              const Icon(Icons.access_time_rounded,
                                  size: 12, color: _kMuted),
                              const SizedBox(width: 3),
                              Text(
                                dateTimeFormat(
                                    'd MMM yyyy, HH:mm', order.createdAt!),
                                style: GoogleFonts.inter(
                                    fontSize: 12, color: _kMuted),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                // Total
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
                  ],
                ),
              ],
            ),
          ),

          // ── Cancelled banner ──────────────────────────────
          if (isCancelado) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _kRed.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _kRed.withOpacity(0.35)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.cancel_rounded, color: _kRed, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tu pedido fue cancelado',
                            style: GoogleFonts.interTight(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _kRed,
                            ),
                          ),
                          if (order.cancelReason.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                order.cancelReason,
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: _kRed.withOpacity(0.8),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // ── Confirmed total banner ─────────────────────────
          if (order.status == 'Confirmado') ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _kGreenLight,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _kGreen.withOpacity(0.35)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded,
                        color: _kGreen, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Pedido confirmado por el negocio',
                            style: GoogleFonts.interTight(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _kGreen,
                            ),
                          ),
                          if (order.hasConfirmedTotal())
                            Text(
                              'Total real: \$${order.confirmedTotal.toStringAsFixed(2)}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: _kGreen,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],

          // ── Progress timeline (not shown for cancelled orders) ─
          if (!isCancelado)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
              child: _buildTimeline(step, order.status == 'Confirmado' ? _kGreen : statusColor),
            ),

          // ── Delivery note (when on the way) ───────────────
          if (step >= 3) ...[
            const Divider(height: 1, color: _kBorder),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Row(
                children: [
                  Icon(
                    step == 4
                        ? Icons.check_circle_rounded
                        : Icons.delivery_dining_rounded,
                    size: 16,
                    color: statusColor,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    step == 4
                        ? 'Tu pedido ha llegado. ¡Prepara tu pago!'
                        : 'Tu pedido está en camino. ¡Prepara tu pago!',
                    style: GoogleFonts.interTight(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: statusColor,
                    ),
                  ),
                ],
              ),
            ),
          ],

          // ── Order items (expandable) ───────────────────────
          StreamBuilder<List<OrdersitemsRecord>>(
            stream: queryOrdersitemsRecord(parent: order.reference),
            builder: (context, snap) {
              if (!snap.hasData || snap.data!.isEmpty) {
                return const SizedBox.shrink();
              }
              final items = snap.data!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1, color: _kBorder),

                  // Toggle header
                  InkWell(
                    onTap: () async {
                      await order.reference.update(
                          createOrdersRecordData(
                              showorder: !order.showorder));
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      child: Row(
                        children: [
                          const Icon(Icons.shopping_basket_rounded,
                              size: 16, color: _kMuted),
                          const SizedBox(width: 8),
                          Text(
                            '${items.length} producto${items.length == 1 ? '' : 's'}',
                            style: GoogleFonts.interTight(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: _kText,
                            ),
                          ),
                          const Spacer(),
                          Icon(
                            order.showorder
                                ? Icons.keyboard_arrow_up_rounded
                                : Icons.keyboard_arrow_down_rounded,
                            size: 20,
                            color: _kMuted,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Items list
                  if (order.showorder)
                    ...items.map((item) => _buildItemRow(item)),
                ],
              );
            },
          ),

          // ── Bottom actions ────────────────────────────────
          if (canCancel) ...[
            const Divider(height: 1, color: _kBorder),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              child: GestureDetector(
                onTap: () => _cancelOrder(order),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    color: _kRed.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(10),
                    border:
                        Border.all(color: _kRed.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.cancel_outlined,
                          size: 16, color: _kRed),
                      const SizedBox(width: 6),
                      Text(
                        'Cancelar pedido',
                        style: GoogleFonts.interTight(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _kRed,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ] else
            const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildTimeline(int completedStep, Color activeColor) {
    return Row(
      children: List.generate(_steps.length, (i) {
        final done = i < completedStep;
        final active = i == completedStep - 1;
        final isLast = i == _steps.length - 1;

        return Expanded(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    // Dot
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: done ? activeColor : Colors.white,
                        border: Border.all(
                          color: done ? activeColor : _kBorder,
                          width: 2,
                        ),
                      ),
                      child: done
                          ? Icon(Icons.check_rounded,
                              size: 11, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _steps[i],
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: active
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: done ? activeColor : _kMuted,
                      ),
                    ),
                  ],
                ),
              ),
              // Connector line
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    margin: const EdgeInsets.only(bottom: 18),
                    color: i < completedStep - 1 ? activeColor : _kBorder,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildItemRow(OrdersitemsRecord item) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
      child: Row(
        children: [
          // Product image
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              item.coverimage,
              width: 54,
              height: 54,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: _kGreenLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.image_not_supported_outlined,
                    color: _kGreen, size: 22),
              ),
            ),
          ),
          const SizedBox(width: 12),

          // Name + quantity
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productName,
                  style: GoogleFonts.interTight(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _kText,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  _fmtQty(item.grams, item.unitType),
                  style: GoogleFonts.inter(
                      fontSize: 12, color: _kMuted),
                ),
              ],
            ),
          ),

          // Price
          Text(
            '\$${item.unitPrice.toStringAsFixed(2)}',
            style: GoogleFonts.interTight(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: _kGreen,
            ),
          ),
        ],
      ),
    );
  }
}

import '/backend/backend.dart';
import '/backend/push_notifications/push_notifications_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_google_map.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:async';
import 'dart:math';
import '/index.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'driver_panel_model.dart';
export 'driver_panel_model.dart';

class DriverPanelWidget extends StatefulWidget {
  const DriverPanelWidget({super.key});

  static String routeName = 'DriverPanel';
  static String routePath = '/driverPanel';

  @override
  State<DriverPanelWidget> createState() => _DriverPanelWidgetState();
}

class _DriverPanelWidgetState extends State<DriverPanelWidget>
    with TickerProviderStateMixin {
  late DriverPanelModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  static const _kDarkGreen = Color(0xFF2D5016);
  static const _kGreen = Color(0xFF2E7D32);
  static const _kGreenLight = Color(0xFFE8F5E9);
  static const _kBg = Color(0xFFF8F4EF);
  static const _kText = Color(0xFF1A1A1A);
  static const _kMuted = Color(0xFF6B7280);
  static const _kBorder = Color(0xFFE5E7EB);
  static const _kBlue = Color(0xFF1565C0);
  static const _kBlueLight = Color(0xFFE3F2FD);
  static const _kOrange = Color(0xFFE65100);
  static const _kOrangeLight = Color(0xFFFFF3E0);

  final Set<String> _expandedOrders = {};

  // GPS tracking state
  Timer? _locationTimer;
  int _myDriverSlot = 0;
  bool _locationActive = false;
  final Set<String> _proximityDelivered = {};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DriverPanelModel());
    actions.enforceRole(context, allowDriver: true);

    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _loadDriverPoints(1);
      await _initDriverSlot();
    });

    _model.tabBarController = TabController(
      vsync: this,
      length: 3,
      initialIndex: 0,
    )..addListener(() => safeSetState(() {}));
  }

  // ─── GPS TRACKING ─────────────────────────────────────────────────────────

  Future<void> _initDriverSlot() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    final slot = doc.data()?['driverSlot'] as int?;
    if (slot != null && slot > 0) {
      if (mounted) safeSetState(() => _myDriverSlot = slot);
      // GPS does NOT start automatically — driver must tap "Empezar ruta"
    }
  }

  Future<void> _startLocationTracking() async {
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.denied ||
          perm == LocationPermission.deniedForever) return;

      await _updateLocation();
      _locationTimer =
          Timer.periodic(const Duration(seconds: 30), (_) => _updateLocation());
      if (mounted) safeSetState(() => _locationActive = true);
    } catch (_) {}
  }

  Future<void> _updateLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high),
      );
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid != null) {
        // Update user document (existing)
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'driverLatLng': GeoPoint(position.latitude, position.longitude),
          'driverLastUpdate': FieldValue.serverTimestamp(),
        });
        // Write to driverLocations so the admin map can show real-time position
        if (_myDriverSlot > 0) {
          await FirebaseFirestore.instance
              .collection('driverLocations')
              .doc(uid)
              .set({
            'driverTag': 'Driver #$_myDriverSlot',
            'lat': position.latitude,
            'lng': position.longitude,
            'updatedAt': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      }

      if (_myDriverSlot > 0) await _checkProximity(position);
    } catch (_) {}
  }

  Future<void> _checkProximity(Position driverPos) async {
    final tag = 'Driver #$_myDriverSlot';
    final orders = await queryOrdersRecordOnce(
      queryBuilder: (q) => q
          .where('driverTag', isEqualTo: tag)
          .where('status', isEqualTo: 'Reparto')
          .where('driverStatusText', isEqualTo: 'En camino'),
    );
    for (final order in orders) {
      if (_proximityDelivered.contains(order.reference.id)) continue;
      final loc = order.location;
      if (loc == null) continue;
      final dist = _haversine(
          driverPos.latitude, driverPos.longitude, loc.latitude, loc.longitude);
      if (dist < 150) {
        _proximityDelivered.add(order.reference.id);
        await _markDelivered(order);
      }
    }
  }

  double _haversine(double lat1, double lon1, double lat2, double lon2) {
    const r = 6371000.0;
    final phi1 = lat1 * pi / 180;
    final phi2 = lat2 * pi / 180;
    final dPhi = (lat2 - lat1) * pi / 180;
    final dLam = (lon2 - lon1) * pi / 180;
    final a = sin(dPhi / 2) * sin(dPhi / 2) +
        cos(phi1) * cos(phi2) * sin(dLam / 2) * sin(dLam / 2);
    return r * 2 * atan2(sqrt(a), sqrt(1 - a));
  }

  Future<void> _loadDriverPoints(int driverNum) async {
    final tag = 'Driver #$driverNum';
    final orders = await queryOrdersRecordOnce(
      queryBuilder: (q) => q
          .where('status', isEqualTo: 'Reparto')
          .where('driverTag', isEqualTo: tag),
    );
    final points = orders
        .map((e) => e.location)
        .where((l) => l != null)
        .cast<LatLng>()
        .toList();
    safeSetState(() {
      if (driverNum == 1) _model.driver1Points = points;
      if (driverNum == 2) _model.driver2Points = points;
      if (driverNum == 3) _model.driver3Points = points;
    });
  }

  Future<void> _launchRoute(List<LatLng> points) async {
    if (points.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No hay pedidos activos para trazar ruta.',
              style: GoogleFonts.inter(color: Colors.white)),
          backgroundColor: _kMuted,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    // Origen: el mismo punto de partida configurable que usa el cálculo de
    // envío (Central de Abastos por defecto).
    var origin = '21.0716592,-101.6841543';
    try {
      final cfg = await FirebaseFirestore.instance
          .collection('app_config')
          .limit(1)
          .get();
      if (cfg.docs.isNotEmpty) {
        final d = cfg.docs.first.data();
        final lat = (d['origin_lat'] as num?)?.toDouble();
        final lng = (d['origin_lng'] as num?)?.toDouble();
        if (lat != null && lng != null) {
          origin = '$lat,$lng';
        }
      }
    } catch (_) {}
    final destination = '${points.last.latitude},${points.last.longitude}';
    final waypoints = points.length > 1
        ? points
            .sublist(0, points.length - 1)
            .map((p) => '${p.latitude},${p.longitude}')
            .join('|')
        : '';
    final url =
        'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&waypoints=$waypoints&travelmode=driving';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  Future<void> _markEnCamino(OrdersRecord order) async {
    await order.reference
        .update(createOrdersRecordData(driverStatusText: 'En camino'));
    if (order.userRef != null) {
      triggerPushNotification(
        notificationTitle: '🚚 Tu pedido va en camino',
        notificationText: 'El repartidor ya salió rumbo a tu domicilio.',
        notificationSound: 'default',
        userRefs: [order.userRef!],
        initialPageName: 'Notificaciones',
        parameterData: {},
      );
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Notificación enviada: pedido en camino',
          style: GoogleFonts.inter(color: Colors.white, fontSize: 13)),
      backgroundColor: _kBlue,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  Future<void> _markDelivered(OrdersRecord order) async {
    await order.reference.update({
      ...createOrdersRecordData(driverStatusText: 'Su pedido ha llegado'),
      // Efectivo: al entregar, el repartidor cobra → queda pagado.
      if (order.paymentMethod != 'Tarjeta') 'paymentStatus': 'Pagado',
    });
    if (order.userRef != null) {
      triggerPushNotification(
        notificationTitle: '📍 Tu pedido llegó',
        notificationText: 'El repartidor ya se encuentra en tu domicilio.',
        notificationSound: 'default',
        userRefs: [order.userRef!],
        initialPageName: 'Notificaciones',
        parameterData: {},
      );
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Notificación enviada: pedido entregado',
          style: GoogleFonts.inter(color: Colors.white, fontSize: 13)),
      backgroundColor: _kGreen,
      duration: const Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  void dispose() {
    _locationTimer?.cancel();
    // Remove driver from the live map when leaving the panel
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null && _myDriverSlot > 0) {
      FirebaseFirestore.instance
          .collection('driverLocations')
          .doc(uid)
          .delete();
    }
    _model.dispose();
    super.dispose();
  }

  // ─── BUILD ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: _kBg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: TabBarView(
              controller: _model.tabBarController,
              children: [
                _buildDriverTab(1),
                _buildDriverTab(2),
                _buildDriverTab(3),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── HEADER ───────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Container(
      color: _kDarkGreen,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        bottom: 12,
        left: 4,
        right: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white, size: 24),
                onPressed: () => context.pushNamed(HomePageWidget.routeName),
              ),
              const SizedBox(width: 2),
              Text(
                'Repartos',
                style: GoogleFonts.interTight(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              const SizedBox(width: 16),
              _buildTabPill(0, 'Driver #1'),
              const SizedBox(width: 8),
              _buildTabPill(1, 'Driver #2'),
              const SizedBox(width: 8),
              _buildTabPill(2, 'Driver #3'),
              const Spacer(),
              if (_myDriverSlot > 0)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _locationActive
                          ? Colors.greenAccent.withOpacity(0.25)
                          : Colors.white24,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: _locationActive
                                ? Colors.greenAccent
                                : Colors.white54,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _locationActive ? 'GPS activo' : 'GPS inactivo',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _locationActive
                                ? Colors.greenAccent
                                : Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabPill(int index, String label) {
    final selected = _model.tabBarCurrentIndex == index;
    return GestureDetector(
      onTap: () async {
        _model.tabBarController!.animateTo(index);
        await _loadDriverPoints(index + 1);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? Colors.white : Colors.white60,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: selected ? _kDarkGreen : Colors.white,
          ),
        ),
      ),
    );
  }

  // ─── DRIVER TAB ───────────────────────────────────────────────────────────

  Widget _buildDriverTab(int driverNum) {
    final tag = 'Driver #$driverNum';
    late Completer<GoogleMapController> controller;
    late List<LatLng> points;
    late LatLng? center;
    late void Function(LatLng) onIdle;

    switch (driverNum) {
      case 1:
        controller = _model.googleMapsController1;
        points = _model.driver1Points;
        center = _model.googleMapsCenter1;
        onIdle = (c) => _model.googleMapsCenter1 = c;
        break;
      case 2:
        controller = _model.googleMapsController2;
        points = _model.driver2Points;
        center = _model.googleMapsCenter2;
        onIdle = (c) => _model.googleMapsCenter2 = c;
        break;
      default:
        controller = _model.googleMapsController3;
        points = _model.driver3Points;
        center = _model.googleMapsCenter3;
        onIdle = (c) => _model.googleMapsCenter3 = c;
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        children: [
          // Mapa
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: SizedBox(
                height: 210,
                child: FlutterFlowGoogleMap(
                  controller: controller,
                  onCameraIdle: onIdle,
                  initialLocation: center ?? const LatLng(21.07364, -101.68435),
                  markers: [
                    ...points.map((p) => FlutterFlowMarker(p.serialize(), p)),
                    FlutterFlowMarker(
                      'warehouse',
                      const LatLng(21.07364, -101.68435),
                      () async {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Central de Abastos de León')),
                        );
                      },
                      BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueCyan),
                    ),
                  ],
                  markerColor: GoogleMarkerColor.red,
                  mapType: MapType.normal,
                  style: GoogleMapStyle.standard,
                  initialZoom: 11.0,
                  allowInteraction: true,
                  allowZoom: true,
                  showZoomControls: true,
                  showLocation: true,
                  showCompass: false,
                  showMapToolbar: false,
                  showTraffic: false,
                  centerMapOnMarkerTap: true,
                  mapTakesGesturePreference: true,
                ),
              ),
            ),
          ),
          // Botón traza ruta
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => _launchRoute(points),
                icon: const Icon(Icons.map_rounded, size: 16),
                label: const Text('Traza Ruta'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kDarkGreen,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  textStyle: GoogleFonts.inter(
                      fontSize: 13, fontWeight: FontWeight.w600),
                  elevation: 2,
                ),
              ),
            ),
          ),
          // Lista de pedidos
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: StreamBuilder<List<OrdersRecord>>(
              stream: queryOrdersRecord(
                queryBuilder: (q) => q
                    .where('driverTag', isEqualTo: tag)
                    .where('status', isEqualTo: 'Reparto')
                    .orderBy('createdAt', descending: true),
              ),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: CircularProgressIndicator(
                          color: _kGreen, strokeWidth: 2.5),
                    ),
                  );
                }
                final orders = snapshot.data!;
                if (orders.isEmpty) return _buildEmptyState();
                return Column(
                  children: orders.map((o) => _buildOrderCard(o)).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.local_shipping_outlined, size: 52, color: _kMuted),
          const SizedBox(height: 12),
          Text('Sin pedidos activos',
              style: GoogleFonts.inter(
                  fontSize: 15, color: _kMuted, fontWeight: FontWeight.w500)),
          const SizedBox(height: 4),
          Text('Los pedidos asignados aparecerán aquí.',
              style: GoogleFonts.inter(fontSize: 13, color: _kMuted)),
        ],
      ),
    );
  }

  // ─── ORDER CARD ───────────────────────────────────────────────────────────

  Widget _buildOrderCard(OrdersRecord order) {
    final orderId = order.reference.id;
    final isExpanded = _expandedOrders.contains(orderId);
    final statusText = order.driverStatusText;
    final isDelivered = statusText == 'Su pedido ha llegado';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: isDelivered ? const Color(0xFFBBDFBB) : _kBorder, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Cabecera: badge + ID corto
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
            child: Row(
              children: [
                _buildStatusBadge(statusText),
                const Spacer(),
                Text(
                  '#${orderId.length >= 8 ? orderId.substring(0, 8) : orderId}',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      color: _kMuted,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          // ── Nombre del cliente + fecha
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    order.nombrecliente.isNotEmpty
                        ? order.nombrecliente
                        : 'Cliente',
                    style: GoogleFonts.interTight(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: _kText),
                  ),
                ),
                if (order.createdAt != null)
                  Text(
                    dateTimeFormat('d/M H:mm', order.createdAt!),
                    style: GoogleFonts.inter(fontSize: 12, color: _kMuted),
                  ),
              ],
            ),
          ),
          // ── Total + cómo cobra
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 4, 14, 10),
            child: Row(
              children: [
                Text(
                  formatNumber(order.total,
                      formatType: FormatType.decimal,
                      decimalType: DecimalType.periodDecimal,
                      currency: '\$'),
                  style: GoogleFonts.interTight(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: _kGreen),
                ),
                const SizedBox(width: 10),
                Expanded(child: _paymentBadge(order)),
              ],
            ),
          ),
          // ── Dirección
          _buildAddressSection(order),
          // ── Toggle productos
          _buildItemsToggle(order, isExpanded),
          // ── Botón de acción
          _buildActionButton(order),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  /// Indica al repartidor si debe cobrar en efectivo al entregar o si el
  /// pedido va pagado (o por pagarse) con tarjeta.
  Widget _paymentBadge(OrdersRecord order) {
    final isCard = order.paymentMethod == 'Tarjeta';
    final paid = order.paymentStatus == 'Pagado';
    final Color color;
    final String label;
    final IconData icon;
    if (!isCard) {
      color = const Color(0xFFE65100);
      label = 'COBRAR EN EFECTIVO';
      icon = Icons.payments_rounded;
    } else if (paid) {
      color = _kGreen;
      label = 'PAGADO CON TARJETA';
      icon = Icons.credit_card_rounded;
    } else {
      color = const Color(0xFF009EE3);
      label = 'TARJETA · VERIFICAR PAGO';
      icon = Icons.credit_card_rounded;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.3,
                  color: color),
            ),
          ),
        ],
      ),
    );
  }

  // ─── STATUS BADGE ─────────────────────────────────────────────────────────

  Widget _buildStatusBadge(String statusText) {
    Color bg, fg;
    String label;
    IconData icon;

    switch (statusText) {
      case 'En camino':
        bg = _kBlueLight;
        fg = _kBlue;
        label = 'En camino';
        icon = Icons.directions_bike_rounded;
        break;
      case 'Su pedido ha llegado':
        bg = _kGreenLight;
        fg = _kGreen;
        label = 'Entregado';
        icon = Icons.check_circle_rounded;
        break;
      default:
        bg = _kOrangeLight;
        fg = _kOrange;
        label = 'En preparación';
        icon = Icons.schedule_rounded;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: fg),
          const SizedBox(width: 4),
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
        ],
      ),
    );
  }

  // ─── ADDRESS SECTION ──────────────────────────────────────────────────────

  Widget _buildAddressSection(OrdersRecord order) {
    return Container(
      margin: const EdgeInsets.fromLTRB(14, 0, 14, 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FBF0),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBBDFBB), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on_rounded,
                  size: 13, color: Color(0xFF2E7D32)),
              const SizedBox(width: 4),
              Text('Dirección de entrega',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: _kGreen)),
            ],
          ),
          const SizedBox(height: 7),
          _addrRow('${order.street} #${order.number}'),
          _addrRow('Col. ${order.neighborhood}   CP ${order.postalCode}'),
          if (order.referenceNote.isNotEmpty)
            _addrRow('Ref: ${order.referenceNote}', italic: true),
        ],
      ),
    );
  }

  Widget _addrRow(String text, {bool italic = false}) {
    return Padding(
      padding: const EdgeInsets.only(top: 3),
      child: Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 13,
          color: italic ? _kMuted : _kText,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          fontWeight: italic ? FontWeight.normal : FontWeight.w500,
        ),
      ),
    );
  }

  // ─── ITEMS TOGGLE ─────────────────────────────────────────────────────────

  Widget _buildItemsToggle(OrdersRecord order, bool isExpanded) {
    return Column(
      children: [
        InkWell(
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(10)),
          onTap: () {
            final id = order.reference.id;
            safeSetState(() {
              if (isExpanded) {
                _expandedOrders.remove(id);
              } else {
                _expandedOrders.add(id);
              }
            });
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: Row(
              children: [
                Icon(
                  isExpanded
                      ? Icons.keyboard_arrow_up_rounded
                      : Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: _kGreen,
                ),
                const SizedBox(width: 4),
                Text(
                  isExpanded ? 'Ocultar productos' : 'Ver productos',
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _kGreen),
                ),
              ],
            ),
          ),
        ),
        if (isExpanded) _buildItemsList(order),
      ],
    );
  }

  Widget _buildItemsList(OrdersRecord order) {
    return StreamBuilder<List<OrdersitemsRecord>>(
      stream: queryOrdersitemsRecord(parent: order.reference),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Center(
              child: CircularProgressIndicator(color: _kGreen, strokeWidth: 2),
            ),
          );
        }
        final items = snapshot.data!;
        if (items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
            child: Text('Sin productos.',
                style: GoogleFonts.inter(fontSize: 13, color: _kMuted)),
          );
        }
        return Column(
          children: items.map((item) => _buildItemRow(item)).toList(),
        );
      },
    );
  }

  Widget _buildItemRow(OrdersitemsRecord item) {
    final isGramos = item.unitType == 'Gramos';
    final qty = isGramos
        ? '${formatNumber(item.grams, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)} g'
        : '${formatNumber(item.grams, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal)} pzas';

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFBF5),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _kBorder),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
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
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.image_not_supported_outlined,
                      color: Colors.grey, size: 22),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.productName,
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _kText)),
                  const SizedBox(height: 3),
                  Text(qty,
                      style: GoogleFonts.inter(fontSize: 12, color: _kMuted)),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  formatNumber(item.unitPrice,
                      formatType: FormatType.decimal,
                      decimalType: DecimalType.periodDecimal,
                      currency: '\$'),
                  style: GoogleFonts.interTight(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _kGreen),
                ),
                if (isGramos)
                  Text(
                    '${formatNumber(item.pricePerKg, formatType: FormatType.decimal, decimalType: DecimalType.periodDecimal, currency: '\$')}/kg',
                    style: GoogleFonts.inter(fontSize: 11, color: _kMuted),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ─── ACTION BUTTON ────────────────────────────────────────────────────────

  Widget _buildActionButton(OrdersRecord order) {
    final status = order.driverStatusText;

    if (status == 'Su pedido ha llegado') {
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 11),
          decoration: BoxDecoration(
            color: _kGreenLight,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_rounded,
                  size: 16, color: Color(0xFF2E7D32)),
              const SizedBox(width: 6),
              Text('Pedido entregado ✓',
                  style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _kGreen)),
            ],
          ),
        ),
      );
    }

    final isEnCamino = status == 'En camino';

    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () =>
              isEnCamino ? _markDelivered(order) : _markEnCamino(order),
          icon: Icon(
            isEnCamino
                ? Icons.check_circle_outline_rounded
                : Icons.directions_bike_rounded,
            size: 18,
          ),
          label: Text(isEnCamino ? 'Marcar Entregado' : 'Salí a repartir'),
          style: ElevatedButton.styleFrom(
            backgroundColor: isEnCamino ? _kGreen : _kBlue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 13),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            textStyle:
                GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
            elevation: 0,
          ),
        ),
      ),
    );
  }
}

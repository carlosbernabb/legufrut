import 'dart:async';

import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'conductores_model.dart';
export 'conductores_model.dart';

class ConductoresWidget extends StatefulWidget {
  const ConductoresWidget({super.key});

  static String routeName = 'Conductores';
  static String routePath = '/conductores';

  @override
  State<ConductoresWidget> createState() => _ConductoresWidgetState();
}

class _ConductoresWidgetState extends State<ConductoresWidget> {
  late ConductoresModel _model;

  static const _kDarkGreen = Color(0xFF2D5016);
  static const _kGreen = Color(0xFF2E7D32);
  static const _kBg = Color(0xFFF8F4EF);
  static const _kText = Color(0xFF1A1A1A);
  static const _kMuted = Color(0xFF6B7280);
  static const _kBorder = Color(0xFFE5E7EB);

  // Driver slot colors
  static const _kDriver1Color = Color(0xFF6A1B9A); // purple
  static const _kDriver2Color = Color(0xFF1565C0); // blue
  static const _kDriver3Color = Color(0xFF00695C); // teal

  // Firestore state
  DocumentReference? _appConfigRef;
  String _driver1Email = '';
  String _driver2Email = '';
  String _driver3Email = '';
  List<Map<String, dynamic>> _orders = [];

  // Driver live locations (from user documents)
  final Map<int, GeoPoint?> _driverLocation = {1: null, 2: null, 3: null};
  final Map<int, DateTime?> _driverLastUpdate = {1: null, 2: null, 3: null};

  // Subscriptions
  StreamSubscription? _configSub;
  StreamSubscription? _ordersSub;
  final Map<int, StreamSubscription?> _locationSubs = {1: null, 2: null, 3: null};

  // Edit state
  int? _editingDriver;
  final _emailCtrl = TextEditingController();
  bool _saving = false;
  String? _lookupError;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ConductoresModel());
    _subscribeConfig();
    _subscribeOrders();
  }

  void _subscribeConfig() {
    _configSub = FirebaseFirestore.instance
        .collection('app_config')
        .limit(1)
        .snapshots()
        .listen((snap) {
      if (snap.docs.isEmpty) {
        safeSetState(() {
          _appConfigRef =
              FirebaseFirestore.instance.collection('app_config').doc('default');
        });
        return;
      }
      final doc = snap.docs.first;
      final data = doc.data();
      final e1 = (data['driver1_email'] ?? '') as String;
      final e2 = (data['driver2_email'] ?? '') as String;
      final e3 = (data['driver3_email'] ?? '') as String;
      safeSetState(() {
        _appConfigRef = doc.reference;
        _driver1Email = e1;
        _driver2Email = e2;
        _driver3Email = e3;
      });
      _subscribeDriverLocation(1, e1);
      _subscribeDriverLocation(2, e2);
      _subscribeDriverLocation(3, e3);
    });
  }

  void _subscribeDriverLocation(int slot, String email) {
    _locationSubs[slot]?.cancel();
    if (email.isEmpty) {
      safeSetState(() {
        _driverLocation[slot] = null;
        _driverLastUpdate[slot] = null;
      });
      return;
    }
    _locationSubs[slot] = FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email.trim().toLowerCase())
        .limit(1)
        .snapshots()
        .listen((snap) {
      if (snap.docs.isEmpty) return;
      final data = snap.docs.first.data();
      final geo = data['driverLatLng'] as GeoPoint?;
      final ts = data['driverLastUpdate'] as Timestamp?;
      safeSetState(() {
        _driverLocation[slot] = geo;
        _driverLastUpdate[slot] = ts?.toDate();
      });
    });
  }

  void _subscribeOrders() {
    _ordersSub = FirebaseFirestore.instance
        .collection('orders')
        .snapshots()
        .listen((snap) {
      safeSetState(() {
        _orders = snap.docs.map((d) {
          final data = d.data();
          return {
            'id': d.id,
            'driverTag': data['driverTag'] ?? '',
            'status': data['status'] ?? '',
            'driverStatusText': data['driverStatusText'] ?? '',
            'nombrecliente': data['nombrecliente'] ?? '',
          };
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    _configSub?.cancel();
    _ordersSub?.cancel();
    for (final sub in _locationSubs.values) {
      sub?.cancel();
    }
    _emailCtrl.dispose();
    _model.dispose();
    super.dispose();
  }

  String _emailForSlot(int n) {
    if (n == 1) return _driver1Email;
    if (n == 2) return _driver2Email;
    return _driver3Email;
  }

  List<Map<String, dynamic>> _ordersForDriver(int n) =>
      _orders.where((o) => o['driverTag'] == 'Driver #$n').toList();

  Color _colorForDriver(int n) {
    if (n == 1) return _kDriver1Color;
    if (n == 2) return _kDriver2Color;
    return _kDriver3Color;
  }

  String _statusLabel(String driverStatusText) {
    switch (driverStatusText) {
      case 'En preparación':
        return 'Preparando';
      case 'En camino':
        return 'En camino';
      case 'Su pedido ha llegado':
        return 'Entregado';
      default:
        return 'Sin actividad';
    }
  }

  Color _statusColor(String driverStatusText) {
    switch (driverStatusText) {
      case 'En preparación':
        return const Color(0xFFE65100);
      case 'En camino':
        return _kDriver2Color;
      case 'Su pedido ha llegado':
        return _kGreen;
      default:
        return _kMuted;
    }
  }

  Future<void> _startEditing(int driverNum) async {
    _emailCtrl.text = _emailForSlot(driverNum);
    safeSetState(() {
      _editingDriver = driverNum;
      _lookupError = null;
    });
  }

  Future<void> _saveDriver(int driverNum) async {
    _appConfigRef ??=
        FirebaseFirestore.instance.collection('app_config').doc('default');
    final newEmail = _emailCtrl.text.trim().toLowerCase();

    safeSetState(() {
      _saving = true;
      _lookupError = null;
    });

    try {
      final oldEmail = _emailForSlot(driverNum).trim().toLowerCase();

      // Clear isDriver on old user
      if (oldEmail.isNotEmpty && oldEmail != newEmail) {
        final oldSnap = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: oldEmail)
            .limit(1)
            .get();
        if (oldSnap.docs.isNotEmpty) {
          await oldSnap.docs.first.reference.update({'isDriver': false});
        }
      }

      // Set new user as driver (if email provided)
      if (newEmail.isNotEmpty) {
        final newSnap = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: newEmail)
            .limit(1)
            .get();
        if (newSnap.docs.isEmpty) {
          safeSetState(() {
            _saving = false;
            _lookupError =
                'No se encontró un usuario con ese correo. Pídele que se registre primero en la app.';
          });
          return;
        }
        await newSnap.docs.first.reference.update({
          'isDriver': true,
          'driverSlot': driverNum,
        });
      }

      // Save email to app_config
      await _appConfigRef!.set(
        {'driver${driverNum}_email': newEmail},
        SetOptions(merge: true),
      );

      safeSetState(() {
        _editingDriver = null;
        _saving = false;
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(newEmail.isEmpty
              ? 'Driver #$driverNum liberado'
              : 'Conductor asignado correctamente'),
          backgroundColor: _kDarkGreen,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    } catch (e) {
      safeSetState(() => _saving = false);
    }
  }

  Future<void> _clearDriver(int driverNum) async {
    _emailCtrl.text = '';
    await _saveDriver(driverNum);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Scaffold(
      backgroundColor: _kBg,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                children: [
                  _buildDriverCard(1),
                  const SizedBox(height: 16),
                  _buildDriverCard(2),
                  const SizedBox(height: 16),
                  _buildDriverCard(3),
                  const SizedBox(height: 24),
                  // Info note
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8F5E9),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: _kGreen.withOpacity(0.3)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded,
                            color: _kGreen, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Para asignar un conductor, ingresa el correo con el que se registró en la app. El conductor verá automáticamente su panel al iniciar sesión.',
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                color: _kGreen,
                                height: 1.5),
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
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
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
              GestureDetector(
                onTap: () => context.pushNamed(AdminHubWidget.routeName),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back_rounded,
                        color: Colors.white70, size: 20),
                    const SizedBox(width: 6),
                    Text('Panel Admin',
                        style: GoogleFonts.inter(
                            color: Colors.white70, fontSize: 14)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.local_shipping_rounded,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Conductores',
                        style: GoogleFonts.interTight(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                        ),
                      ),
                      Text(
                        'Gestiona y monitorea tus repartidores',
                        style: GoogleFonts.inter(
                            color: Colors.white60, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDriverCard(int driverNum) {
    final email = _emailForSlot(driverNum);
    final driverOrders = _ordersForDriver(driverNum);
    final activeOrders = driverOrders
        .where((o) =>
            o['status'] == 'Reparto' &&
            o['driverStatusText'] != 'Su pedido ha llegado')
        .toList();
    final deliveredOrders = driverOrders
        .where((o) => o['driverStatusText'] == 'Su pedido ha llegado')
        .toList();
    final isEditing = _editingDriver == driverNum;
    final hasDriver = email.isNotEmpty;
    final color = _colorForDriver(driverNum);

    // Get current status from most recent active order
    final currentStatus = activeOrders.isNotEmpty
        ? activeOrders.first['driverStatusText'] as String
        : '';

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: const EdgeInsets.fromLTRB(18, 14, 14, 14),
            child: Row(
              children: [
                // Driver # badge
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Driver #$driverNum',
                    style: GoogleFonts.interTight(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                // Status chip if active
                if (hasDriver && currentStatus.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _statusColor(currentStatus).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: _statusColor(currentStatus),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          _statusLabel(currentStatus),
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: _statusColor(currentStatus),
                          ),
                        ),
                      ],
                    ),
                  ),
                const Spacer(),
                // Actions
                if (!isEditing) ...[
                  if (hasDriver)
                    GestureDetector(
                      onTap: () => _clearDriver(driverNum),
                      child: Container(
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEE2E2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.person_remove_rounded,
                            size: 16, color: Color(0xFFB91C1C)),
                      ),
                    ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _startEditing(driverNum),
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        hasDriver ? Icons.edit_rounded : Icons.person_add_rounded,
                        size: 16,
                        color: color,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Email assigned
                if (!isEditing) ...[
                  Row(
                    children: [
                      Icon(
                        hasDriver
                            ? Icons.person_rounded
                            : Icons.person_off_rounded,
                        size: 16,
                        color: hasDriver ? color : _kMuted,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          hasDriver ? email : 'Sin conductor asignado',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: hasDriver
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: hasDriver ? _kText : _kMuted,
                            fontStyle: hasDriver
                                ? FontStyle.normal
                                : FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (hasDriver) ...[
                    const SizedBox(height: 10),
                    _buildLocationRow(driverNum),
                  ],
                  const SizedBox(height: 16),

                  // Stats row
                  Row(
                    children: [
                      _buildStat(
                        '${activeOrders.length}',
                        'paradas\npendientes',
                        Icons.location_on_rounded,
                        color,
                      ),
                      const SizedBox(width: 12),
                      _buildStat(
                        '${deliveredOrders.length}',
                        'entregados\nhoy',
                        Icons.check_circle_rounded,
                        _kGreen,
                      ),
                      const SizedBox(width: 12),
                      _buildStat(
                        '${driverOrders.length}',
                        'pedidos\ntotales',
                        Icons.receipt_rounded,
                        _kMuted,
                      ),
                    ],
                  ),

                  // Active orders list (first 2)
                  if (activeOrders.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Divider(color: _kBorder, height: 1),
                    const SizedBox(height: 10),
                    Text(
                      'Próximas paradas',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _kMuted,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ...activeOrders.take(3).map((order) => Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(Icons.delivery_dining_rounded,
                                    size: 13, color: color),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  order['nombrecliente'] as String,
                                  style: GoogleFonts.inter(
                                      fontSize: 13, color: _kText),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _statusLabel(
                                    order['driverStatusText'] as String),
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  color: _statusColor(
                                      order['driverStatusText'] as String),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ],
                ],

                // Edit mode
                if (isEditing) ...[
                  Text(
                    'Correo del conductor',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _kMuted),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _emailCtrl,
                    keyboardType: TextInputType.emailAddress,
                    autofocus: true,
                    style: GoogleFonts.inter(fontSize: 14, color: _kText),
                    decoration: InputDecoration(
                      hintText: 'conductor@email.com',
                      hintStyle:
                          GoogleFonts.inter(fontSize: 14, color: _kMuted),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: _kBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: color, width: 1.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: _kBorder),
                      ),
                    ),
                  ),
                  if (_lookupError != null) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEE2E2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline_rounded,
                              size: 16, color: Color(0xFFB91C1C)),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _lookupError!,
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  color: const Color(0xFFB91C1C)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _saving
                              ? null
                              : () => safeSetState(
                                  () => _editingDriver = null),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: _kBorder),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: Text('Cancelar',
                              style: GoogleFonts.inter(
                                  fontSize: 14, color: _kMuted)),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed:
                              _saving ? null : () => _saveDriver(driverNum),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: color,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            elevation: 0,
                          ),
                          child: _saving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2),
                                )
                              : Text('Guardar',
                                  style: GoogleFonts.interTight(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(int slot) {
    final geo = _driverLocation[slot];
    final lastUpdate = _driverLastUpdate[slot];
    final color = _colorForDriver(slot);

    String locationText;
    bool isLive = false;

    if (geo == null) {
      locationText = 'Sin señal GPS';
    } else if (lastUpdate == null) {
      locationText = 'Ubicación disponible';
      isLive = true;
    } else {
      final diff = DateTime.now().difference(lastUpdate);
      if (diff.inMinutes < 2) {
        locationText = 'En vivo';
        isLive = true;
      } else if (diff.inMinutes < 60) {
        locationText = 'Hace ${diff.inMinutes} min';
        isLive = diff.inMinutes < 10;
      } else {
        locationText = 'Hace ${diff.inHours} h';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: isLive ? color.withOpacity(0.07) : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isLive ? color.withOpacity(0.25) : _kBorder,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isLive ? color : _kMuted,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.location_on_rounded,
              size: 13, color: isLive ? color : _kMuted),
          const SizedBox(width: 4),
          Text(
            locationText,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: isLive ? FontWeight.w600 : FontWeight.normal,
              color: isLive ? color : _kMuted,
            ),
          ),
          if (geo != null) ...[
            const Spacer(),
            Text(
              '${geo.latitude.toStringAsFixed(4)}, ${geo.longitude.toStringAsFixed(4)}',
              style: GoogleFonts.inter(fontSize: 10, color: _kMuted),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStat(
      String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.07),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.interTight(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: color),
            ),
            Text(
              label,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                  fontSize: 10, color: _kMuted, height: 1.3),
            ),
          ],
        ),
      ),
    );
  }
}

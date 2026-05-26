import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/loggin/loggin_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'universal_product_card_model.dart';
export 'universal_product_card_model.dart';

class UniversalProductCardWidget extends StatefulWidget {
  const UniversalProductCardWidget({
    super.key,
    this.coverimage,
    this.productname,
    this.price,
    this.productRef,
    this.saleType,
  });

  final String? coverimage;
  final String? productname;
  final double? price;
  final DocumentReference? productRef;
  final String? saleType;

  @override
  State<UniversalProductCardWidget> createState() =>
      _UniversalProductCardWidgetState();
}

class _UniversalProductCardWidgetState
    extends State<UniversalProductCardWidget> {
  late UniversalProductCardModel _model;

  static const _kGreen = Color(0xFF2E7D32);
  static const _kGreenLight = Color(0xFFE8F5E9);
  static const _kBorder = Color(0xFFE5E7EB);
  static const _kText = Color(0xFF1A1A1A);
  static const _kMuted = Color(0xFF6B7280);

  bool get _isPieceType {
    final t = widget.saleType?.toLowerCase() ?? '';
    return t.contains('pieza') ||
        t.contains('pza') ||
        t.contains('unidad') ||
        t == 'por pieza' ||
        t.contains('piece');
  }

  List<String> get _availableUnits => _isPieceType ? ['pza'] : ['kg', 'g'];

  double get _stepSize => _model.selectedUnit == 'g' ? 100.0 : 1.0;
  double get _minQuantity => _model.selectedUnit == 'g' ? 100.0 : 1.0;

  String get _unitLabel => _isPieceType ? 'pza' : 'kg';

  String _formatQuantity() {
    if (_model.selectedUnit == 'g') {
      return '${_model.quantity.toInt()} g';
    } else if (_model.selectedUnit == 'pza') {
      return '${_model.quantity.toInt()} pza';
    } else {
      return '${_model.quantity.toInt()} kg';
    }
  }

  double _calculateTotalPrice() {
    final p = widget.price ?? 0.0;
    if (_model.selectedUnit == 'g') {
      return p * (_model.quantity / 1000.0);
    } else {
      // kg or pza: quantity is already in units
      return p * _model.quantity;
    }
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UniversalProductCardModel());

    // Initialize unit only on first render (model state persists across rebuilds)
    if (_model.selectedUnit.isEmpty) {
      _model.selectedUnit = _isPieceType ? 'pza' : 'kg';
      _model.quantity = 1.0;
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  void _selectUnit(String unit) {
    safeSetState(() {
      _model.selectedUnit = unit;
      _model.quantity = unit == 'g' ? 100.0 : 1.0;
    });
  }

  void _increment() {
    safeSetState(() {
      _model.quantity =
          (_model.quantity + _stepSize).clamp(_minQuantity, 10000);
    });
  }

  void _decrement() {
    safeSetState(() {
      _model.quantity =
          (_model.quantity - _stepSize).clamp(_minQuantity, 10000);
    });
  }

  Future<void> _addToCart() async {
    if (_model.isAddingToCart) return;

    if (!loggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Inicia sesión para agregar al carrito',
            style: GoogleFonts.inter(color: Colors.white),
          ),
          backgroundColor: const Color(0xFFFF7043),
          duration: const Duration(seconds: 2),
        ),
      );
      await Future.delayed(const Duration(milliseconds: 400));
      context.pushNamed(LogginWidget.routeName);
      return;
    }

    safeSetState(() => _model.isAddingToCart = true);

    try {
      // Determine grams to store and unit price
      final double gramsToAdd;
      final double unitPrice;
      final String unitTypeStr;

      if (_model.selectedUnit == 'g') {
        gramsToAdd = _model.quantity;
        unitPrice = (widget.price ?? 0) * (_model.quantity / 1000.0);
        unitTypeStr = 'g';
      } else if (_model.selectedUnit == 'pza') {
        gramsToAdd = _model.quantity;
        unitPrice = (widget.price ?? 0) * _model.quantity;
        unitTypeStr = 'Piezas';
      } else {
        // kg
        gramsToAdd = _model.quantity * 1000;
        unitPrice = (widget.price ?? 0) * _model.quantity;
        unitTypeStr = 'kg';
      }

      // Check for existing cart item
      final existing = await queryCartRecordOnce(
        queryBuilder: (q) => q
            .where('productRef', isEqualTo: widget.productRef)
            .where('userRef', isEqualTo: currentUserReference),
        singleRecord: true,
      ).then((s) => s.firstOrNull);

      if (existing != null) {
        // Update existing item — accumulate grams/units
        final newGrams = existing.grams + gramsToAdd;
        final double newUnitPrice;
        if (unitTypeStr == 'Piezas') {
          newUnitPrice = (widget.price ?? 0) * newGrams;
        } else {
          newUnitPrice = (widget.price ?? 0) * (newGrams / 1000.0);
        }
        await existing.reference.update(createCartRecordData(
          grams: newGrams,
          unitPrice: newUnitPrice,
          unitType: unitTypeStr,
        ));
      } else {
        // Create new cart item
        await CartRecord.collection.doc().set(createCartRecordData(
          productRef: widget.productRef,
          productName: widget.productname,
          pricePerKg: widget.price,
          grams: gramsToAdd,
          unitPrice: unitPrice,
          createdAt: getCurrentTimestamp,
          coverimage: widget.coverimage,
          unitType: unitTypeStr,
          userRef: currentUserReference,
        ));
      }

      // Reset quantity after adding
      safeSetState(() {
        _model.quantity = _model.selectedUnit == 'g' ? 100.0 : 1.0;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  '${widget.productname ?? 'Producto'} agregado al carrito',
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
                ),
              ],
            ),
            backgroundColor: _kGreen,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al agregar: $e',
                style: GoogleFonts.inter(color: Colors.white)),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      safeSetState(() => _model.isAddingToCart = false);
    }
  }

  // ─────────────────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: const Color(0xFFF0F0F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image ──────────────────────────────────────────
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: AspectRatio(
                  aspectRatio: 1.1,
                  child: Image.network(
                    widget.coverimage ?? '',
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) => Container(
                      color: const Color(0xFFF5F5F5),
                      child: const Icon(Icons.image_not_supported_outlined,
                          color: Color(0xFFBDBDBD), size: 40),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border,
                      size: 16, color: Color(0xFFBDBDBD)),
                ),
              ),
            ],
          ),

          // ── Content ────────────────────────────────────────
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    widget.productname ?? 'Producto',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.interTight(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: _kText,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // Price per unit
                  Text(
                    '\$${(widget.price ?? 0).toStringAsFixed(2)} / $_unitLabel',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: _kMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Unit selector tabs
                  if (_availableUnits.length > 1) ...[
                    _buildUnitTabs(),
                    const SizedBox(height: 6),
                  ],

                  // Quantity counter
                  _buildCounter(),

                  const SizedBox(height: 8),

                  // Add to cart button
                  _buildAddButton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  UNIT TABS
  // ─────────────────────────────────────────────────────────
  Widget _buildUnitTabs() {
    return Row(
      children: _availableUnits.asMap().entries.map((entry) {
        final i = entry.key;
        final unit = entry.value;
        final isSelected = _model.selectedUnit == unit;
        return Expanded(
          child: GestureDetector(
            onTap: () => _selectUnit(unit),
            child: Container(
              margin: EdgeInsets.only(right: i < _availableUnits.length - 1 ? 6 : 0),
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: isSelected ? _kGreenLight : Colors.white,
                border: Border.all(
                  color: isSelected ? _kGreen : _kBorder,
                  width: isSelected ? 1.5 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                unit,
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? _kGreen : _kMuted,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  QUANTITY COUNTER
  // ─────────────────────────────────────────────────────────
  Widget _buildCounter() {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        border: Border.all(color: _kBorder),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Decrement
          GestureDetector(
            onTap: _decrement,
            child: Container(
              width: 34,
              height: 36,
              alignment: Alignment.center,
              child: const Icon(Icons.remove_rounded,
                  size: 16, color: Color(0xFFEF5350)),
            ),
          ),
          // Divider
          Container(width: 1, height: 20, color: _kBorder),
          // Value
          Expanded(
            child: Text(
              _formatQuantity(),
              textAlign: TextAlign.center,
              style: GoogleFonts.interTight(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: _kText,
              ),
            ),
          ),
          // Divider
          Container(width: 1, height: 20, color: _kBorder),
          // Increment
          GestureDetector(
            onTap: _increment,
            child: Container(
              width: 34,
              height: 36,
              alignment: Alignment.center,
              child: const Icon(Icons.add_rounded,
                  size: 16, color: _kGreen),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  ADD TO CART BUTTON
  // ─────────────────────────────────────────────────────────
  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _model.isAddingToCart ? null : _addToCart,
      child: Container(
        width: double.infinity,
        height: 36,
        decoration: BoxDecoration(
          color: _model.isAddingToCart
              ? _kGreen.withOpacity(0.6)
              : _kGreen,
          borderRadius: BorderRadius.circular(10),
        ),
        child: _model.isAddingToCart
            ? const Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Agregar',
                    style: GoogleFonts.interTight(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.shopping_cart_outlined,
                      color: Colors.white, size: 15),
                ],
              ),
      ),
    );
  }
}

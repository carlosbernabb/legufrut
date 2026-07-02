import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/schema/products_record.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'recetas_admin_model.dart';
export 'recetas_admin_model.dart';

class RecetasAdminWidget extends StatefulWidget {
  const RecetasAdminWidget({super.key});

  static const routeName = 'RecetasAdmin';
  static const routePath = '/recetasAdmin';

  @override
  State<RecetasAdminWidget> createState() => _RecetasAdminWidgetState();
}

class _RecetasAdminWidgetState extends State<RecetasAdminWidget> {
  static const _kDarkGreen = Color(0xFF2D5016);
  static const _kGreen = Color(0xFF2E7D32);
  static const _kBg = Color(0xFFF8F4EF);
  static const _kText = Color(0xFF1A1A1A);
  static const _kMuted = Color(0xFF6B7280);
  static const _kRed = Color(0xFFEF5350);

  static const _colorPalette = [
    '4CAF50',
    '8BC34A',
    '2E7D32',
    'FF7043',
    'E91E63',
    '009688',
    '00897B',
    'FF8A65',
    '3949AB',
    'E65100',
    '795548',
    '7B1FA2',
  ];

  // Recetas iniciales para sembrar si Firestore está vacío
  static final _initialRecipes = [
    {
      'name': 'Guacamole Clásico',
      'emoji': '🥑',
      'colorHex': '4CAF50',
      'servings': 4,
      'timeMin': 15,
      'ingredients': [
        {'name': 'Aguacate', 'qty': 0.6, 'unit': 'kg'},
        {'name': 'Lima', 'qty': 0.2, 'unit': 'kg'},
        {'name': 'Chile Serrano', 'qty': 0.08, 'unit': 'kg'},
        {'name': 'Cebolla', 'qty': 0.15, 'unit': 'kg'},
        {'name': 'Cilantro', 'qty': 0.05, 'unit': 'kg'},
      ],
    },
    {
      'name': 'Ensalada Fresca',
      'emoji': '🥗',
      'colorHex': '8BC34A',
      'servings': 2,
      'timeMin': 10,
      'ingredients': [
        {'name': 'Espinaca', 'qty': 0.15, 'unit': 'kg'},
        {'name': 'Uva Verde', 'qty': 0.2, 'unit': 'kg'},
        {'name': 'Fresas', 'qty': 0.2, 'unit': 'kg'},
        {'name': 'Naranja', 'qty': 0.2, 'unit': 'kg'},
        {'name': 'Lima', 'qty': 0.1, 'unit': 'kg'},
      ],
    },
    {
      'name': 'Caldo de Verduras',
      'emoji': '🍲',
      'colorHex': 'FF7043',
      'servings': 4,
      'timeMin': 30,
      'ingredients': [
        {'name': 'Ejote', 'qty': 0.25, 'unit': 'kg'},
        {'name': 'Chayote', 'qty': 0.4, 'unit': 'kg'},
        {'name': 'Espinaca', 'qty': 0.1, 'unit': 'kg'},
        {'name': 'Chile Serrano', 'qty': 0.08, 'unit': 'kg'},
      ],
    },
    {
      'name': 'Agua de Frutas',
      'emoji': '🍹',
      'colorHex': 'E91E63',
      'servings': 6,
      'timeMin': 10,
      'ingredients': [
        {'name': 'Sandía', 'qty': 2.0, 'unit': 'kg'},
        {'name': 'Lima', 'qty': 0.25, 'unit': 'kg'},
        {'name': 'Naranja', 'qty': 0.5, 'unit': 'kg'},
        {'name': 'Guayaba', 'qty': 0.5, 'unit': 'kg'},
      ],
    },
    {
      'name': 'Smoothie Verde',
      'emoji': '🥤',
      'colorHex': '009688',
      'servings': 2,
      'timeMin': 5,
      'ingredients': [
        {'name': 'Espinaca', 'qty': 0.15, 'unit': 'kg'},
        {'name': 'Manzana Golden', 'qty': 0.4, 'unit': 'kg'},
        {'name': 'Lima', 'qty': 0.15, 'unit': 'kg'},
        {'name': 'Guayaba', 'qty': 0.25, 'unit': 'kg'},
      ],
    },
    {
      'name': 'Ensalada de Frutas',
      'emoji': '🍓',
      'colorHex': 'E91E63',
      'servings': 4,
      'timeMin': 10,
      'ingredients': [
        {'name': 'Fresas', 'qty': 0.3, 'unit': 'kg'},
        {'name': 'Manzana Golden', 'qty': 0.3, 'unit': 'kg'},
        {'name': 'Pera', 'qty': 0.4, 'unit': 'kg'},
        {'name': 'Uva Verde', 'qty': 0.2, 'unit': 'kg'},
        {'name': 'Lima', 'qty': 0.1, 'unit': 'kg'},
      ],
    },
    {
      'name': 'Jugo Verde Detox',
      'emoji': '🌿',
      'colorHex': '00897B',
      'servings': 2,
      'timeMin': 5,
      'ingredients': [
        {'name': 'Espinaca', 'qty': 0.2, 'unit': 'kg'},
        {'name': 'Pera', 'qty': 0.4, 'unit': 'kg'},
        {'name': 'Lima', 'qty': 0.2, 'unit': 'kg'},
        {'name': 'Piña', 'qty': 0.5, 'unit': 'kg'},
      ],
    },
    {
      'name': 'Botana Veraniega',
      'emoji': '🏖️',
      'colorHex': 'FF8A65',
      'servings': 6,
      'timeMin': 15,
      'ingredients': [
        {'name': 'Sandía', 'qty': 1.5, 'unit': 'kg'},
        {'name': 'Piña', 'qty': 0.5, 'unit': 'kg'},
        {'name': 'Manzana Golden', 'qty': 0.5, 'unit': 'kg'},
        {'name': 'Lima', 'qty': 0.2, 'unit': 'kg'},
        {'name': 'Chile Serrano', 'qty': 0.05, 'unit': 'kg'},
      ],
    },
  ];

  final _col = FirebaseFirestore.instance.collection('recipes');

  @override
  void initState() {
    super.initState();
    actions.enforceRole(context);
    _seedIfEmpty();
  }

  Future<void> _seedIfEmpty() async {
    try {
      final snap = await _col.limit(1).get();
      if (snap.docs.isEmpty) {
        final batch = FirebaseFirestore.instance.batch();
        for (final r in _initialRecipes) {
          final ref = _col.doc();
          batch.set(ref, {
            ...r,
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
        await batch.commit();
      }
    } catch (_) {
      // seed failure is non-fatal
    }
  }

  Color _parseColor(String hex) => Color(int.parse('FF$hex', radix: 16));

  void _showForm({DocumentSnapshot? existing}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RecipeForm(
        existing: existing,
        colorPalette: _colorPalette,
        collection: _col,
      ),
    );
  }

  Future<void> _delete(String id, String name) async {
    await _col.doc(id).delete();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('"$name" eliminada',
              style: GoogleFonts.inter(color: Colors.white)),
          backgroundColor: _kRed,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showForm(),
        backgroundColor: _kGreen,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: Text('Nueva Receta',
            style: GoogleFonts.interTight(
                color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _col.snapshots(),
              builder: (context, snap) {
                if (snap.hasError) {
                  return Center(
                    child: Text('Error: ${snap.error}',
                        style: GoogleFonts.inter(color: Colors.red)),
                  );
                }
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final docs = snap.data?.docs ?? []
                  ..sort((a, b) {
                    final aName = ((a.data() as Map)['name'] as String?) ?? '';
                    final bName = ((b.data() as Map)['name'] as String?) ?? '';
                    return aName.compareTo(bName);
                  });
                if (docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.menu_book_rounded,
                            size: 52, color: Color(0xFFD1D5DB)),
                        const SizedBox(height: 12),
                        Text('Sin recetas',
                            style: GoogleFonts.interTight(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: _kMuted)),
                        const SizedBox(height: 4),
                        Text('Toca + Nueva Receta para comenzar',
                            style: GoogleFonts.inter(
                                fontSize: 13, color: _kMuted)),
                      ],
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
                  itemCount: docs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) => _buildCard(docs[i]),
                );
              },
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
                    Text('Panel de Admin',
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
                    child: const Icon(Icons.menu_book_rounded,
                        color: Colors.white, size: 26),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Gestor de Recetas',
                            style: GoogleFonts.interTight(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.3,
                            )),
                        Text('Crea, edita y organiza las recetas',
                            style: GoogleFonts.inter(
                                color: Colors.white60, fontSize: 13)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    final name = (d['name'] as String?) ?? '';
    final emoji = (d['emoji'] as String?) ?? '🍽️';
    final colorHex = (d['colorHex'] as String?) ?? '4CAF50';
    final color = _parseColor(colorHex);
    final servings = (d['servings'] as int?) ?? 2;
    final timeMin = (d['timeMin'] as int?) ?? 10;
    final ingredients = (d['ingredients'] as List<dynamic>?) ?? [];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withOpacity(0.3)),
                  ),
                  child: Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: GoogleFonts.interTight(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: _kText)),
                      const SizedBox(height: 3),
                      Text(
                        '$servings pers · $timeMin min · ${ingredients.length} ingredientes',
                        style: GoogleFonts.inter(fontSize: 12, color: _kMuted),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_rounded,
                      color: Color(0xFF3949AB), size: 20),
                  onPressed: () => _showForm(existing: doc),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline_rounded,
                      color: _kRed, size: 20),
                  onPressed: () => _delete(doc.id, name),
                  padding: EdgeInsets.zero,
                  constraints:
                      const BoxConstraints(minWidth: 36, minHeight: 36),
                ),
              ],
            ),
            if (ingredients.isNotEmpty) ...[
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 10),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: ingredients.map<Widget>((ing) {
                  final n = (ing['name'] as String?) ?? '';
                  final qty = ((ing['qty'] as num?) ?? 0).toDouble();
                  final unit = (ing['unit'] as String?) ?? 'kg';
                  final qtyStr =
                      qty % 1 == 0 ? qty.toInt().toString() : qty.toString();
                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$n · $qtyStr $unit',
                      style: GoogleFonts.inter(
                          fontSize: 11,
                          color: color,
                          fontWeight: FontWeight.w600),
                    ),
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────
//  Ingredient data holder
// ──────────────────────────────────────────────────────────────────
class _IngData {
  final TextEditingController nameCtrl;
  final TextEditingController qtyCtrl;
  String unit;

  _IngData({String name = '', String qty = '0.5', this.unit = 'kg'})
      : nameCtrl = TextEditingController(text: name),
        qtyCtrl = TextEditingController(text: qty);

  void dispose() {
    nameCtrl.dispose();
    qtyCtrl.dispose();
  }
}

// ──────────────────────────────────────────────────────────────────
//  Ingredient row with product search autocomplete
// ──────────────────────────────────────────────────────────────────
class _IngredientRow extends StatefulWidget {
  const _IngredientRow({
    super.key,
    required this.ing,
    required this.products,
    required this.onUnitChanged,
    required this.onRemove,
  });
  final _IngData ing;
  final List<ProductsRecord> products;
  final ValueChanged<String> onUnitChanged;
  final VoidCallback onRemove;

  @override
  State<_IngredientRow> createState() => _IngredientRowState();
}

class _IngredientRowState extends State<_IngredientRow> {
  static const _kGreen = Color(0xFF2E7D32);
  static const _kMuted = Color(0xFF6B7280);
  static const _kBorder = Color(0xFFE5E7EB);
  static const _kRed = Color(0xFFEF5350);

  // Misma lógica que UniversalProductCard: default 'kg', solo 'pza' si saleType lo dice explícitamente
  static String _unitFromSaleType(String saleType) {
    final t = saleType.toLowerCase();
    final isPiece =
        t.contains('pieza') || t.contains('pza') || t.contains('piece');
    return isPiece ? 'pza' : 'kg';
  }

  List<ProductsRecord> _suggestions = [];
  ProductsRecord? _selectedProduct;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.ing.nameCtrl.addListener(_onNameChanged);
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        Future.delayed(const Duration(milliseconds: 180), () {
          if (mounted) setState(() => _suggestions = []);
        });
      }
    });
  }

  @override
  void didUpdateWidget(_IngredientRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When products finish loading, auto-match existing ingredient names.
    // Use addPostFrameCallback to avoid calling setState on the parent
    // while the widget tree is still building (causes assertion errors).
    if (oldWidget.products.isEmpty &&
        widget.products.isNotEmpty &&
        _selectedProduct == null) {
      final name = widget.ing.nameCtrl.text.trim();
      if (name.isNotEmpty) {
        final match = widget.products
            .where((p) => p.name.toLowerCase() == name.toLowerCase())
            .firstOrNull;
        if (match != null) {
          final unit = _unitFromSaleType(match.saleType);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              widget.onUnitChanged(unit);
              setState(() => _selectedProduct = match);
            }
          });
        }
      }
    }
  }

  void _onNameChanged() {
    final text = widget.ing.nameCtrl.text;
    // If user edits away from the locked product, unlock
    if (_selectedProduct != null && text != _selectedProduct!.name) {
      setState(() => _selectedProduct = null);
    }
    final q = text.toLowerCase().trim();
    if (q.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }
    final filtered = widget.products
        .where((p) => p.name.toLowerCase().contains(q))
        .take(6)
        .toList();
    setState(() => _suggestions = filtered);
  }

  void _selectProduct(ProductsRecord p) {
    widget.ing.nameCtrl.removeListener(_onNameChanged);
    widget.ing.nameCtrl.text = p.name;
    widget.ing.nameCtrl.addListener(_onNameChanged);
    final unit = _unitFromSaleType(p.saleType);
    widget.onUnitChanged(unit);
    setState(() {
      _selectedProduct = p;
      _suggestions = [];
    });
    _focusNode.unfocus();
  }

  @override
  void dispose() {
    widget.ing.nameCtrl.removeListener(_onNameChanged);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLocked = _selectedProduct != null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // ── Search field ──────────────────────────────
              Expanded(
                child: TextField(
                  controller: widget.ing.nameCtrl,
                  focusNode: _focusNode,
                  style: GoogleFonts.inter(fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Buscar producto...',
                    hintStyle: GoogleFonts.inter(fontSize: 13, color: _kMuted),
                    prefixIcon: const Icon(Icons.search_rounded,
                        size: 16, color: Color(0xFF9CA3AF)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: _kBorder)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: _kBorder)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide:
                            const BorderSide(color: _kGreen, width: 1.5)),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              // ── Qty ───────────────────────────────────────
              SizedBox(
                width: 56,
                child: TextField(
                  controller: widget.ing.qtyCtrl,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(fontSize: 13),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: _kBorder)),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: _kBorder)),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              // ── Unit: locked badge or editable dropdown ───
              if (isLocked)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: _kGreen.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _kGreen.withOpacity(0.3)),
                  ),
                  child: Text(
                    widget.ing.unit,
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: _kGreen),
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                      border: Border.all(color: _kBorder),
                      borderRadius: BorderRadius.circular(8)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: widget.ing.unit,
                      items: ['kg', 'g', 'pza']
                          .map((u) => DropdownMenuItem(
                              value: u,
                              child: Text(u,
                                  style: GoogleFonts.inter(fontSize: 13))))
                          .toList(),
                      onChanged: (v) => widget.onUnitChanged(v!),
                      isDense: true,
                    ),
                  ),
                ),
              // ── Remove ────────────────────────────────────
              GestureDetector(
                onTap: widget.onRemove,
                child: const Padding(
                  padding: EdgeInsets.all(6),
                  child: Icon(Icons.close_rounded, size: 18, color: _kRed),
                ),
              ),
            ],
          ),
          // ── Suggestions list ───────────────────────────────
          if (_suggestions.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 2, right: 74),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _kBorder),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.09),
                      blurRadius: 10,
                      offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: _suggestions.asMap().entries.map((e) {
                  final idx = e.key;
                  final p = e.value;
                  final isLast = idx == _suggestions.length - 1;
                  return InkWell(
                    onTap: () => _selectProduct(p),
                    borderRadius: BorderRadius.vertical(
                      top: idx == 0 ? const Radius.circular(8) : Radius.zero,
                      bottom: isLast ? const Radius.circular(8) : Radius.zero,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 9),
                      decoration: BoxDecoration(
                        border: isLast
                            ? null
                            : const Border(
                                bottom: BorderSide(color: Color(0xFFF3F4F6))),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p.name,
                                    style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF1A1A1A))),
                                Text(p.category,
                                    style: GoogleFonts.inter(
                                        fontSize: 11, color: _kMuted)),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                                color: _kGreen.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6)),
                            child: Text(
                              _unitFromSaleType(p.saleType),
                              style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: _kGreen),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────
//  FORM BOTTOM SHEET
// ──────────────────────────────────────────────────────────────────
class _RecipeForm extends StatefulWidget {
  const _RecipeForm({
    this.existing,
    required this.colorPalette,
    required this.collection,
  });
  final DocumentSnapshot? existing;
  final List<String> colorPalette;
  final CollectionReference collection;

  @override
  State<_RecipeForm> createState() => _RecipeFormState();
}

class _RecipeFormState extends State<_RecipeForm> {
  static const _kGreen = Color(0xFF2E7D32);
  static const _kMuted = Color(0xFF6B7280);
  static const _kBorder = Color(0xFFE5E7EB);
  static const _kText = Color(0xFF1A1A1A);

  static const _foodEmojis = [
    '🥑',
    '🥗',
    '🍲',
    '🍹',
    '🥤',
    '🍓',
    '🌿',
    '🏖️',
    '🍎',
    '🍊',
    '🍋',
    '🍇',
    '🍉',
    '🍍',
    '🥦',
    '🥕',
    '🌽',
    '🫑',
    '🥔',
    '🧅',
    '🧄',
    '🍄',
    '🫚',
    '🍳',
    '🥚',
    '🧀',
    '🥩',
    '🍗',
    '🌮',
    '🥙',
    '🫔',
    '🍜',
    '🥘',
    '🫕',
    '🥗',
    '🍱',
    '🍛',
    '🍝',
    '🫓',
    '🥐',
    '🍰',
    '🧁',
    '🍮',
    '🍩',
    '🍪',
    '🎂',
    '☕',
    '🍵',
  ];

  late final TextEditingController _nameCtrl;
  late final TextEditingController _servingsCtrl;
  late final TextEditingController _timeCtrl;
  late String _selectedColor;
  late String _selectedEmoji;
  bool _showEmojiPicker = false;

  final List<_IngData> _ings = [];
  List<ProductsRecord> _allProducts = [];
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final d = widget.existing?.data() as Map<String, dynamic>? ?? {};
    _nameCtrl = TextEditingController(text: (d['name'] as String?) ?? '');
    _selectedEmoji = (d['emoji'] as String?) ?? '🍽️';
    _servingsCtrl =
        TextEditingController(text: ((d['servings'] as int?) ?? 2).toString());
    _timeCtrl =
        TextEditingController(text: ((d['timeMin'] as int?) ?? 10).toString());
    _selectedColor = (d['colorHex'] as String?) ?? widget.colorPalette.first;

    final rawIng = (d['ingredients'] as List<dynamic>?) ?? [];
    if (rawIng.isEmpty) {
      _ings.add(_IngData());
    } else {
      for (final i in rawIng) {
        final qty = ((i['qty'] as num?) ?? 0).toDouble();
        final qtyStr = qty % 1 == 0 ? qty.toInt().toString() : qty.toString();
        _ings.add(_IngData(
          name: (i['name'] as String?) ?? '',
          qty: qtyStr,
          unit: (i['unit'] as String?) ?? 'kg',
        ));
      }
    }
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final snap = await FirebaseFirestore.instance.collection('products').get();
    if (!mounted) return;
    final products =
        snap.docs.map((d) => ProductsRecord.fromSnapshot(d)).toList();
    products.sort((a, b) => a.name.compareTo(b.name));
    setState(() => _allProducts = products);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _servingsCtrl.dispose();
    _timeCtrl.dispose();
    for (final ing in _ings) ing.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) return;
    setState(() => _saving = true);

    final ingredients = _ings
        .where((i) => i.nameCtrl.text.trim().isNotEmpty)
        .map((i) => {
              'name': i.nameCtrl.text.trim(),
              'qty': double.tryParse(i.qtyCtrl.text) ?? 0.0,
              'unit': i.unit,
            })
        .toList();

    final data = <String, dynamic>{
      'name': name,
      'emoji': _selectedEmoji.isEmpty ? '🍽️' : _selectedEmoji,
      'colorHex': _selectedColor,
      'servings': int.tryParse(_servingsCtrl.text) ?? 2,
      'timeMin': int.tryParse(_timeCtrl.text) ?? 10,
      'ingredients': ingredients,
    };

    if (widget.existing != null) {
      await widget.existing!.reference.update(data);
    } else {
      data['createdAt'] = FieldValue.serverTimestamp();
      await widget.collection.add(data);
    }

    if (mounted) Navigator.of(context).pop();
  }

  Color _parseColor(String hex) => Color(int.parse('FF$hex', radix: 16));

  InputDecoration _inputDec(String hint, {String? suffix}) => InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: _kMuted, fontSize: 13),
        suffixText: suffix,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _kBorder)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _kBorder)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _kGreen, width: 1.5)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      );

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return DraggableScrollableSheet(
      initialChildSize: 0.93,
      minChildSize: 0.5,
      maxChildSize: 0.97,
      builder: (_, sc) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    isEdit ? 'Editar Receta' : 'Nueva Receta',
                    style: GoogleFonts.interTight(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: _kText),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Cancelar',
                        style: GoogleFonts.inter(color: _kMuted)),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                controller: sc,
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                children: [
                  // ── Emoji + Nombre ────────────────────────
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Emoji',
                              style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _kMuted)),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () => setState(
                                () => _showEmojiPicker = !_showEmojiPicker),
                            child: Container(
                              width: 62,
                              height: 48,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        _showEmojiPicker ? _kGreen : _kBorder,
                                    width: _showEmojiPicker ? 1.5 : 1),
                                borderRadius: BorderRadius.circular(10),
                                color: const Color(0xFFF9FAFB),
                              ),
                              child: Center(
                                child: Text(_selectedEmoji,
                                    style: const TextStyle(fontSize: 24)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Nombre de la receta',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _kMuted)),
                            const SizedBox(height: 4),
                            TextField(
                              controller: _nameCtrl,
                              style: GoogleFonts.inter(fontSize: 14),
                              decoration: _inputDec('Ej: Guacamole Clásico'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (_showEmojiPicker) ...[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color(0xFFF9FAFB),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: _kBorder)),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 8,
                                childAspectRatio: 1,
                                mainAxisSpacing: 4,
                                crossAxisSpacing: 4),
                        itemCount: _foodEmojis.length,
                        itemBuilder: (_, i) {
                          final e = _foodEmojis[i];
                          final sel = e == _selectedEmoji;
                          return GestureDetector(
                            onTap: () => setState(() {
                              _selectedEmoji = e;
                              _showEmojiPicker = false;
                            }),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: sel
                                      ? _kGreen.withOpacity(0.15)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6)),
                              child: Center(
                                  child: Text(e,
                                      style: const TextStyle(fontSize: 20))),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),

                  // ── Color de tarjeta ──────────────────────
                  Text('Color de la tarjeta',
                      style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _kMuted)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: widget.colorPalette.map((hex) {
                      final sel = hex == _selectedColor;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedColor = hex),
                        child: Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: _parseColor(hex),
                            shape: BoxShape.circle,
                            border: sel
                                ? Border.all(color: Colors.black87, width: 2.5)
                                : Border.all(color: Colors.transparent),
                          ),
                          child: sel
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 20)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // ── Personas + Tiempo ─────────────────────
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Personas',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _kMuted)),
                            const SizedBox(height: 4),
                            TextField(
                              controller: _servingsCtrl,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.inter(fontSize: 14),
                              decoration: _inputDec('4'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Tiempo',
                                style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: _kMuted)),
                            const SizedBox(height: 4),
                            TextField(
                              controller: _timeCtrl,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.inter(fontSize: 14),
                              decoration: _inputDec('15', suffix: 'min'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // ── Ingredientes ──────────────────────────
                  Row(
                    children: [
                      Text('Ingredientes',
                          style: GoogleFonts.interTight(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: _kText)),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => setState(() => _ings.add(_IngData())),
                        icon: const Icon(Icons.add_rounded,
                            size: 16, color: _kGreen),
                        label: Text('Agregar',
                            style: GoogleFonts.inter(
                                fontSize: 13, color: _kGreen)),
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4)),
                      ),
                    ],
                  ),
                  if (_allProducts.isEmpty)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Text('Cargando productos...',
                          style:
                              GoogleFonts.inter(fontSize: 12, color: _kMuted)),
                    ),
                  const SizedBox(height: 4),

                  // ── Ingredient rows ───────────────────────
                  for (var idx = 0; idx < _ings.length; idx++)
                    _IngredientRow(
                      key: ObjectKey(_ings[idx]),
                      ing: _ings[idx],
                      products: _allProducts,
                      onUnitChanged: (u) => setState(() => _ings[idx].unit = u),
                      onRemove: () => setState(() {
                        _ings[idx].dispose();
                        _ings.removeAt(idx);
                      }),
                    ),
                  const SizedBox(height: 28),

                  // ── Guardar ───────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _save,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _kGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                        elevation: 0,
                      ),
                      child: _saving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.white))
                          : Text(
                              isEdit ? 'Guardar cambios' : 'Crear receta',
                              style: GoogleFonts.interTight(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

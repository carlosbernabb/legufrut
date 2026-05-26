import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'admincreateproduct_model.dart';
export 'admincreateproduct_model.dart';

class AdmincreateproductWidget extends StatefulWidget {
  const AdmincreateproductWidget({super.key});

  static String routeName = 'admincreateproduct';
  static String routePath = '/admincreateproduct';

  @override
  State<AdmincreateproductWidget> createState() =>
      _AdmincreateproductWidgetState();
}

class _AdmincreateproductWidgetState extends State<AdmincreateproductWidget> {
  late AdmincreateproductModel _model;

  // ── Color constants (same as home page) ─────────────────────
  static const _kGreen = Color(0xFF2E7D32);
  static const _kGreenLight = Color(0xFFE8F5E9);
  static const _kBg = Color(0xFFF8F4EF);
  static const _kText = Color(0xFF1A1A1A);
  static const _kMuted = Color(0xFF6B7280);
  static const _kBorder = Color(0xFFE5E7EB);
  static const _kDarkGreen = Color(0xFF2D5016);
  static const _kRed = Color(0xFFEF5350);

  // ── Category config ──────────────────────────────────────────
  static const _categories = [
    {
      'name': 'Frutas',
      'key': 'Frutas',
      'icon': Icons.apple_outlined,
      'color': Color(0xFFFF8F00),
    },
    {
      'name': 'Verduras',
      'key': 'Verduras',
      'icon': Icons.eco_outlined,
      'color': Color(0xFF388E3C),
    },
    {
      'name': 'Chiles',
      'key': 'Chiles–Semillas–Plantas',
      'icon': Icons.local_fire_department_outlined,
      'color': Color(0xFFD32F2F),
    },
    {
      'name': 'Abarrotes',
      'key': 'Abarrotes',
      'icon': Icons.shopping_basket_outlined,
      'color': Color(0xFF7B1FA2),
    },
    {
      'name': 'Desechables y Limpieza',
      'key': 'Desechables y Limpieza',
      'icon': Icons.cleaning_services_rounded,
      'color': Color(0xFF0277BD),
    },
    {
      'name': 'Carnes',
      'key': 'Carnes',
      'icon': Icons.restaurant_outlined,
      'color': Color(0xFF795548),
    },
  ];

  static const _categoryOptions = [
    'Frutas',
    'Verduras',
    'Chiles–Semillas–Plantas',
    'Abarrotes',
    'Desechables y Limpieza',
    'Carnes',
  ];
  static const _categoryLabels = [
    'Frutas',
    'Verduras',
    'Chiles / Semillas / Plantas',
    'Abarrotes',
    'Desechables y Limpieza',
    'Carnes',
  ];
  static const _saleTypeOptions = ['Por Kilo', 'Por Pieza'];

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AdmincreateproductModel());

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!valueOrDefault<bool>(currentUserDocument?.isadmin, false)) {
        context.pushNamed(HomePageWidget.routeName);
      }
    });

    _model.nameController = TextEditingController();
    _model.nameFocusNode = FocusNode();
    _model.descController = TextEditingController();
    _model.descFocusNode = FocusNode();
    _model.priceController = TextEditingController();
    _model.priceFocusNode = FocusNode();
    _model.searchController = TextEditingController();
    _model.searchFocusNode = FocusNode();
    _model.editingPriceController = TextEditingController();
    _model.editingPriceFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _model.maybeDispose();
    super.dispose();
  }

  // ── Helpers ──────────────────────────────────────────────────

  bool _isPiece(String saleType) {
    final t = saleType.toLowerCase();
    return t.contains('pieza') || t.contains('pza') || t.contains('piece');
  }

  String _unitLabel(String saleType) => _isPiece(saleType) ? 'pza' : 'kg';

  // ── Actions ──────────────────────────────────────────────────

  Future<void> _saveProduct() async {
    if (!(_model.formKey.currentState?.validate() ?? false)) return;
    if (_model.categoryValue == null) {
      _showSnack('Selecciona una categoría', isError: true);
      return;
    }
    if (_model.saleTypeValue == null) {
      _showSnack('Selecciona cómo se vende', isError: true);
      return;
    }

    safeSetState(() => _model.isSaving = true);
    try {
      String imageUrl = _model.uploadedFileUrl;

      await ProductsRecord.collection.doc().set(createProductsRecordData(
            name: _model.nameController!.text.trim(),
            description: _model.descController!.text.trim(),
            category: _model.categoryValue,
            price: double.tryParse(_model.priceController!.text) ?? 0.0,
            saleType: _model.saleTypeValue,
            coverImage: imageUrl,
            createdTime: getCurrentTimestamp,
            owner: currentUserReference,
          ));

      _model.nameController!.clear();
      _model.descController!.clear();
      _model.priceController!.clear();
      safeSetState(() {
        _model.categoryValue = null;
        _model.saleTypeValue = null;
        _model.uploadedFileUrl = '';
        _model.uploadedLocalFile = null;
        _model.isNewProductExpanded = false;
      });
      _showSnack('Producto guardado exitosamente');
    } catch (e) {
      _showSnack('Error al guardar: $e', isError: true);
    } finally {
      safeSetState(() => _model.isSaving = false);
    }
  }

  Future<void> _deleteProduct(ProductsRecord product) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Eliminar producto',
            style: GoogleFonts.interTight(fontWeight: FontWeight.w700)),
        content: Text('¿Eliminar "${product.name}"? Esta acción no se puede deshacer.',
            style: GoogleFonts.inter(color: _kMuted)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancelar', style: GoogleFonts.inter(color: _kMuted)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text('Eliminar',
                style: GoogleFonts.inter(color: _kRed, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
    if (confirm != true) return;
    await product.reference.delete();
    _showSnack('"${product.name}" eliminado');
  }

  Future<void> _saveInlinePrice(ProductsRecord product) async {
    final newPrice = double.tryParse(_model.editingPriceController!.text);
    if (newPrice == null || newPrice < 0) {
      _showSnack('Precio inválido', isError: true);
      return;
    }
    await product.reference.update({'price': newPrice});
    safeSetState(() => _model.editingProductId = null);
    _showSnack('Precio actualizado');
  }

  Future<void> _toggleSaleType(ProductsRecord product) async {
    final cat = product.category.toLowerCase();
    if (cat.contains('desechables')) {
      _showSnack('Desechables y Limpieza siempre se venden por pieza',
          isError: true);
      return;
    }
    final current = product.saleType.toLowerCase();
    final newType = current.contains('pieza') ? 'Por Kilo' : 'Por Pieza';
    await product.reference.update({'saleType': newType});
    _showSnack('Tipo cambiado a $newType');
  }

  Future<void> _pickImage() async {
    final selectedMedia = await selectMedia(
      mediaSource: MediaSource.photoGallery,
      multiImage: false,
    );
    if (selectedMedia == null || selectedMedia.isEmpty) return;
    final picked = selectedMedia.first;
    safeSetState(() {
      _model.isDataUploading = true;
      _model.uploadedLocalFile = picked;
    });
    try {
      final url = await uploadData(
        'products/${DateTime.now().millisecondsSinceEpoch}_${picked.storagePath.split('/').last}',
        picked.bytes,
      );
      safeSetState(() {
        _model.uploadedFileUrl = url ?? '';
        _model.isDataUploading = false;
      });
    } catch (e) {
      safeSetState(() => _model.isDataUploading = false);
      _showSnack('Error subiendo imagen', isError: true);
    }
  }

  void _showSnack(String msg, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg, style: GoogleFonts.inter(color: Colors.white)),
      backgroundColor: isError ? _kRed : _kGreen,
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  // ── BUILD ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return StreamBuilder<List<ProductsRecord>>(
      stream: queryProductsRecord(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: _kBg,
            body: const Center(
              child: CircularProgressIndicator(color: _kGreen),
            ),
          );
        }

        final allProducts = snapshot.data!;
        final query = _model.searchQuery.toLowerCase();
        final filtered = query.isEmpty
            ? allProducts
            : allProducts
                .where((p) =>
                    p.name.toLowerCase().contains(query) ||
                    p.category.toLowerCase().contains(query))
                .toList();

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            safeSetState(() => _model.editingProductId = null);
          },
          child: Scaffold(
            backgroundColor: _kBg,
            appBar: AppBar(
              backgroundColor: _kDarkGreen,
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                onPressed: () => context.pushNamed(AdminHubWidget.routeName),
              ),
              title: Text(
                'Gestor de Productos',
                style: GoogleFonts.interTight(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.receipt_long_outlined, color: Colors.white),
                  tooltip: 'Ver Órdenes',
                  onPressed: () =>
                      context.pushNamed(OrdenesAdminWidget.routeName),
                ),
                IconButton(
                  icon: const Icon(Icons.campaign_outlined, color: Colors.white),
                  tooltip: 'Enviar Alerta',
                  onPressed: () =>
                      context.pushNamed(RecuadroAlertaWidget.routeName),
                ),
                const SizedBox(width: 4),
              ],
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 12),
                    _buildNewProductTile(),
                    const SizedBox(height: 16),
                    Text(
                      'Inventario por categoría',
                      style: GoogleFonts.interTight(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: _kText,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ..._categories.map((cat) {
                      final catProducts = filtered
                          .where((p) => p.category == cat['key'] as String)
                          .toList()
                        ..sort((a, b) => a.name.compareTo(b.name));
                      return _buildCategorySection(
                        name: cat['name'] as String,
                        key: cat['key'] as String,
                        icon: cat['icon'] as IconData,
                        color: cat['color'] as Color,
                        products: catProducts,
                      );
                    }),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton.extended(
              backgroundColor: _kGreen,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text(
                'Nuevo Producto',
                style: GoogleFonts.interTight(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              onPressed: () {
                safeSetState(
                    () => _model.isNewProductExpanded = !_model.isNewProductExpanded);
                if (_model.isNewProductExpanded) {
                  Future.delayed(const Duration(milliseconds: 100), () {
                    _model.nameFocusNode?.requestFocus();
                  });
                }
              },
            ),
          ),
        );
      },
    );
  }

  // ── SEARCH BAR ───────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: TextField(
        controller: _model.searchController,
        focusNode: _model.searchFocusNode,
        onChanged: (v) => safeSetState(() => _model.searchQuery = v),
        style: GoogleFonts.inter(fontSize: 14, color: _kText),
        decoration: InputDecoration(
          hintText: 'Buscar producto...',
          hintStyle: GoogleFonts.inter(color: _kMuted, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: _kMuted, size: 20),
          suffixIcon: _model.searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: _kMuted, size: 18),
                  onPressed: () {
                    _model.searchController!.clear();
                    safeSetState(() => _model.searchQuery = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  // ── NEW PRODUCT COLLAPSIBLE ──────────────────────────────────
  Widget _buildNewProductTile() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => safeSetState(
                () => _model.isNewProductExpanded = !_model.isNewProductExpanded),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: _kGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Agregar nuevo producto',
                      style: GoogleFonts.interTight(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _kText,
                      ),
                    ),
                  ),
                  AnimatedRotation(
                    turns: _model.isNewProductExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const Icon(Icons.chevron_right, color: _kMuted),
                  ),
                ],
              ),
            ),
          ),
          // Form
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: _model.isNewProductExpanded
                ? _buildNewProductForm()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildNewProductForm() {
    return Form(
      key: _model.formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Divider(height: 1, color: _kBorder),
            const SizedBox(height: 16),

            // Name
            _label('Nombre del producto'),
            const SizedBox(height: 6),
            _textField(
              controller: _model.nameController!,
              focusNode: _model.nameFocusNode!,
              hint: 'ej. Manzana Golden',
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? 'Nombre requerido' : null,
            ),
            const SizedBox(height: 12),

            // Category
            _label('Categoría'),
            const SizedBox(height: 6),
            _buildDropdown(
              value: _model.categoryValue,
              options: _categoryOptions,
              labels: _categoryLabels,
              hint: 'Selecciona categoría',
              onChanged: (v) => safeSetState(() {
                _model.categoryValue = v;
                if (v == 'Abarrotes' || v == 'Desechables y Limpieza') {
                  _model.saleTypeValue = 'Por Pieza';
                }
              }),
            ),
            const SizedBox(height: 12),

            // Sale type
            _label('¿Cómo se vende?'),
            const SizedBox(height: 6),
            if (_model.categoryValue == 'Desechables y Limpieza')
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: _kBorder),
                ),
                child: Row(
                  children: [
                    Text('Por Pieza',
                        style: GoogleFonts.inter(
                            fontSize: 14,
                            color: _kText,
                            fontWeight: FontWeight.w500)),
                    const Spacer(),
                    Text('(fijo para esta categoría)',
                        style:
                            GoogleFonts.inter(fontSize: 11, color: _kMuted)),
                  ],
                ),
              )
            else
              _buildDropdown(
                value: _model.saleTypeValue,
                options: _saleTypeOptions,
                labels: _saleTypeOptions,
                hint: 'Por Kilo / Por Pieza',
                onChanged: (v) => safeSetState(() => _model.saleTypeValue = v),
              ),
            const SizedBox(height: 12),

            // Price
            _label(_model.saleTypeValue == 'Por Pieza'
                ? 'Precio por pieza (\$)'
                : 'Precio por kilo (\$)'),
            const SizedBox(height: 6),
            _textField(
              controller: _model.priceController!,
              focusNode: _model.priceFocusNode!,
              hint: '0.00',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Precio requerido';
                if (double.tryParse(v) == null) return 'Número inválido';
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Description
            _label('Descripción (opcional)'),
            const SizedBox(height: 6),
            _textField(
              controller: _model.descController!,
              focusNode: _model.descFocusNode!,
              hint: 'Breve descripción del producto',
              maxLines: 2,
            ),
            const SizedBox(height: 12),

            // Image picker
            _label('Imagen del producto'),
            const SizedBox(height: 6),
            GestureDetector(
              onTap: _model.isDataUploading ? null : _pickImage,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  color: _kBorder.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: _kBorder),
                ),
                child: _model.isDataUploading
                    ? const Center(
                        child: CircularProgressIndicator(color: _kGreen, strokeWidth: 2))
                    : _model.uploadedFileUrl.isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(_model.uploadedFileUrl,
                                fit: BoxFit.cover, width: double.infinity),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.add_photo_alternate_outlined,
                                  color: _kMuted, size: 28),
                              const SizedBox(height: 4),
                              Text('Seleccionar imagen',
                                  style:
                                      GoogleFonts.inter(color: _kMuted, fontSize: 12)),
                            ],
                          ),
              ),
            ),
            const SizedBox(height: 16),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _model.isSaving ? null : _saveProduct,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _kGreen,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: _model.isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : Text('Guardar producto',
                        style: GoogleFonts.interTight(
                            fontWeight: FontWeight.w700, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── CATEGORY SECTION ─────────────────────────────────────────
  Widget _buildCategorySection({
    required String name,
    required String key,
    required IconData icon,
    required Color color,
    required List<ProductsRecord> products,
  }) {
    final isExpanded = _model.expandedCategories.contains(key);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        children: [
          // Header tile
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => safeSetState(() {
              if (isExpanded) {
                _model.expandedCategories.remove(key);
              } else {
                _model.expandedCategories.add(key);
              }
            }),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: color, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      name,
                      style: GoogleFonts.interTight(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: _kText,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: products.isEmpty ? _kBorder : color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${products.length} productos',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: products.isEmpty ? _kMuted : color,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedRotation(
                    turns: isExpanded ? 0.25 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(Icons.chevron_right, color: _kMuted, size: 20),
                  ),
                ],
              ),
            ),
          ),

          // Toggle visibilidad — solo Carnes
          if (key == 'Carnes')
            StreamBuilder<List<AppConfigRecord>>(
              stream: queryAppConfigRecord(singleRecord: true),
              builder: (context, snap) {
                if (!snap.hasData || snap.data!.isEmpty) {
                  return const SizedBox.shrink();
                }
                final config = snap.data!.first;
                final enabled = config.carnasEnabled;
                return Column(
                  children: [
                    const Divider(height: 1, color: _kBorder),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(14, 8, 14, 8),
                      child: Row(
                        children: [
                          Icon(
                            enabled
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            size: 16,
                            color: enabled
                                ? const Color(0xFF795548)
                                : _kMuted,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Visible para clientes',
                                  style: GoogleFonts.interTight(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: _kText,
                                  ),
                                ),
                                Text(
                                  enabled
                                      ? 'Activa — aparece en el home'
                                      : 'Oculta — actívala cuando estés listo',
                                  style: GoogleFonts.inter(
                                      fontSize: 11, color: _kMuted),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: enabled,
                            onChanged: (v) async {
                              await config.reference.update(
                                  createAppConfigRecordData(
                                      carnasEnabled: v));
                            },
                            activeColor: const Color(0xFF795548),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

          // Products list
          AnimatedSize(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: isExpanded
                ? products.isEmpty
                    ? Padding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        child: Text('Sin productos en esta categoría',
                            style: GoogleFonts.inter(color: _kMuted, fontSize: 13)),
                      )
                    : Column(
                        children: [
                          const Divider(height: 1, color: _kBorder),
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            itemCount: products.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 1, color: _kBorder, indent: 70),
                            itemBuilder: (_, i) =>
                                _buildProductItem(products[i]),
                          ),
                        ],
                      )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  // ── PRODUCT ITEM ─────────────────────────────────────────────
  Widget _buildProductItem(ProductsRecord product) {
    final isEditing = _model.editingProductId == product.reference.id;
    final unitLabel = _unitLabel(product.saleType);
    final isPiece = _isPiece(product.saleType);

    if (isEditing) {
      // Inline price editor
      return Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 50,
                height: 50,
                child: product.coverImage.isNotEmpty
                    ? Image.network(product.coverImage, fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(color: _kBorder, child: const Icon(Icons.image_not_supported, size: 20, color: _kMuted)))
                    : Container(color: _kBorder,
                        child: const Icon(Icons.image_not_supported, size: 20, color: _kMuted)),
              ),
            ),
            const SizedBox(width: 10),
            // Price editor
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: GoogleFonts.interTight(
                          fontSize: 13, fontWeight: FontWeight.w700, color: _kText)),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _model.editingPriceController,
                          focusNode: _model.editingPriceFocusNode,
                          keyboardType:
                              const TextInputType.numberWithOptions(decimal: true),
                          autofocus: true,
                          style: GoogleFonts.inter(fontSize: 14, color: _kText),
                          decoration: InputDecoration(
                            prefixText: '\$ ',
                            suffixText: '/ $unitLabel',
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 8),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: _kGreen)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide:
                                    const BorderSide(color: _kGreen, width: 2)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () => _saveInlinePrice(product),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: _kGreen,
                              borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.check, color: Colors.white, size: 18),
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () =>
                            safeSetState(() => _model.editingProductId = null),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: _kBorder,
                              borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.close, color: _kMuted, size: 18),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    // Normal view
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
      child: Row(
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 50,
              height: 50,
              child: product.coverImage.isNotEmpty
                  ? Image.network(product.coverImage, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: _kBorder,
                              child: const Icon(Icons.image_not_supported, size: 20, color: _kMuted)))
                  : Container(color: _kBorder,
                      child: const Icon(Icons.image_not_supported, size: 20, color: _kMuted)),
            ),
          ),
          const SizedBox(width: 10),

          // Name + price
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: GoogleFonts.interTight(
                      fontSize: 13, fontWeight: FontWeight.w700, color: _kText),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    // Price — tap to edit
                    GestureDetector(
                      onTap: () {
                        _model.editingPriceController!.text =
                            product.price.toStringAsFixed(2);
                        safeSetState(
                            () => _model.editingProductId = product.reference.id);
                        Future.delayed(const Duration(milliseconds: 80), () {
                          _model.editingPriceFocusNode?.requestFocus();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: _kGreenLight,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: _kGreen.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)} / $unitLabel',
                              style: GoogleFonts.interTight(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: _kGreen),
                            ),
                            const SizedBox(width: 3),
                            const Icon(Icons.edit, size: 11, color: _kGreen),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Sale type pill toggle — tap to switch pza ↔ kg
                    GestureDetector(
                      onTap: () => _toggleSaleType(product),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEEEEEE),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: _kBorder),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: isPiece ? _kGreen : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'pza',
                                style: GoogleFonts.interTight(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: isPiece ? Colors.white : _kMuted,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 7, vertical: 3),
                              decoration: BoxDecoration(
                                color: !isPiece ? _kGreen : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'kg',
                                style: GoogleFonts.interTight(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: !isPiece ? Colors.white : _kMuted,
                                ),
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
          ),

          // Delete
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: _kRed, size: 20),
            tooltip: 'Eliminar',
            onPressed: () => _deleteProduct(product),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }

  // ── SMALL HELPERS ────────────────────────────────────────────

  Widget _label(String text) => Text(
        text,
        style: GoogleFonts.inter(
            fontSize: 13, fontWeight: FontWeight.w600, color: _kText),
      );

  Widget _textField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      style: GoogleFonts.inter(fontSize: 14, color: _kText),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.inter(color: _kMuted, fontSize: 13),
        filled: true,
        fillColor: const Color(0xFFF9F9F9),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _kBorder)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _kBorder)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _kGreen, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: _kRed)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> options,
    required List<String> labels,
    required String hint,
    required void Function(String?) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _kBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(hint,
              style: GoogleFonts.inter(color: _kMuted, fontSize: 13)),
          style: GoogleFonts.inter(fontSize: 14, color: _kText),
          items: List.generate(
            options.length,
            (i) => DropdownMenuItem(
              value: options[i],
              child: Text(labels[i]),
            ),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}

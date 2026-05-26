import 'package:cloud_firestore/cloud_firestore.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/backend/firebase_storage/storage.dart';
import '/components/universal_product_card_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/upload_data.dart';
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:text_search/text_search.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class _RecipeIngredient {
  const _RecipeIngredient(this.name, this.qty, this.unit);
  final String name;
  final double qty;
  final String unit; // 'pza', 'kg', 'g'
}

class _RecipeData {
  const _RecipeData({
    required this.name,
    required this.emoji,
    required this.color,
    required this.servings,
    required this.timeMin,
    required this.ingredients,
  });
  final String name;
  final String emoji;
  final Color color;
  final int servings;
  final int timeMin;
  final List<_RecipeIngredient> ingredients;
}

// Convierte un documento de Firestore 'recipes' a _RecipeData
_RecipeData _docToRecipe(DocumentSnapshot doc) {
  final d = doc.data() as Map<String, dynamic>;
  final rawIng = (d['ingredients'] as List<dynamic>?) ?? [];
  return _RecipeData(
    name: (d['name'] as String?) ?? '',
    emoji: (d['emoji'] as String?) ?? '🍽️',
    color: _hexToColor((d['colorHex'] as String?) ?? '4CAF50'),
    servings: (d['servings'] as int?) ?? 2,
    timeMin: (d['timeMin'] as int?) ?? 10,
    ingredients: rawIng
        .map((i) => _RecipeIngredient(
              (i['name'] as String?) ?? '',
              ((i['qty'] as num?) ?? 0).toDouble(),
              (i['unit'] as String?) ?? 'kg',
            ))
        .toList(),
  );
}

Color _hexToColor(String hex) {
  try {
    return Color(int.parse('FF${hex.replaceAll('#', '')}', radix: 16));
  } catch (_) {
    return const Color(0xFF4CAF50);
  }
}

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  static String routeName = 'HomePage';
  static String routePath = '/homePage';

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget>
    with TickerProviderStateMixin {
  late HomePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final Set<String> _expandedCategories = {};

  static const _kGreen = Color(0xFF2E7D32);
  static const _kHeroBg = Color(0xFFEEF5EE);
  static const _kBg = Color(0xFFF8F4EF);
  static const _kText = Color(0xFF1A1A1A);
  static const _kMuted = Color(0xFF6B7280);
  static const _kBorder = Color(0xFFE5E7EB);
  static const _kDarkGreen = Color(0xFF2D5016);
  static const _kGreenLight = Color(0xFFE8F5E9);
  static const _kRed = Color(0xFFEF5350);

  // ── Drawer state ─────────────────────────────────────────
  bool _drawerEditingName = false;
  final TextEditingController _drawerNameCtrl = TextEditingController();
  bool _drawerUploadingPhoto = false;

  // Fixed height for each product card in the vertical 2-column grid
  static const double _cardH = 370.0;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _drawerNameCtrl.dispose();
    _model.dispose();
    super.dispose();
  }

  // ── Profile photo pick ───────────────────────────────────
  Future<void> _pickProfilePhoto() async {
    final picked = await selectMedia(
      mediaSource: MediaSource.photoGallery,
      isVideo: false,
    );
    if (picked == null || picked.isEmpty || picked.first.bytes == null) return;
    safeSetState(() => _drawerUploadingPhoto = true);
    final url = await uploadData(
      'users/${currentUserUid}/profile.jpg',
      picked.first.bytes!,
    );
    if (url != null && currentUserReference != null) {
      await currentUserReference!.update({'photo_url': url});
    }
    safeSetState(() => _drawerUploadingPhoto = false);
  }

  Future<void> _saveDisplayName() async {
    final name = _drawerNameCtrl.text.trim();
    if (name.isEmpty) return;
    if (currentUserReference != null) {
      await currentUserReference!.update({'display_name': name});
    }
    safeSetState(() => _drawerEditingName = false);
  }

  void _toggleCategory(String key) {
    safeSetState(() {
      if (_expandedCategories.contains(key)) {
        _expandedCategories.remove(key);
      } else {
        _expandedCategories.add(key);
      }
    });
  }

  // ─────────────────────────────────────────────────────────
  //  BUILD
  // ─────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return StreamBuilder<List<ProductsRecord>>(
      stream: queryProductsRecord(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  FlutterFlowTheme.of(context).primary,
                ),
              ),
            ),
          );
        }

        final allProducts = snapshot.data!;

        return GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Scaffold(
            key: scaffoldKey,
            backgroundColor: _kBg,
            drawer: _buildDrawer(context),
            bottomNavigationBar: _buildBottomNav(context),
            body: SafeArea(
              top: true,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeroSection(context),
                        _buildPreparaTuPlatillo(context, allProducts),
                        const SizedBox(height: 10),
                        _buildSearchBar(context, allProducts),
                        if (FFAppState().buscador)
                          _buildSearchResults(context)
                        else ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                            child: Text(
                              'Explora por categoría',
                              style: GoogleFonts.interTight(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: _kText,
                              ),
                            ),
                          ),
                          _buildCategoryTile(
                            context: context,
                            categoryName: 'Frutas',
                            categoryKey: 'Frutas',
                            icon: Icons.apple,
                            imageUrl:
                                'https://images.unsplash.com/photo-1610832958506-aa56368176cf?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=800',
                            allProducts: allProducts,
                            filterKey: 'Frutas',
                            models: _model.productcardModels2,
                          ),
                          _buildCategoryTile(
                            context: context,
                            categoryName: 'Verduras',
                            categoryKey: 'Verduras',
                            icon: Icons.eco,
                            imageUrl:
                                'https://images.unsplash.com/photo-1540420773420-3366772f4999?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=800',
                            allProducts: allProducts,
                            filterKey: 'Verduras',
                            models: _model.productcardModels3,
                          ),
                          _buildCategoryTile(
                            context: context,
                            categoryName: 'Chiles',
                            categoryKey: 'Chiles',
                            icon: Icons.whatshot,
                            imageUrl:
                                'https://images.unsplash.com/photo-1583119022894-919a68a3d0e3?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=800',
                            allProducts: allProducts,
                            filterKey: 'Chiles–Semillas–Plantas',
                            models: _model.productcardModels5,
                          ),
                          _buildCategoryTile(
                            context: context,
                            categoryName: 'Abarrotes',
                            categoryKey: 'Abarrotes',
                            icon: Icons.shopping_bag,
                            imageUrl:
                                'https://images.unsplash.com/photo-1534723452862-4c874018d66d?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=800',
                            allProducts: allProducts,
                            filterKey: 'Abarrotes',
                            models: _model.piezascomponentModels1,
                          ),
                          _buildCategoryTile(
                            context: context,
                            categoryName: 'Desechables y Limpieza',
                            categoryKey: 'Desechables y Limpieza',
                            icon: Icons.cleaning_services_rounded,
                            imageUrl:
                                'https://images.unsplash.com/photo-1563453392212-326f5e854473?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=800',
                            allProducts: allProducts,
                            filterKey: 'Desechables y Limpieza',
                            models: _model.productcardModels7,
                            forcePieza: true,
                          ),
                          StreamBuilder<List<AppConfigRecord>>(
                            stream: queryAppConfigRecord(singleRecord: true),
                            builder: (context, cfgSnap) {
                              final carnasOn =
                                  (cfgSnap.data?.isNotEmpty == true)
                                      ? cfgSnap.data!.first.carnasEnabled
                                      : false;
                              if (!carnasOn) return const SizedBox.shrink();
                              return _buildCategoryTile(
                                context: context,
                                categoryName: 'Carnes',
                                categoryKey: 'Carnes',
                                icon: Icons.restaurant_rounded,
                                imageUrl:
                                    'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=800',
                                allProducts: allProducts,
                                filterKey: 'Carnes',
                                models: _model.productcardModels8,
                              );
                            },
                          ),
                          const SizedBox(height: 32),
                        ],
                      ],
                    ),
                  ),
                  if (FFAppState().showPopup == true)
                    _buildPopupOverlay(context),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────
  //  HERO SECTION
  // ─────────────────────────────────────────────────────────
  Widget _buildHeroSection(BuildContext context) {
    return Container(
      color: _kHeroBg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top action bar
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
            child: Row(
              children: [
                _iconBtn(
                  icon: Icons.menu,
                  onPressed: () => scaffoldKey.currentState!.openDrawer(),
                ),
                const SizedBox(width: 10),
                // Brand logo
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(width: 6),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'legu',
                            style: GoogleFonts.interTight(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF2E7D32),
                              letterSpacing: -0.5,
                            ),
                          ),
                          TextSpan(
                            text: 'frut',
                            style: GoogleFonts.interTight(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFFFF7043),
                              letterSpacing: -0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                AuthUserStreamWidget(
                  builder: (context) {
                    if (valueOrDefault<bool>(
                        currentUserDocument?.isadmin, false)) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _iconBtn(
                          icon: Icons.edit_outlined,
                          onPressed: () =>
                              context.pushNamed(AdminHubWidget.routeName),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                AuthUserStreamWidget(
                  builder: (context) {
                    final isDriver = valueOrDefault<bool>(
                        currentUserDocument?.isDriver, false);
                    final isAdmin = valueOrDefault<bool>(
                        currentUserDocument?.isadmin, false);
                    if (isDriver || isAdmin) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _iconBtn(
                          icon: Icons.sports_motorsports_outlined,
                          onPressed: () => context
                              .pushNamed(DriverPanelWidget.routeName),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                _iconBtn(
                  icon: Icons.notifications_outlined,
                  onPressed: () =>
                      context.pushNamed(NotificacionesWidget.routeName),
                ),
                const SizedBox(width: 8),
                _buildCartBadge(context),
              ],
            ),
          ),
          // Welcome content
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 0, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  flex: 55,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Bienvenido a tu',
                        style: GoogleFonts.interTight(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: _kText,
                          height: 1.2,
                        ),
                      ),
                      Text(
                        'tienda favorita!',
                        style: GoogleFonts.interTight(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: _kText,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Productos frescos, calidad\nque se nota. 🌿',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: _kMuted,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 45,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                    ),
                    child: Image.network(
                      'https://images.unsplash.com/photo-1542838132-92c53300491e?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&q=80&w=400',
                      height: 130,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          const SizedBox(height: 130),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBtn({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: _kText, size: 22),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildCartBadge(BuildContext context) {
    if (!loggedIn) {
      return _iconBtn(
        icon: Icons.shopping_cart_outlined,
        onPressed: () => context.pushNamed(CarritoWidget.routeName),
      );
    }
    return StreamBuilder<List<CartRecord>>(
      stream: queryCartRecord(
        queryBuilder: (q) =>
            q.where('userRef', isEqualTo: currentUserReference),
      ),
      builder: (context, snap) {
        final count = snap.data?.length ?? 0;
        return Stack(
          clipBehavior: Clip.none,
          children: [
            _iconBtn(
              icon: Icons.shopping_cart_outlined,
              onPressed: () => context.pushNamed(CarritoWidget.routeName),
            ),
            if (count > 0)
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: _kGreen,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$count',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  // ─────────────────────────────────────────────────────────
  //  SEARCH BAR
  // ─────────────────────────────────────────────────────────
  Widget _buildSearchBar(
      BuildContext context, List<ProductsRecord> allProducts) {
    return Container(
      color: _kHeroBg,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _model.textController,
                focusNode: _model.textFieldFocusNode,
                onChanged: (_) => EasyDebounce.debounce(
                  '_model.textController',
                  const Duration(milliseconds: 600),
                  () async {
                    safeSetState(() {
                      _model.simpleSearchResults = TextSearch(
                        allProducts
                            .map((r) => TextSearchItem.fromTerms(
                                r, [r.name!, r.category!]))
                            .toList(),
                      )
                          .search(_model.textController.text)
                          .map((r) => r.object)
                          .toList();
                    });
                    FFAppState().buscador =
                        _model.textController.text.isNotEmpty;
                    safeSetState(() {});
                  },
                ),
                decoration: InputDecoration(
                  hintText:
                      'Buscar frutas, verduras, semillas, abarrotes...',
                  hintStyle: GoogleFonts.inter(
                    color: const Color(0xFF9CA3AF),
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 14),
                ),
                style: GoogleFonts.inter(fontSize: 14, color: _kText),
              ),
            ),
            if (FFAppState().buscador)
              IconButton(
                icon: const Icon(Icons.close,
                    color: Color(0xFF9CA3AF), size: 18),
                onPressed: () {
                  FFAppState().buscador = false;
                  safeSetState(() {});
                  safeSetState(() => _model.textController?.clear());
                },
              ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  SEARCH RESULTS (flat, all categories)
  // ─────────────────────────────────────────────────────────
  Widget _buildSearchResults(BuildContext context) {
    final results = _model.simpleSearchResults;

    if (results.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Text(
            'Sin resultados para "${_model.textController?.text}"',
            style: GoogleFonts.inter(color: _kMuted),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${results.length} resultado${results.length != 1 ? 's' : ''}',
            style: GoogleFonts.inter(fontSize: 13, color: _kMuted),
          ),
          const SizedBox(height: 10),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              mainAxisExtent: _cardH,
            ),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final product = results[index];
              return wrapWithModel(
                model: _model.productcardModels1.getModel(
                  product.reference.id,
                  index,
                ),
                updateCallback: () => safeSetState(() {}),
                child: UniversalProductCardWidget(
                  key: Key('Search_${product.reference.id}'),
                  coverimage: product.coverImage,
                  productname: product.name,
                  price: product.price,
                  productRef: product.reference,
                  saleType: product.saleType,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  CATEGORY TILE (expandable)
  // ─────────────────────────────────────────────────────────
  Widget _buildCategoryTile({
    required BuildContext context,
    required String categoryName,
    required String categoryKey,
    required IconData icon,
    required String imageUrl,
    required List<ProductsRecord> allProducts,
    required String filterKey,
    required FlutterFlowDynamicModels<UniversalProductCardModel> models,
    bool comingSoon = false,
    bool forcePieza = false,
  }) {
    final isExpanded = _expandedCategories.contains(categoryKey);
    final products =
        allProducts.where((p) => p.category == filterKey).toList()
          ..sort((a, b) => a.name.compareTo(b.name));

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
      child: Column(
        children: [
          // Banner
          GestureDetector(
            onTap: () => _toggleCategory(categoryKey),
            child: Container(
              height: 88,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Container(color: Colors.grey.shade400),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.black.withOpacity(0.65),
                            Colors.black.withOpacity(0.20),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        children: [
                          Icon(icon, color: Colors.white, size: 28),
                          const SizedBox(width: 14),
                          Text(
                            categoryName,
                            style: GoogleFonts.interTight(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          const Spacer(),
                          AnimatedRotation(
                            turns: isExpanded ? 0.25 : 0,
                            duration: const Duration(milliseconds: 250),
                            child: const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Expanded products
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isExpanded
                ? _buildCategoryProducts(
                    products: products,
                    models: models,
                    comingSoon: comingSoon,
                    forcePieza: forcePieza,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryProducts({
    required List<ProductsRecord> products,
    required FlutterFlowDynamicModels<UniversalProductCardModel> models,
    required bool comingSoon,
    bool forcePieza = false,
  }) {
    if (comingSoon || products.isEmpty) {
      return Container(
        margin: const EdgeInsets.only(top: 12),
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: _kBorder),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                comingSoon
                    ? Icons.hourglass_empty_rounded
                    : Icons.inventory_2_outlined,
                color: const Color(0xFF9CA3AF),
                size: 28,
              ),
              const SizedBox(height: 6),
              Text(
                comingSoon
                    ? 'Próximamente'
                    : 'Sin productos en esta categoría',
                style: GoogleFonts.inter(
                  color: const Color(0xFF9CA3AF),
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: SizedBox(
        height: _cardH * 2 + 12,
        child: GridView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            mainAxisExtent: 148,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return wrapWithModel(
              model: models.getModel(product.reference.id, index),
              updateCallback: () => safeSetState(() {}),
              child: UniversalProductCardWidget(
                key: Key('Cat_${product.reference.id}'),
                coverimage: product.coverImage,
                productname: product.name,
                price: product.price,
                productRef: product.reference,
                saleType: forcePieza ? 'Por Pieza' : product.saleType,
              ),
            );
          },
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  PREPARA TU PLATILLO
  // ─────────────────────────────────────────────────────────
  static const _recipes = [
    _RecipeData(
      name: 'Guacamole Clásico',
      emoji: '🥑',
      color: Color(0xFF4CAF50),
      servings: 4,
      timeMin: 15,
      ingredients: [
        _RecipeIngredient('Aguacate', 0.6, 'kg'),
        _RecipeIngredient('Lima', 0.2, 'kg'),
        _RecipeIngredient('Chile Serrano', 0.08, 'kg'),
        _RecipeIngredient('Cebolla', 0.15, 'kg'),
        _RecipeIngredient('Cilantro', 0.05, 'kg'),
      ],
    ),
    _RecipeData(
      name: 'Ensalada Fresca',
      emoji: '🥗',
      color: Color(0xFF8BC34A),
      servings: 2,
      timeMin: 10,
      ingredients: [
        _RecipeIngredient('Espinaca', 0.15, 'kg'),
        _RecipeIngredient('Uva Verde', 0.2, 'kg'),
        _RecipeIngredient('Fresas', 0.2, 'kg'),
        _RecipeIngredient('Naranja', 0.2, 'kg'),
        _RecipeIngredient('Lima', 0.1, 'kg'),
      ],
    ),
    _RecipeData(
      name: 'Caldo de Verduras',
      emoji: '🍲',
      color: Color(0xFFFF7043),
      servings: 4,
      timeMin: 30,
      ingredients: [
        _RecipeIngredient('Ejote', 0.25, 'kg'),
        _RecipeIngredient('Chayote', 0.4, 'kg'),
        _RecipeIngredient('Espinaca', 0.1, 'kg'),
        _RecipeIngredient('Chile Serrano', 0.08, 'kg'),
      ],
    ),
    _RecipeData(
      name: 'Agua de Frutas',
      emoji: '🍹',
      color: Color(0xFFE91E63),
      servings: 6,
      timeMin: 10,
      ingredients: [
        _RecipeIngredient('Sandía', 2, 'kg'),
        _RecipeIngredient('Lima', 0.25, 'kg'),
        _RecipeIngredient('Naranja', 0.5, 'kg'),
        _RecipeIngredient('Guayaba', 0.5, 'kg'),
      ],
    ),
    _RecipeData(
      name: 'Smoothie Verde',
      emoji: '🥤',
      color: Color(0xFF009688),
      servings: 2,
      timeMin: 5,
      ingredients: [
        _RecipeIngredient('Espinaca', 0.15, 'kg'),
        _RecipeIngredient('Manzana Golden', 0.4, 'kg'),
        _RecipeIngredient('Lima', 0.15, 'kg'),
        _RecipeIngredient('Guayaba', 0.25, 'kg'),
      ],
    ),
    _RecipeData(
      name: 'Ensalada de Frutas',
      emoji: '🍓',
      color: Color(0xFFE91E63),
      servings: 4,
      timeMin: 10,
      ingredients: [
        _RecipeIngredient('Fresas', 0.3, 'kg'),
        _RecipeIngredient('Manzana Golden', 0.3, 'kg'),
        _RecipeIngredient('Pera', 0.4, 'kg'),
        _RecipeIngredient('Uva Verde', 0.2, 'kg'),
        _RecipeIngredient('Lima', 0.1, 'kg'),
      ],
    ),
    _RecipeData(
      name: 'Jugo Verde Detox',
      emoji: '🌿',
      color: Color(0xFF00897B),
      servings: 2,
      timeMin: 5,
      ingredients: [
        _RecipeIngredient('Espinaca', 0.2, 'kg'),
        _RecipeIngredient('Pera', 0.4, 'kg'),
        _RecipeIngredient('Lima', 0.2, 'kg'),
        _RecipeIngredient('Piña', 0.5, 'kg'),
      ],
    ),
    _RecipeData(
      name: 'Botana Veraniega',
      emoji: '🏖️',
      color: Color(0xFFFF8A65),
      servings: 6,
      timeMin: 15,
      ingredients: [
        _RecipeIngredient('Sandía', 1.5, 'kg'),
        _RecipeIngredient('Piña', 0.5, 'kg'),
        _RecipeIngredient('Manzana Golden', 0.5, 'kg'),
        _RecipeIngredient('Lima', 0.2, 'kg'),
        _RecipeIngredient('Chile Serrano', 0.05, 'kg'),
      ],
    ),
  ];

  void _showRecipeSheet(
      BuildContext context, _RecipeData recipe, List<ProductsRecord> allProducts) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _RecipeDetailSheet(recipe: recipe, allProducts: allProducts),
    );
  }

  Widget _buildPreparaTuPlatillo(
      BuildContext context, List<ProductsRecord> allProducts) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('recipes')
          .orderBy('createdAt')
          .snapshots(),
      builder: (context, snap) {
        final liveRecipes = (snap.hasData && snap.data!.docs.isNotEmpty)
            ? snap.data!.docs.map(_docToRecipe).toList()
            : _recipes; // fallback a las recetas estáticas mientras carga
        return _buildRecipesContent(context, liveRecipes, allProducts);
      },
    );
  }

  Widget _buildRecipesContent(BuildContext context,
      List<_RecipeData> recipes, List<ProductsRecord> allProducts) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                'Prepara tu platillo',
                style: GoogleFonts.interTight(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _kText,
                ),
              ),
              const Spacer(),
              Text(
                '${recipes.length} recetas',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: _kGreen,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Toca una receta para agregar todos los ingredientes',
            style: GoogleFonts.inter(fontSize: 12, color: _kMuted),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 168,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: recipes.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final recipe = recipes[index];
                return GestureDetector(
                  onTap: () => _showRecipeSheet(context, recipe, allProducts),
                  child: Container(
                    width: 190,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          recipe.color.withOpacity(0.14),
                          recipe.color.withOpacity(0.04),
                        ],
                      ),
                      border: Border.all(
                          color: recipe.color.withOpacity(0.30), width: 1),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(recipe.emoji,
                            style: const TextStyle(fontSize: 26)),
                        const SizedBox(height: 5),
                        Text(
                          recipe.name,
                          style: GoogleFonts.interTight(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _kText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${recipe.servings} personas · ${recipe.timeMin} min',
                          style: GoogleFonts.inter(
                              fontSize: 11, color: _kMuted),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: recipe.color.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Ver receta →',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: recipe.color,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  BOTTOM NAVIGATION  (Inicio · Carrito · Cuenta)
  // ─────────────────────────────────────────────────────────
  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(
                icon: Icons.home_rounded,
                label: 'Inicio',
                isActive: true,
                onTap: () {},
              ),
              _navCart(context),
              _navItem(
                icon: Icons.person_outline_rounded,
                label: 'Cuenta',
                isActive: false,
                onTap: () {
                  if (loggedIn) {
                    scaffoldKey.currentState!.openDrawer();
                  } else {
                    context.pushNamed(LogginWidget.routeName);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    const active = _kGreen;
    const inactive = Color(0xFF9CA3AF);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isActive ? active : inactive, size: 26),
            const SizedBox(height: 2),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 11,
                color: isActive ? active : inactive,
                fontWeight:
                    isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navCart(BuildContext context) {
    return GestureDetector(
      onTap: () => context.pushNamed(CarritoWidget.routeName),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          color: _kGreen,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x552E7D32),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Icon(
          Icons.shopping_cart_rounded,
          color: Colors.white,
          size: 26,
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  //  DRAWER
  // ─────────────────────────────────────────────────────────
  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // ── Header ────────────────────────────────────────
          Container(
            width: double.infinity,
            color: _kDarkGreen,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                child: loggedIn
                    ? _buildLoggedInHeader()
                    : _buildLoggedOutHeader(),
              ),
            ),
          ),

          // ── Action items ──────────────────────────────────
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 12),
              children: [
                if (loggedIn) ...[
                  _drawerTile(
                    icon: Icons.logout_rounded,
                    iconBg: _kGreenLight,
                    iconColor: _kGreen,
                    title: 'Cerrar sesión',
                    subtitle: 'Salir de tu cuenta actual',
                    onTap: () async {
                      Navigator.pop(context);
                      GoRouter.of(context).prepareAuthEvent();
                      await authManager.signOut();
                      GoRouter.of(context).clearRedirectLocation();
                      if (context.mounted) {
                        context.goNamedAuth(
                            LogginWidget.routeName, context.mounted);
                      }
                    },
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  _drawerTile(
                    icon: Icons.delete_forever_rounded,
                    iconBg: const Color(0xFFFFEBEE),
                    iconColor: _kRed,
                    title: 'Eliminar cuenta',
                    subtitle: 'Esta acción no se puede deshacer',
                    titleColor: _kRed,
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          title: Text('Eliminar cuenta',
                              style: GoogleFonts.interTight(
                                  fontWeight: FontWeight.w700)),
                          content: Text(
                              '¿Estás seguro? Esta acción no se puede deshacer.',
                              style: GoogleFonts.inter(
                                  color: _kMuted, fontSize: 13)),
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
                                      color: _kRed,
                                      fontWeight: FontWeight.w700)),
                            ),
                          ],
                        ),
                      );
                      if (confirm == true && context.mounted) {
                        await authManager.deleteUser(context);
                        GoRouter.of(context).prepareAuthEvent();
                        GoRouter.of(context).clearRedirectLocation();
                        if (context.mounted) {
                          context.goNamedAuth(
                              LogginWidget.routeName, context.mounted);
                        }
                      }
                    },
                  ),
                ] else ...[
                  _drawerTile(
                    icon: Icons.login_rounded,
                    iconBg: _kGreenLight,
                    iconColor: _kGreen,
                    title: 'Iniciar sesión',
                    subtitle: 'Inicia sesión para agregar al carrito',
                    onTap: () {
                      Navigator.pop(context);
                      context.pushNamed(LogginWidget.routeName);
                    },
                  ),
                ],
              ],
            ),
          ),

          // ── Footer ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Text('LeguFrut v1.0',
                style: GoogleFonts.inter(
                    color: _kBorder, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildLoggedInHeader() {
    final hasPhoto = currentUserPhoto.isNotEmpty;
    final initial = currentUserDisplayName.isNotEmpty
        ? currentUserDisplayName[0].toUpperCase()
        : 'U';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Avatar with camera overlay
        Stack(
          clipBehavior: Clip.none,
          children: [
            GestureDetector(
              onTap: _pickProfilePhoto,
              child: CircleAvatar(
                radius: 38,
                backgroundColor: Colors.white.withOpacity(0.2),
                backgroundImage:
                    hasPhoto ? NetworkImage(currentUserPhoto) : null,
                child: !hasPhoto
                    ? Text(initial,
                        style: GoogleFonts.interTight(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                            color: Colors.white))
                    : null,
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: _pickProfilePhoto,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: _kGreen,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: _drawerUploadingPhoto
                      ? const Padding(
                          padding: EdgeInsets.all(5),
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.camera_alt_rounded,
                          size: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Name row
        if (!_drawerEditingName) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  currentUserDisplayName.isNotEmpty
                      ? currentUserDisplayName
                      : 'Sin nombre',
                  style: GoogleFonts.interTight(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.3,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  _drawerNameCtrl.text = currentUserDisplayName;
                  safeSetState(() => _drawerEditingName = true);
                },
                child: const Icon(Icons.edit_rounded,
                    size: 16, color: Colors.white60),
              ),
            ],
          ),
        ] else ...[
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _drawerNameCtrl,
                  autofocus: true,
                  style: GoogleFonts.inter(
                      color: Colors.white, fontSize: 16),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    isDense: true,
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 6),
                    enabledBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.white54)),
                    focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white)),
                    hintText: 'Tu nombre',
                    hintStyle:
                        GoogleFonts.inter(color: Colors.white38),
                  ),
                  onSubmitted: (_) => _saveDisplayName(),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _saveDisplayName,
                child: const Icon(Icons.check_rounded,
                    color: Colors.white, size: 20),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: () =>
                    safeSetState(() => _drawerEditingName = false),
                child: const Icon(Icons.close_rounded,
                    color: Colors.white54, size: 20),
              ),
            ],
          ),
        ],

        const SizedBox(height: 4),
        Text(
          currentUserEmail,
          style: GoogleFonts.inter(color: Colors.white60, fontSize: 13),
        ),
      ],
    );
  }

  Widget _buildLoggedOutHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.person_outline_rounded,
              color: Colors.white, size: 36),
        ),
        const SizedBox(height: 14),
        Text(
          'Bienvenido',
          style: GoogleFonts.interTight(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 4),
        Text(
          'Inicia sesión para gestionar tu cuenta',
          style: GoogleFonts.inter(color: Colors.white60, fontSize: 13),
        ),
      ],
    );
  }

  Widget _drawerTile({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    Color? titleColor,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: iconBg, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: iconColor, size: 20),
      ),
      title: Text(title,
          style: GoogleFonts.interTight(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: titleColor ?? _kText)),
      subtitle: Text(subtitle,
          style: GoogleFonts.inter(fontSize: 12, color: _kMuted)),
      onTap: onTap,
    );
  }

  // ─────────────────────────────────────────────────────────
  //  POPUP OVERLAY
  // ─────────────────────────────────────────────────────────
  Widget _buildPopupOverlay(BuildContext context) {
    return StreamBuilder<List<AppConfigRecord>>(
      stream: queryAppConfigRecord(singleRecord: true),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }
        final config = snapshot.data!.first;
        if (!config.popupEnabled) return const SizedBox.shrink();
        final title = config.popupTitle?.isNotEmpty == true
            ? config.popupTitle!
            : '¡Aviso!';
        final desc1 = config.popupDesc1 ?? '';
        final desc2 = config.popupDesc2 ?? '';

        return Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black.withOpacity(0.55),
          child: Center(
            child: Container(
              width: 320,
              margin: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Green accent header ────────────────────
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 22, 20, 18),
                    decoration: const BoxDecoration(
                      color: _kDarkGreen,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Icon
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.campaign_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.interTight(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // ── Body ──────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(22, 20, 22, 8),
                    child: Column(
                      children: [
                        if (desc1.isNotEmpty)
                          Text(
                            desc1,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.inter(
                              fontSize: 15,
                              color: _kText,
                              height: 1.5,
                            ),
                          ),
                        if (desc1.isNotEmpty && desc2.isNotEmpty)
                          const SizedBox(height: 10),
                        if (desc2.isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 10),
                            decoration: BoxDecoration(
                              color: _kGreenLight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              desc2,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.interTight(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.italic,
                                color: _kDarkGreen,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // ── Button ────────────────────────────────
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
                    child: GestureDetector(
                      onTap: () {
                        FFAppState().showPopup = false;
                        safeSetState(() {});
                      },
                      child: Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.symmetric(vertical: 13),
                        decoration: BoxDecoration(
                          color: _kGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '¡Entendido!',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.interTight(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
}

// ─────────────────────────────────────────────────────────
//  RECIPE DETAIL BOTTOM SHEET
// ─────────────────────────────────────────────────────────
class _RecipeDetailSheet extends StatefulWidget {
  const _RecipeDetailSheet({
    required this.recipe,
    required this.allProducts,
  });
  final _RecipeData recipe;
  final List<ProductsRecord> allProducts;

  @override
  State<_RecipeDetailSheet> createState() => _RecipeDetailSheetState();
}

class _RecipeDetailSheetState extends State<_RecipeDetailSheet> {
  bool _adding = false;

  static const _kGreen = Color(0xFF2E7D32);
  static const _kText = Color(0xFF1A1A1A);
  static const _kMuted = Color(0xFF6B7280);
  static const _kBg = Color(0xFFF8F4EF);
  static const _kBorder = Color(0xFFE5E7EB);

  ProductsRecord? _findProduct(String ingredientName) {
    final lower = ingredientName.toLowerCase().trim();
    if (lower.length < 3) return null;
    // Pass 1: exact match
    for (final p in widget.allProducts) {
      if (p.name.trim().isEmpty) continue;
      if (p.name.toLowerCase().trim() == lower) return p;
    }
    // Pass 2: product name starts with ingredient name
    for (final p in widget.allProducts) {
      if (p.name.trim().isEmpty) continue;
      if (p.name.toLowerCase().trim().startsWith(lower)) return p;
    }
    // Pass 3: product name contains ingredient name (min 5 chars to avoid false matches)
    if (lower.length >= 5) {
      for (final p in widget.allProducts) {
        if (p.name.trim().isEmpty) continue;
        if (p.name.toLowerCase().contains(lower)) return p;
      }
    }
    return null;
  }

  double _ingredientPrice(ProductsRecord product, _RecipeIngredient ing) {
    if (ing.unit == 'g') return product.price * (ing.qty / 1000.0);
    return product.price * ing.qty;
  }

  String _formatQty(double qty, String unit) {
    String q;
    if (qty == qty.truncateToDouble()) {
      q = qty.toInt().toString();
    } else {
      // Remove trailing zeros (e.g. 0.50 → 0.5, 0.250 → 0.25)
      q = qty.toStringAsFixed(3).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    return '$q $unit';
  }

  Future<void> _addAllToCart() async {
    if (_adding) return;
    if (!loggedIn) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Inicia sesión para agregar al carrito',
            style: GoogleFonts.inter(color: Colors.white)),
        backgroundColor: const Color(0xFFFF7043),
        duration: const Duration(seconds: 2),
      ));
      return;
    }
    setState(() => _adding = true);
    int added = 0;
    try {
      for (final ing in widget.recipe.ingredients) {
        final product = _findProduct(ing.name);
        if (product == null) continue;
        final double gramsToAdd;
        final double unitPrice;
        final String unitType;
        if (ing.unit == 'g') {
          gramsToAdd = ing.qty;
          unitPrice = product.price * (ing.qty / 1000.0);
          unitType = 'g';
        } else if (ing.unit == 'pza') {
          gramsToAdd = ing.qty;
          unitPrice = product.price * ing.qty;
          unitType = 'Piezas';
        } else {
          gramsToAdd = ing.qty * 1000;
          unitPrice = product.price * ing.qty;
          unitType = 'kg';
        }
        final results = await queryCartRecordOnce(
          queryBuilder: (q) => q
              .where('productRef', isEqualTo: product.reference)
              .where('userRef', isEqualTo: currentUserReference),
          singleRecord: true,
        );
        final existing = results.isEmpty ? null : results.first;
        if (existing != null) {
          final newGrams = existing.grams + gramsToAdd;
          final newUnitPrice = unitType == 'Piezas'
              ? product.price * newGrams
              : product.price * (newGrams / 1000.0);
          await existing.reference.update(createCartRecordData(
            grams: newGrams,
            unitPrice: newUnitPrice,
            unitType: unitType,
          ));
        } else {
          await CartRecord.collection.doc().set(createCartRecordData(
            productRef: product.reference,
            productName: product.name,
            pricePerKg: product.price,
            grams: gramsToAdd,
            unitPrice: unitPrice,
            createdAt: getCurrentTimestamp,
            coverimage: product.coverImage,
            unitType: unitType,
            userRef: currentUserReference,
          ));
        }
        added++;
      }
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Row(children: [
            const Icon(Icons.check_circle, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              '$added ingrediente${added == 1 ? '' : 's'} agregado${added == 1 ? '' : 's'} al carrito',
              style: GoogleFonts.inter(color: Colors.white, fontSize: 13),
            ),
          ]),
          backgroundColor: _kGreen,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e',
              style: GoogleFonts.inter(color: Colors.white)),
          backgroundColor: Colors.red,
        ));
      }
    } finally {
      if (mounted) setState(() => _adding = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final recipe = widget.recipe;
    final matchedCount =
        recipe.ingredients.where((i) => _findProduct(i.name) != null).length;
    final totalAprox = recipe.ingredients.fold<double>(0.0, (sum, ing) {
      final p = _findProduct(ing.name);
      return p == null ? sum : sum + _ingredientPrice(p, ing);
    });

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: recipe.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                      child: Text(recipe.emoji,
                          style: const TextStyle(fontSize: 28))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(recipe.name,
                          style: GoogleFonts.interTight(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: _kText)),
                      const SizedBox(height: 4),
                      Row(children: [
                        const Icon(Icons.people_outline_rounded,
                            size: 13, color: Color(0xFF6B7280)),
                        const SizedBox(width: 3),
                        Text('${recipe.servings} personas',
                            style: GoogleFonts.inter(
                                fontSize: 12, color: _kMuted)),
                        const SizedBox(width: 10),
                        const Icon(Icons.timer_outlined,
                            size: 13, color: Color(0xFF6B7280)),
                        const SizedBox(width: 3),
                        Text('~${recipe.timeMin} min',
                            style: GoogleFonts.inter(
                                fontSize: 12, color: _kMuted)),
                      ]),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded,
                      color: Color(0xFF9CA3AF)),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          const Divider(height: 24, indent: 20, endIndent: 20),
          // Ingredients title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(children: [
              Text('Ingredientes',
                  style: GoogleFonts.interTight(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _kText)),
              const Spacer(),
              Text(
                '$matchedCount/${recipe.ingredients.length} en tienda',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: matchedCount == recipe.ingredients.length
                      ? _kGreen
                      : const Color(0xFFFF7043),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ]),
          ),
          const SizedBox(height: 10),
          // Ingredient list
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.38),
            child: ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: recipe.ingredients.length,
              itemBuilder: (context, i) {
                final ing = recipe.ingredients[i];
                final product = _findProduct(ing.name);
                final found = product != null;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: found ? Colors.white : const Color(0xFFF5F5F5),
                        border: Border.all(color: _kBorder),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: found && product.coverImage.isNotEmpty
                            ? Image.network(product.coverImage,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => const Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 20,
                                    color: Color(0xFFBDBDBD)))
                            : const Icon(Icons.shopping_basket_outlined,
                                size: 20, color: Color(0xFFBDBDBD)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            found ? product.name : ing.name,
                            style: GoogleFonts.interTight(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: found ? _kText : _kMuted,
                            ),
                          ),
                          if (!found)
                            Text('No disponible',
                                style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: const Color(0xFFFF7043))),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(_formatQty(ing.qty, ing.unit),
                            style: GoogleFonts.interTight(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: _kText)),
                        if (found)
                          Text(
                            '\$${_ingredientPrice(product, ing).toStringAsFixed(0)}',
                            style: GoogleFonts.inter(
                                fontSize: 11,
                                color: _kGreen,
                                fontWeight: FontWeight.w500),
                          ),
                      ],
                    ),
                  ]),
                );
              },
            ),
          ),
          // Total
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 8),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: _kBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _kBorder),
              ),
              child: Row(children: [
                Text('Total aprox.',
                    style: GoogleFonts.inter(fontSize: 13, color: _kMuted)),
                const Spacer(),
                Text('\$${totalAprox.toStringAsFixed(0)}',
                    style: GoogleFonts.interTight(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: _kText)),
              ]),
            ),
          ),
          // Add to cart button
          Padding(
            padding: EdgeInsets.fromLTRB(
                20, 0, 20, MediaQuery.of(context).padding.bottom + 16),
            child: GestureDetector(
              onTap: matchedCount > 0 && !_adding ? _addAllToCart : null,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: matchedCount > 0
                      ? (_adding
                          ? _kGreen.withOpacity(0.6)
                          : _kGreen)
                      : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: _adding
                    ? const Center(
                        child: SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.white)),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_cart_outlined,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            matchedCount > 0
                                ? 'Agregar $matchedCount ingrediente${matchedCount == 1 ? '' : 's'} al carrito'
                                : 'Sin productos disponibles',
                            style: GoogleFonts.interTight(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Colors.white),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

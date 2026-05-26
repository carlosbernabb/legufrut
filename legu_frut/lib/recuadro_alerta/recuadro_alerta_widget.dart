import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'recuadro_alerta_model.dart';
export 'recuadro_alerta_model.dart';

class RecuadroAlertaWidget extends StatefulWidget {
  const RecuadroAlertaWidget({super.key});

  static String routeName = 'RecuadroAlerta';
  static String routePath = '/recuadroAlerta';

  @override
  State<RecuadroAlertaWidget> createState() => _RecuadroAlertaWidgetState();
}

class _RecuadroAlertaWidgetState extends State<RecuadroAlertaWidget> {
  late RecuadroAlertaModel _model;

  static const _kDarkGreen = Color(0xFF2D5016);
  static const _kGreen = Color(0xFF2E7D32);
  static const _kGreenLight = Color(0xFFE8F5E9);
  static const _kBg = Color(0xFFF8F4EF);
  static const _kText = Color(0xFF1A1A1A);
  static const _kMuted = Color(0xFF6B7280);
  static const _kBorder = Color(0xFFE5E7EB);

  bool _popupEnabled = false;
  bool _popupEnabledInitialized = false;
  bool _carnasEnabled = false;
  bool _carnasEnabledInitialized = false;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RecuadroAlertaModel());
    _model.titulotextTextController ??= TextEditingController();
    _model.titulotextFocusNode ??= FocusNode();
    _model.description1TextController ??= TextEditingController();
    _model.description1FocusNode ??= FocusNode();
    _model.description2TextController ??= TextEditingController();
    _model.description2FocusNode ??= FocusNode();

    // Listen for changes to trigger live preview rebuild
    _model.titulotextTextController!.addListener(() => safeSetState(() {}));
    _model.description1TextController!.addListener(() => safeSetState(() {}));
    _model.description2TextController!.addListener(() => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _save(AppConfigRecord config) async {
    safeSetState(() => _model.isSaving = true);
    await config.reference.update(createAppConfigRecordData(
      popupEnabled: _popupEnabled,
      popupTitle: _model.titulotextTextController!.text.trim(),
      popupDesc1: _model.description1TextController!.text.trim(),
      popupDesc2: _model.description2TextController!.text.trim(),
      carnasEnabled: _carnasEnabled,
    ));
    safeSetState(() => _model.isSaving = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle_rounded,
                  color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text('Aviso actualizado correctamente',
                  style: GoogleFonts.inter(color: Colors.white)),
            ],
          ),
          backgroundColor: _kGreen,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return StreamBuilder<List<AppConfigRecord>>(
      stream: queryAppConfigRecord(singleRecord: true),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: _kBg,
            body: const Center(
              child: CircularProgressIndicator(color: _kGreen),
            ),
          );
        }

        final config = snapshot.data!.isEmpty ? null : snapshot.data!.first;

        // Pre-fill controllers once from Firestore (only if empty)
        if (config != null) {
          if (!_popupEnabledInitialized) {
            _popupEnabledInitialized = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              safeSetState(() => _popupEnabled = config.popupEnabled);
            });
          }
          if (!_carnasEnabledInitialized) {
            _carnasEnabledInitialized = true;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              safeSetState(() => _carnasEnabled = config.carnasEnabled);
            });
          }
          if (_model.titulotextTextController!.text.isEmpty &&
              (config.popupTitle?.isNotEmpty ?? false)) {
            _model.titulotextTextController!.text = config.popupTitle!;
          }
          if (_model.description1TextController!.text.isEmpty &&
              (config.popupDesc1?.isNotEmpty ?? false)) {
            _model.description1TextController!.text = config.popupDesc1!;
          }
          if (_model.description2TextController!.text.isEmpty &&
              (config.popupDesc2?.isNotEmpty ?? false)) {
            _model.description2TextController!.text = config.popupDesc2!;
          }
        }

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: _kBg,
            appBar: AppBar(
              backgroundColor: _kDarkGreen,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded,
                    color: Colors.white),
                onPressed: () =>
                    context.pushNamed(AdminHubWidget.routeName),
              ),
              title: Text(
                'Alerta Principal',
                style: GoogleFonts.interTight(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            body: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Live preview ─────────────────────────
                  _sectionLabel('Vista previa'),
                  const SizedBox(height: 10),
                  _buildPreviewCard(),
                  const SizedBox(height: 28),

                  // ── Categorías ───────────────────────────
                  _sectionLabel('Categorías'),
                  const SizedBox(height: 12),

                  // Toggle Carnes
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: _carnasEnabled
                                  ? const Color(0xFFFBE9E7)
                                  : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.restaurant_rounded,
                              color: _carnasEnabled
                                  ? const Color(0xFFBF360C)
                                  : _kMuted,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Categoría Carnes',
                                  style: GoogleFonts.interTight(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: _kText,
                                  ),
                                ),
                                Text(
                                  _carnasEnabled
                                      ? 'Visible en la app'
                                      : 'Oculta — actívala cuando estés listo',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: _kMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _carnasEnabled,
                            onChanged: (v) =>
                                safeSetState(() => _carnasEnabled = v),
                            activeColor: const Color(0xFFBF360C),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 28),

                  // ── Form ─────────────────────────────────
                  _sectionLabel('Editar contenido'),
                  const SizedBox(height: 12),

                  // Toggle popup on/off
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: _popupEnabled
                                  ? _kGreenLight
                                  : const Color(0xFFF3F4F6),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              _popupEnabled
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              color: _popupEnabled ? _kGreen : _kMuted,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mostrar aviso en la app',
                                  style: GoogleFonts.interTight(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: _kText,
                                  ),
                                ),
                                Text(
                                  _popupEnabled
                                      ? 'El aviso aparece al abrir la app'
                                      : 'El aviso está oculto',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: _kMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: _popupEnabled,
                            onChanged: (v) =>
                                safeSetState(() => _popupEnabled = v),
                            activeColor: _kGreen,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  _buildField(
                    controller: _model.titulotextTextController!,
                    focusNode: _model.titulotextFocusNode!,
                    label: 'Título del aviso',
                    hint: 'Ej: ¡Aviso importante!',
                    icon: Icons.title_rounded,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 12),

                  _buildField(
                    controller: _model.description1TextController!,
                    focusNode: _model.description1FocusNode!,
                    label: 'Descripción principal',
                    hint:
                        'Ej: Los pedidos se entregarán al día siguiente de ser procesados.',
                    icon: Icons.subject_rounded,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 12),

                  _buildField(
                    controller: _model.description2TextController!,
                    focusNode: _model.description2FocusNode!,
                    label: 'Nota adicional (destacada)',
                    hint:
                        'Ej: Pedidos antes de las 12:00 serán entregados ese mismo día.',
                    icon: Icons.info_outline_rounded,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 28),

                  // ── Save button ───────────────────────────
                  GestureDetector(
                    onTap: config != null && !_model.isSaving
                        ? () => _save(config)
                        : null,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: _model.isSaving
                            ? _kGreen.withOpacity(0.6)
                            : _kGreen,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: _kGreen.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_model.isSaving)
                            const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white),
                            )
                          else
                            const Icon(Icons.save_rounded,
                                color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            _model.isSaving
                                ? 'Guardando...'
                                : 'Guardar cambios',
                            style: GoogleFonts.interTight(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
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

  // ── Live preview card (mirrors the home popup) ─────────
  Widget _buildPreviewCard() {
    final title = _model.titulotextTextController!.text.isNotEmpty
        ? _model.titulotextTextController!.text
        : '¡Aviso!';
    final desc1 = _model.description1TextController!.text;
    final desc2 = _model.description2TextController!.text;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
            decoration: const BoxDecoration(
              color: _kDarkGreen,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.campaign_rounded,
                      color: Colors.white, size: 22),
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.interTight(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Column(
              children: [
                if (desc1.isNotEmpty)
                  Text(
                    desc1,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontSize: 13, color: _kText, height: 1.5),
                  ),
                if (desc1.isNotEmpty && desc2.isNotEmpty)
                  const SizedBox(height: 8),
                if (desc2.isNotEmpty)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: _kGreenLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      desc2,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.interTight(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontStyle: FontStyle.italic,
                        color: _kDarkGreen,
                      ),
                    ),
                  ),
                if (desc1.isEmpty && desc2.isEmpty)
                  Text(
                    'El contenido aparecerá aquí...',
                    style:
                        GoogleFonts.inter(color: _kBorder, fontSize: 13),
                  ),
              ],
            ),
          ),
          // Button preview
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: _kGreen,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '¡Entendido!',
                textAlign: TextAlign.center,
                style: GoogleFonts.interTight(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.interTight(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: _kMuted,
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLines: maxLines,
        style: GoogleFonts.inter(fontSize: 14, color: _kText),
        cursorColor: _kGreen,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.inter(color: _kMuted, fontSize: 13),
          hintText: hint,
          hintStyle:
              GoogleFonts.inter(color: _kBorder, fontSize: 13),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 12, right: 8),
            child: Icon(icon, color: _kGreen, size: 20),
          ),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 44, minHeight: 44),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _kGreen, width: 1.5),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        ),
      ),
    );
  }
}

import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_count_controller.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
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

class _UniversalProductCardWidgetState extends State<UniversalProductCardWidget>
    with TickerProviderStateMixin {
  late UniversalProductCardModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UniversalProductCardModel());

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 600.0.ms,
            begin: Offset(60.0, 0.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  bool get _isPieceType {
    final type = widget.saleType?.toLowerCase() ?? '';
    return type.contains('pieza') || type.contains('unidad') || type == 'por pieza' || type.contains('piece');
  }

  @override
  Widget build(BuildContext context) {
    // Logic for Price Display
    double calculatePrice() {
      if (_isPieceType) {
        return (widget.price ?? 0.0) * (_model.pieces ?? 1);
      } else {
        return (widget.price ?? 0.0) *
            ((_model.kilosInt ?? 0) + (_model.gramsint ?? 0) / 1000.0);
      }
    }

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.0, 8.0, 0.0, 0.0),
      child: Container(
        width: 210.4,
        height: 385.0, // Optimized height to fit content without excess whitespace
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          boxShadow: [
            BoxShadow(
              blurRadius: 8.0,
              color: Color(0x230F1113),
              offset: Offset(
                0.0,
                4.0,
              ),
            )
          ],
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: FlutterFlowTheme.of(context).primaryBackground,
            width: 1.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: Image.network(
                widget.coverimage ?? '',
                width: double.infinity,
                height: 117.2,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/error_image.jpg',
                  width: double.infinity,
                  height: 117.2,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(12.0, 10.0, 12.0, 12.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 5.0, 0.0, 5.0),
                        child: Text(
                          widget.productname ?? 'Producto',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              FlutterFlowTheme.of(context).bodyLarge.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyLarge
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                  ),
                        ),
                      ),
                      // Price Tag
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
                        child: Container(
                          width: 100.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            color: FlutterFlowTheme.of(context).primaryText,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                2.0, 0.0, 2.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5.0, 0.0, 5.0, 0.0),
                                  child: Text(
                                    valueOrDefault<String>(
                                      formatNumber(
                                        calculatePrice(),
                                        formatType: FormatType.decimal,
                                        decimalType: DecimalType.periodDecimal,
                                        currency: '\$',
                                      ),
                                      '\$',
                                    ),
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryBackground,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // CONTROLS
                      if (_isPieceType)
                        // Use Piece Controls
                        Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 5.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: 90.0,
                                height: 40.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                                  borderRadius: BorderRadius.circular(8.0),
                                  shape: BoxShape.rectangle,
                                ),
                                child: FlutterFlowCountController(
                                  decrementIconBuilder: (enabled) => Icon(
                                    Icons.remove_rounded,
                                    color: enabled
                                        ? Color(0xFF006701)
                                        : Color(0xFFFF0000),
                                    size: 15.0,
                                  ),
                                  incrementIconBuilder: (enabled) => Icon(
                                    Icons.add_rounded,
                                    color: enabled
                                        ? Color(0xFF006701)
                                        : Color(0xFFFF0000),
                                    size: 15.0,
                                  ),
                                  countBuilder: (count) => Text(
                                    count.toString(),
                                    style: FlutterFlowTheme.of(context)
                                        .titleLarge // Adjusted font size in orig
                                        .override(
                                          font: GoogleFonts.interTight(),
                                          fontSize: 15.0,
                                          letterSpacing: 0.0,
                                        ),
                                  ),
                                  count: _model.countControlPiecesValue ??=
                                      _model.pieces!,
                                  updateCount: (count) async {
                                    safeSetState(() =>
                                        _model.countControlPiecesValue = count);
                                    _model.pieces =
                                        _model.countControlPiecesValue;
                                    safeSetState(() {});
                                  },
                                  stepSize: 1,
                                  minimum: 0,
                                  maximum: 1000,
                                  contentPadding: EdgeInsetsDirectional.fromSTEB(
                                      12.0, 0.0, 12.0, 0.0),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 4.0, 0.0),
                                child: Text(
                                  ' Piezas',
                                  style: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        font: GoogleFonts.interTight(
                                            fontWeight: FontWeight.w500),
                                        fontSize: 15.0,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        // Use Weight Controls (Kilos + Grams)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Kilos
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 90.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: FlutterFlowCountController(
                                      decrementIconBuilder: (enabled) => Icon(
                                        Icons.remove_rounded,
                                        color: enabled
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryText
                                            : Color(0xFFFF0000),
                                        size: 15.0,
                                      ),
                                      incrementIconBuilder: (enabled) => Icon(
                                        Icons.add_rounded,
                                        color: enabled
                                            ? Color(0xFF006701)
                                            : Color(0xFFFF0000),
                                        size: 15.0,
                                      ),
                                      countBuilder: (count) => Text(
                                        count.toString(),
                                        style: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .override(
                                              font: GoogleFonts.interTight(),
                                              fontSize: 15.0,
                                            ),
                                      ),
                                      count: _model.kiloscounterValue ??=
                                          _model.kilosInt!,
                                      updateCount: (count) async {
                                        safeSetState(() =>
                                            _model.kiloscounterValue = count);
                                        _model.kilosInt =
                                            _model.kiloscounterValue;
                                        safeSetState(() {});
                                      },
                                      stepSize: 1,
                                      minimum: 0,
                                      maximum: 10000000,
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              12.0, 0.0, 12.0, 0.0),
                                    ),
                                  ),
                                  Text(
                                    ' Kilos',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          font: GoogleFonts.interTight(
                                              fontWeight: FontWeight.w500),
                                          fontSize: 15.0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            // Grams
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 5.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: 90.0,
                                    height: 40.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .secondaryBackground,
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                    child: FlutterFlowCountController(
                                      decrementIconBuilder: (enabled) => Icon(
                                        Icons.remove_rounded,
                                        color: enabled
                                            ? FlutterFlowTheme.of(context)
                                                .secondaryText
                                            : Color(0xFFFF0000),
                                        size: 15.0,
                                      ),
                                      incrementIconBuilder: (enabled) => Icon(
                                        Icons.add_rounded,
                                        color: enabled
                                            ? Color(0xFF006701)
                                            : Color(0xFFFF0000),
                                        size: 15.0,
                                      ),
                                      countBuilder: (count) => Text(
                                        count.toString(),
                                        style: FlutterFlowTheme.of(context)
                                            .titleLarge
                                            .override(
                                              font: GoogleFonts.interTight(),
                                              fontSize: 15.0,
                                            ),
                                      ),
                                      count: _model.gramscounterValue ??=
                                          _model.gramsint!,
                                      updateCount: (count) async {
                                        safeSetState(() =>
                                            _model.gramscounterValue = count);
                                        _model.gramsint =
                                            _model.gramscounterValue;
                                        safeSetState(() {});
                                      },
                                      stepSize: 100,
                                      minimum: 0,
                                      maximum: 10000000,
                                      contentPadding:
                                          EdgeInsetsDirectional.fromSTEB(
                                              12.0, 0.0, 12.0, 0.0),
                                    ),
                                  ),
                                  Text(
                                    ' gramos',
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          font: GoogleFonts.interTight(
                                              fontWeight: FontWeight.w500),
                                          fontSize: 15.0,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                      // ADD TO CART BUTTON
                      FFButtonWidget(
                        onPressed: () async {
                          // QUERY EXISTING
                          _model.existingItem = await queryCartRecordOnce(
                            queryBuilder: (cartRecord) => cartRecord
                                .where(
                                  'productRef',
                                  isEqualTo: widget.productRef,
                                )
                                .where(
                                  'userRef',
                                  isEqualTo: currentUserReference,
                                ),
                            singleRecord: true,
                          ).then((s) => s.firstOrNull);

                          if (_isPieceType) {
                            // PIECES LOGIC
                            if (_model.existingItem?.reference != null) {
                              await _model.existingItem!.reference
                                  .update(createCartRecordData(
                                grams: _model.existingItem!.grams +
                                    _model.pieces!.toDouble(),
                                unitPrice: (widget.price!) *
                                    (_model.existingItem!.grams +
                                        _model.pieces!.toDouble()),
                              ));
                            } else {
                              await CartRecord.collection
                                  .doc()
                                  .set(createCartRecordData(
                                    productRef: widget.productRef,
                                    productName: widget.productname,
                                    createdAt: getCurrentTimestamp,
                                    coverimage: widget.coverimage,
                                    grams: _model.pieces?.toDouble(),
                                    unitPrice: (widget.price!) *
                                        _model.pieces!.toDouble(),
                                    userRef: currentUserReference,
                                    unitType: 'Piezas',
                                    pricePerKg: widget.price, // Store 'unit price' here for pieces too? Productcard uses it.
                                  ));
                            }
                            // Reset Pieces
                            _model.pieces = 1;
                            safeSetState(() => _model.countControlPiecesValue = 1);

                          } else {
                            // WEIGHT LOGIC
                            final double totalKilosInCart = 
                              (_model.kilosInt! * 1000 + _model.gramsint!) / 1000.0;
                            final double totalGramsToAdd = 
                              (_model.kilosInt! * 1000 + _model.gramsint!).toDouble();

                            if (_model.existingItem?.reference != null) {
                              // Existing text in ProductcardWidget was:
                              // grams: ((_model.kilosInt!) * 1000) + _model.existingItem!.grams + _model.gramsint!.toDouble()
                              // This assumes kilosInt is just the NEW amount.
                              // Correct.
                              
                              await _model.existingItem!.reference
                                  .update(createCartRecordData(
                                grams: _model.existingItem!.grams + totalGramsToAdd,
                                unitPrice: (widget.price!) *
                                    (_model.existingItem!.grams + totalGramsToAdd) / 1000.0,
                              ));
                            } else {
                              await CartRecord.collection
                                  .doc()
                                  .set(createCartRecordData(
                                    productRef: widget.productRef,
                                    productName: widget.productname,
                                    pricePerKg: widget.price,
                                    unitType: 'Gramos',
                                    createdAt: getCurrentTimestamp,
                                    coverimage: widget.coverimage,
                                    grams: totalGramsToAdd,
                                    unitPrice: (widget.price!) * totalKilosInCart,
                                    userRef: currentUserReference,
                                  ));
                            }
                            
                            // Reset Weight
                            _model.gramsint = 0;
                            _model.kilosInt = 1;
                            safeSetState(() {
                               _model.kiloscounterValue = 1;
                               _model.gramscounterValue = 0;
                            });
                          }

                          safeSetState(() {});

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Agregado al Carrito',
                                style: FlutterFlowTheme.of(context)
                                    .headlineMedium
                                    .override(
                                      font: GoogleFonts.interTight(),
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                      fontSize: 15.0,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              duration: Duration(milliseconds: 3550),
                              backgroundColor: Color(0xFFCBE4FC),
                            ),
                          );
                        },
                        text: 'Agregar al carrito',
                        options: FFButtonOptions(
                          height: 31.2,
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 0.0, 16.0, 0.0),
                          color: FlutterFlowTheme.of(context).primaryText,
                          textStyle:
                              FlutterFlowTheme.of(context).titleSmall.override(
                                    font: GoogleFonts.interTight(),
                                    color: Colors.white,
                                  ),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ],
                  ),),
                ],
              ),
            ),
          ],
        ),
      ).animateOnPageLoad(animationsMap['containerOnPageLoadAnimation']!),
    );
  }
}
